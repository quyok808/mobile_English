import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FlashcardService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // /// Thêm flashcard vào Firestore
  // Future<void> addFlashcard(String word, String description, String pronounce) async {
  //   try {
  //     await _db.collection('flashcards').add({
  //       'word': word,
  //       'description': description,
  //       'pronounce': pronounce,
  //       'timestamp': FieldValue.serverTimestamp(),
  //     });
  //     print("Flashcard đã được lưu vào Firestore");
  //   } catch (e) {
  //     print("Lỗi khi lưu flashcard: $e");
  //   }
  // }

  // /// Lấy flashcards từ Firestore và sắp xếp theo `timestamp` (mới nhất trước)
  // Future<List<Map<String, dynamic>>> getFlashcards() async {
  //   try {
  //     QuerySnapshot snapshot = await _db
  //         .collection('flashcards')
  //         .orderBy('timestamp', descending: true) // Sắp xếp theo thời gian
  //         .get();

  //     return snapshot.docs.map((doc) {
  //       final data = doc.data() as Map<String, dynamic>;
  //       return {
  //         'id': doc.id, // ID của tài liệu
  //         'word': data['word'] ?? '',
  //         'description': data['description'] ?? '',
  //         'pronounce': data['pronounce'] ?? '',
  //         'timestamp': data['timestamp'] is Timestamp
  //             ? (data['timestamp'] as Timestamp).toDate()
  //             : null, // Chuyển đổi timestamp
  //       };
  //     }).toList();
  //   } catch (e) {
  //     print("Lỗi khi lấy flashcards: $e");
  //     return [];
  //   }
  // }

    // Thêm flashcard vào Firestore
  Future<void> addFlashcard(String word, String description, String pronounce) async {
    try {
      // Lấy userId từ Firebase Authentication
      String? userId = _auth.currentUser?.uid;
      
      if (userId == null) {
        print("Không có người dùng đăng nhập!");
        return;
      }

      await _db.collection('flashcards').add({
        'word': word,
        'description': description,
        'pronounce': pronounce,
        'userId': userId, // Lưu userId vào flashcard
        'timestamp': FieldValue.serverTimestamp(),
      });
      print("Flashcard đã được lưu vào Firestore");
    } catch (e) {
      print("Lỗi khi lưu flashcard: $e");
    }
  }

  // Lấy flashcards của người dùng từ Firestore
  Future<List<Map<String, dynamic>>> getFlashcards() async {
    // Lấy userId từ Firebase Authentication
    String? userId = _auth.currentUser?.uid;

    if (userId == null) {
      print("Không có người dùng đăng nhập!");
      return [];
    }

    // Lấy flashcards chỉ dành cho người dùng hiện tại
    final snapshot = await _db
        .collection('flashcards')
        .where('userId', isEqualTo: userId) // Lọc theo userId
        //.orderBy('timestamp', descending: true) // Sắp xếp theo timestamp mới nhất
        .get();

    List<Map<String, dynamic>> flashcards = snapshot.docs.map((doc)  {
      return {
        'id': doc.id,
        'word': doc['word'],
        'description': doc['description'],
        'pronounce': doc['pronounce'],
        'timestamp': doc['timestamp'],
      };
    }).toList();
        // Sắp xếp flashcards theo timestamp từ mới nhất đến cũ nhất
    flashcards.sort((a, b) {
      Timestamp timestampA = a['timestamp'];
      Timestamp timestampB = b['timestamp'];
      return timestampB.compareTo(timestampA); // Sắp xếp giảm dần theo timestamp
    });

    return flashcards;
  }

  /// Xóa flashcard khỏi Firestore theo `id`
  Future<void> deleteFlashcard(String id) async {
    try {
      await _db.collection('flashcards').doc(id).delete();
      print("Flashcard đã được xóa: $id");
    } catch (e) {
      print("Lỗi khi xóa flashcard: $e");
    }
  }
}
