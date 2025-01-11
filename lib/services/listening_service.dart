import 'package:cloud_firestore/cloud_firestore.dart';

class ListeningService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Future<List<Map<String, dynamic>>> getLessons() async {
  //   try {
  //     final snapshot = await _db.collection('lessons').get();
  //     return snapshot.docs.map((doc) {
  //       final data = doc.data() as Map<String, dynamic>;
  //       return {
  //         'id': doc.id,
  //         'title': data['title'] ?? '',
  //         'sections': data['sections'] ?? {},
  //       };
  //     }).toList();
  //   } catch (e) {
  //     print("Lỗi khi lấy lessons: $e");
  //     return [];
  //   }
  // }
  Future<List<Map<String, dynamic>>> getLessons() async {
    try {
      final snapshot = await _db.collection('lessons').get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final sections = (data['sections'] as Map<String, dynamic>?) ?? {};

        // Sắp xếp sections theo key
        final sortedSections = sections.entries.toList()
          ..sort((a, b) => a.key.compareTo(b.key));

        return {
          'id': doc.id,
          'title': data['title'] ?? '',
          'sections': sortedSections.map((e) => e.value).toList(), // Trả về List
        };
      }).toList();
    } catch (e) {
      print("Lỗi khi lấy lessons: $e");
      return [];
    }
  }
}