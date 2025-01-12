import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:onlya_english/app/themes/snackbar.dart';
import 'package:onlya_english/models/Flashcard.dart';

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

  // Cập nhật flashcard theo word và userId
  Future<void> updateFlashcard(String currentword, String word,
      String description, String pronounce) async {
    try {
      // Lấy userId từ Firebase Authentication
      String? userId = _auth.currentUser?.uid;

      if (userId == null) {
        print("Không có người dùng đăng nhập!");
        return;
      }

      // Tìm flashcard có từ và userId tương ứng
      final snapshot = await _db
          .collection('flashcards')
          .where('userId', isEqualTo: userId) // Lọc theo userId
          .where('word', isEqualTo: currentword) // Lọc theo từ
          .limit(1) // Chỉ lấy 1 kết quả
          .get();

      if (snapshot.docs.isEmpty) {
        print("Không tìm thấy flashcard để cập nhật.");
        return;
      }

      // Lấy id của flashcard
      String docId = snapshot.docs.first.id;

      // Cập nhật thông tin flashcard
      await _db.collection('flashcards').doc(docId).update({
        'word': word,
        'description': description,
        'pronounce': pronounce,
        'timestamp': FieldValue.serverTimestamp(), // Cập nhật timestamp
      });

      print("Flashcard đã được cập nhật.");
    } catch (e) {
      print("Lỗi khi cập nhật flashcard: $e");
    }
  }
}
