import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/lesson.dart';


class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Lesson> getLesson(String lessonId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('lessons').doc(lessonId).get();

      if (doc.exists) {
        var data = doc.data() as Map<String, dynamic>;
        return Lesson.fromJson(data);
      } else {
        throw Exception('Lesson not found');
      }
    } catch (e) {
      throw Exception('Error fetching lesson: $e');
    }
  }
}