import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:project_cipher/utils/circuit_breaker.dart';
import 'package:project_cipher/utils/subcollection.dart';

Future<bool> hasInternetConnection() async {
  final results = await Connectivity().checkConnectivity();
  return !results.contains(ConnectivityResult.none);
}

abstract class Model {
  String? id;
  Timestamp? createdAt;
  Timestamp? updatedAt;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Model({this.id, this.createdAt, this.updatedAt});

  /// Convierte el modelo en un mapa (JSON)
  Map<String, dynamic> toJson();

  /// Crea un modelo desde un JSON
  Model fromJson(Map<String, dynamic> json);

  /// Nombre de la colección (debe implementarse en cada modelo)
  String get collectionName;

  /// **Crea un nuevo documento**
  Future<void> create() async {
    var docRef = await _firestore.collection(collectionName).add({
      ...toJson(),
      'created_at': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
    });
    id = docRef.id;
  }

  /// **Actualiza un documento existente**
  Future<void> update(Map<String, dynamic> data) async {
    if (id == null) throw Exception("El registro no tiene un ID.");
    Map<String, dynamic> toUpdate = Map.from(data)..remove('id');
    await _firestore
        .collection(collectionName)
        .doc(id)
        .update({...toUpdate, 'updated_at': FieldValue.serverTimestamp()});
    // Actualiza la instancia en memoria después de la actualización
    var updatedDoc = await _firestore.collection(collectionName).doc(id).get();
    if (updatedDoc.exists && updatedDoc.data() != null) {
      var updatedData = updatedDoc.data()!;
      id = updatedDoc.id;
      updatedData.forEach((key, value) {
        if (toJson().containsKey(key)) {
          toJson()[key] = value; // Sincroniza los valores en memoria
        }
      });
    }
  }

  /// **Guarda (Crea o Actualiza un registro)**
  Future<void> save() async {
    if (id == null) {
      await create(); // Crea el documento si no tiene ID
    } else {
      await update(toJson()); // Actualiza si ya existe
    }
  }

  /// **Elimina un registro**
  Future<void> delete() async {
    if (id == null) throw Exception("El registro no tiene un ID.");
    await CircuitBreaker.retry(
        () => _firestore.collection(collectionName).doc(id).delete());
  }

