import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_cipher/utils/model.dart';

class Subcollection<T extends Model> {
  final String parentCollection;
  final String parentId;
  final String subcollectionName;
  final T Function(String id, Map<String, dynamic>) modelBuilder;

  Subcollection({
    required this.parentCollection,
    required this.parentId,
    required this.subcollectionName,
    required this.modelBuilder,
  });

  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  Future<T> create(Map<String, dynamic> data) async {
    var docRef = await _firestore
        .collection(parentCollection)
        .doc(parentId)
        .collection(subcollectionName)
        .add({
      ...data,
      'created_at': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
    });
    T model = modelBuilder(docRef.id, data);
    return model;
  }

  Future<List<T>> getAll() async {
    var querySnapshot = await _firestore
        .collection(parentCollection)
        .doc(parentId)
        .collection(subcollectionName)
        .get();
    return querySnapshot.docs
        .map((doc) => modelBuilder(doc.id, doc.data()))
        .cast<T>()
        .toList();
  }
    Future<void> update(String docId, Map<String, dynamic> data) async {
    await _firestore
        .collection(parentCollection)
        .doc(parentId)
        .collection(subcollectionName)
        .doc(docId)
        .update({
      ...data,
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  Future<void> delete(String docId) async {
    await _firestore
        .collection(parentCollection)
        .doc(parentId)
        .collection(subcollectionName)
        .doc(docId)
        .delete();
  }
}
