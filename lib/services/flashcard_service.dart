// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FlashcardService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> checkExistsWord(String word) async {
    try {
      // Lấy userId từ Firebase Authentication
      String? userId = _auth.currentUser?.uid;

      if (userId == null) {
        print("Không có người dùng đăng nhập!");
        return false;
      }

      // Kiểm tra sự tồn tại của từ trong Firestore
      final snapshot = await _db
          .collection('flashcards')
          .where('userId', isEqualTo: userId) // Lọc theo userId
          .where('word', isEqualTo: word.trim()) // Lọc theo từ
          .get();

      // Nếu có ít nhất một document, từ đã tồn tại
      return snapshot.docs.isNotEmpty;
    } catch (e) {
      print("Lỗi khi kiểm tra từ tồn tại: $e");
      return false;
    }
  }

  // Thêm flashcard vào Firestore
  Future<void> addFlashcard(
      String word, String description, String pronounce) async {
    try {
      if (await checkExistsWord(word)) {
        return;
      }
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

    List<Map<String, dynamic>> flashcards = snapshot.docs.map((doc) {
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
      return timestampB
          .compareTo(timestampA); // Sắp xếp giảm dần theo timestamp
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

  // Tìm flashcard theo id
  Future<Map<String, dynamic>?> findById(String id) async {
    try {
      // Lấy document theo ID
      final doc = await _db.collection('flashcards').doc(id).get();

      if (!doc.exists) {
        print("Flashcard không tồn tại: $id");
        return null;
      }

      // Trả về thông tin flashcard dưới dạng Map
      return {
        'id': doc.id,
        'word': doc['word'],
        'description': doc['description'],
        'pronounce': doc['pronounce'],
        'timestamp': doc['timestamp'],
      };
    } catch (e) {
      print("Lỗi khi tìm flashcard theo ID: $e");
      return null;
    }
  }

  Future<void> updateFlashcard(
      String id, String word, String description, String pronounce) async {
    try {
      // Lấy userId từ Firebase Authentication
      String? userId = _auth.currentUser?.uid;

      if (userId == null) {
        print("Không có người dùng đăng nhập!");
        return;
      }

      // Kiểm tra flashcard có tồn tại và thuộc về userId hay không
      final doc = await _db.collection('flashcards').doc(id).get();

      if (!doc.exists || doc.data()?['userId'] != userId) {
        print(
            "Flashcard không tồn tại hoặc không thuộc về người dùng hiện tại: $id");
        return;
      }

      // Cập nhật thông tin flashcard
      await _db.collection('flashcards').doc(id).update({
        'word': word,
        'description': description,
        'pronounce': pronounce,
      });

      print("Flashcard đã được cập nhật thành công.");
    } catch (e) {
      print("Lỗi khi cập nhật flashcard: $e");
    }
  }
}
