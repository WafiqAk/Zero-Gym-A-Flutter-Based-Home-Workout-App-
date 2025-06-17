import 'package:cloud_firestore/cloud_firestore.dart';

class DBConfig {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add a new exercise
  Future<void> addExercise(Map<String, dynamic> exerciseData) async {
    await _db.collection('exercises').add(exerciseData);
  }

  // Add multiple exercise
  Future<void> addMultipleExercises(List<Map<String, dynamic>> exercises) async {
    WriteBatch batch = _db.batch();

    for (var exercise in exercises) {
      final docRef = _db.collection('exercises').doc(); // auto-ID
      batch.set(docRef, exercise);
    }

    await batch.commit();
    //print('Uploaded ${exercises.length} exercises!');
  }

  // Get all exercises as a stream (for StreamBuilder)
  Stream<List<Map<String, dynamic>>> getExercisesStream() {
    return _db.collection('exercises').snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => doc.data()).toList());
  }

  // Get all exercises once (for FutureBuilder or manual use)
  Future<List<Map<String, dynamic>>> getAllExercises() async {
    final snapshot = await _db.collection('exercises').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  // Update an exercise by ID
  Future<void> updateExercise(String id, Map<String, dynamic> updatedData) async {
    await _db.collection('exercises').doc(id).update(updatedData);
  }

  // Delete an exercise by ID
  Future<void> deleteExercise(String id) async {
    await _db.collection('exercises').doc(id).delete();
  }
}