  // Metodo para obtener un documento relacionado (con referencia a otro documento)
  Future<List<T>> getRelatedDocument<T extends Model>({
    required String collection,
    required T Function(String id, Map<String, dynamic>) fromJson,
  }) async {
    try {
      final useCache = !(await hasInternetConnection());
      final options = useCache
          ? const GetOptions(source: Source.cache)
          : const GetOptions(source: Source.serverAndCache);
      var querySnapshot = await CircuitBreaker.retry(() => _firestore
          .collection(collectionName)
          .doc(id)
          .collection(collection)
          .get(options));
      return querySnapshot.docs
          .map((doc) => fromJson(doc.id, doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Error getting related document: $e');
    }
  }

  // Metodo para obtener los documentos de una colección filtrada por un campo
  Future<List<T>> getDocumentsByField<T extends Model>(
      {required String collection,
      String field = 'id',
      String? value = '',
      required T Function(String id, Map<String, dynamic>) fromJson}) async {
    try {
      final useCache = !(await hasInternetConnection());
      final options = useCache
          ? const GetOptions(source: Source.cache)
          : const GetOptions(source: Source.serverAndCache);
      var querySnapshot = await CircuitBreaker.retry(() => _firestore
          .collection(collection)
          .where(field, isEqualTo: value)
          .get(options));
      return querySnapshot.docs
          .map((doc) => fromJson(doc.id, doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Error getting documents by field: $e');
    }
  }

  /// **Busca un registro por ID**
  static Future<T?> find<T extends Model>({
    required String collectionName,
    required String id,
    required T Function(String id, Map<String, dynamic>) fromJson,
  }) async {
    final useCache = !(await hasInternetConnection());
    final options = useCache
        ? const GetOptions(source: Source.cache)
        : const GetOptions(source: Source.serverAndCache);
    var doc = await CircuitBreaker.retry(
        () => _firestore.collection(collectionName).doc(id).get(options));
    if (!doc.exists || doc.data() == null) {
      return null; // Evita error si `doc.data()` es null.
    }
    return fromJson(doc.id, doc.data()!);
  }

  /// **Obtiene todos los registros**
  static Future<List<T>> all<T extends Model>({
    required String collectionName,
    required T Function(String id, Map<String, dynamic>) fromJson,
  }) async {
    final useCache = !(await hasInternetConnection());
    final options = useCache
        ? const GetOptions(source: Source.cache)
        : const GetOptions(source: Source.serverAndCache);
    var querySnapshot = await CircuitBreaker.retry(
        () => _firestore.collection(collectionName).get(options));
    return querySnapshot.docs
        .map((doc) => fromJson(doc.id, doc.data()))
        .toList();
  }

  /// **Filtra registros por un campo**
  static Future<List<T>> where<T extends Model>({
    required String collectionName,
    required String field,
    required dynamic value,
    required T Function(String id, Map<String, dynamic>) fromJson,
  }) async {
    final useCache = !(await hasInternetConnection());
    final options = useCache
        ? const GetOptions(source: Source.cache)
        : const GetOptions(source: Source.serverAndCache);
    var querySnapshot = await CircuitBreaker.retry(() => _firestore
        .collection(collectionName)
        .where(field, isEqualTo: value)
        .get(options));
    return querySnapshot.docs
        .map((doc) => fromJson(doc.id, doc.data()))
        .toList();
  }

  /// **Obtiene el primer registro que cumpla con la condición**
  static Future<T?> firstWhere<T extends Model>({
    required String collectionName,
    required String field,
    required dynamic value,
    required T Function(String id, Map<String, dynamic>) fromJson,
  }) async {
    final useCache = !(await hasInternetConnection());
    final options = useCache
        ? const GetOptions(source: Source.cache)
        : const GetOptions(source: Source.serverAndCache);
    var querySnapshot = await CircuitBreaker.retry(() => _firestore
        .collection(collectionName)
        .where(field, isEqualTo: value)
        .limit(1)
        .get(options));
    if (querySnapshot.docs.isEmpty) return null;
    var doc = querySnapshot.docs.first;
    return fromJson(doc.id, doc.data());
  }

  /// **Verifica si existe al menos un registro con la condición**
  static Future<bool> exists<T extends Model>({
    required String collectionName,
    required String field,
    required dynamic value,
  }) async {
    final useCache = !(await hasInternetConnection());
    final options = useCache
        ? const GetOptions(source: Source.cache)
        : const GetOptions(source: Source.serverAndCache);
    var querySnapshot = await CircuitBreaker.retry(() => _firestore
        .collection(collectionName)
        .where(field, isEqualTo: value)
        .limit(1)
        .get(options));
    return querySnapshot.docs.isNotEmpty;
  }

  /// **Cuenta el número de registros en una colección**
  static Future<int> count<T extends Model>({
    required String collectionName,
  }) async {
    final useCache = !(await hasInternetConnection());
    final options = useCache
        ? const GetOptions(source: Source.cache)
        : const GetOptions(source: Source.serverAndCache);
    var querySnapshot = await CircuitBreaker.retry(
        () => _firestore.collection(collectionName).get(options));
    return querySnapshot.size;
  }

  /// **Ordena los registros por un campo**
  static Future<List<T>> orderBy<T extends Model>({
    required String collectionName,
    required String field,
    bool descending = false,
    required T Function(String id, Map<String, dynamic>) fromJson,
  }) async {
    final useCache = !(await hasInternetConnection());
    final options = useCache
        ? const GetOptions(source: Source.cache)
        : const GetOptions(source: Source.serverAndCache);
    var querySnapshot = await CircuitBreaker.retry(() => _firestore
        .collection(collectionName)
        .orderBy(field, descending: descending)
        .get(options));
    return querySnapshot.docs
        .map((doc) => fromJson(doc.id, doc.data()))
        .toList();
  }

  /// **Limita la cantidad de registros obtenidos**
  static Future<List<T>> limit<T extends Model>({
    required String collectionName,
    required int count,
    required T Function(String id, Map<String, dynamic>) fromJson,
  }) async {
    final useCache = !(await hasInternetConnection());
    final options = useCache
        ? const GetOptions(source: Source.cache)
        : const GetOptions(source: Source.serverAndCache);
    var querySnapshot = await CircuitBreaker.retry(
        () => _firestore.collection(collectionName).limit(count).get(options));
    return querySnapshot.docs
        .map((doc) => fromJson(doc.id, doc.data()))
        .toList();
  }

  static Subcollection<T> relations<T extends Model>(
    List<dynamic> segments, {
    required T Function(String id, Map<String, dynamic>) modelBuilder,
  }) {
    List<String> pathSegments = [];

    for (var segment in segments) {
      if (segment is List && segment.length == 2) {
        // ['sawed', sawedId]
        pathSegments.add(segment[0]);
        pathSegments.add(segment[1]);
      } else if (segment is String) {
        // 'details'
        pathSegments.add(segment);
      } else {
        throw ArgumentError(
          'Invalid segment: must be a string or [collection, id]',
        );
      }
    }

    return Subcollection<T>.internal(pathSegments, modelBuilder);
  }
}
