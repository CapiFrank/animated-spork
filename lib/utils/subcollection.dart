import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:project_cipher/utils/model.dart';

class Subcollection<T extends Model> {
  final List<String> _pathSegments;
  final T Function(String id, Map<String, dynamic>) modelBuilder;

  Subcollection({
    required String parentCollection,
    required String parentId,
    required String subcollectionName,
    required this.modelBuilder,
  }) : _pathSegments = [parentCollection, parentId, subcollectionName];

  Subcollection.internal(this._pathSegments, this.modelBuilder);

  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  Future<bool> hasInternetConnection() async {
    final results = await Connectivity().checkConnectivity();
    return !results.contains(ConnectivityResult.none);
  }

  /// Crea un documento
  Future<T> create(Map<String, dynamic> data) async {
    final colRef = _firestore.collection(_pathSegments.join('/'));
    final docRef = await colRef.add({
      ...data,
      'created_at': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
    });
    return modelBuilder(docRef.id, data);
  }

  /// Obtiene todos los documentos
  Future<List<T>> getAll() async {
    final colRef = _firestore.collection(_pathSegments.join('/'));
    final useCache = !(await hasInternetConnection());
      final options = useCache
          ? const GetOptions(source: Source.cache)
          : const GetOptions(source: Source.serverAndCache);
    final snapshot = await colRef.get(options);
    return snapshot.docs
        .map((doc) => modelBuilder(doc.id, doc.data()))
        .toList();
  }

  /// Busca un documento por ID
  Future<T?> find(String docId) async {
    final docRef = _firestore.doc([..._pathSegments, docId].join('/'));
    final useCache = !(await hasInternetConnection());
      final options = useCache
          ? const GetOptions(source: Source.cache)
          : const GetOptions(source: Source.serverAndCache);
    final snapshot = await docRef.get(options);
    if (!snapshot.exists || snapshot.data() == null) return null;
    return modelBuilder(snapshot.id, snapshot.data()!);
  }

  /// Actualiza un documento
  Future<void> update(String docId, Map<String, dynamic> data) async {
    final docRef = _firestore.doc([..._pathSegments, docId].join('/'));
    await docRef.update({
      ...data,
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  /// Elimina un documento
  Future<void> delete(String docId) async {
    final docRef = _firestore.doc([..._pathSegments, docId].join('/'));
    await docRef.delete();
  }
}
