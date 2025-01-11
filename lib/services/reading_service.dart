
import 'package:cloud_firestore/cloud_firestore.dart';

class ReadingService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Thêm ReadingModel vào Firestore
  Future<List<Map<String, dynamic>>> getReadings() async {
    try {
      final snapshot = await _db.collection('readings').get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'id':doc.id,
          'title': data['title'],
          'level': data['level'],
          'content': data['content'],
          'translation':data['translation'],
          'vocabulary': data['vocabulary'],
          'questions': data['questions'],
        };
      }).toList();
    }catch (e) {
      print("Lỗi khi lấy lessons: $e");
      return [];
    }
  }
}