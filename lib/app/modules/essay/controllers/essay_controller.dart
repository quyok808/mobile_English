import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../../models/LanguageToolError.dart';
import '../../../../models/essay_model.dart';
import '../../../../services/language_tool_service.dart';

// class EssayController extends GetxController {
//   final LanguageToolService _service = LanguageToolService();
//   final essayText = ''.obs;
//   final selectedTopic = 'General'.obs; 
//   final feedback = ''.obs;
//   final isLoading = false.obs;

//   // Stream<List<Essay>> get essaysStream =>
//   //     _service.getEssaysStream().map((snapshot) =>
//   //         snapshot.docs.map((doc) => Essay.fromMap(doc.data() as Map<String, dynamic>)).toList());
//   Stream<List<Essay>> get essaysStream =>
//       _service.getEssaysStream();

//   // Future<void> analyzeAndSaveEssay() async {
//   //   if (essayText.value.isEmpty) return;

//   //   isLoading.value = true;
//   //   try {
//   //     final analysis = await _service.analyzeEssay(essayText.value);
//   //     await _service.saveEssayToFirestore(essayText.value, analysis,selectedTopic.value);
//   //     feedback.value = analysis;
//   //   } catch (e) {
//   //     feedback.value = 'Error: Unable to analyze the essay.';
//   //   } finally {
//   //     isLoading.value = false;
//   //   }
//   // }
//   Future<void> analyzeAndSaveEssay() async {
//     if (essayText.value.isEmpty) return;

//     isLoading.value = true;
//     try {
//       final analysis = await _service.analyzeEssay(essayText.value);
//       final essay = Essay(
        
//         content: essayText.value,
//         feedback: analysis,
//         topic: selectedTopic.value,
//         createdAt: DateTime.now(),
//       );
//       await _service.saveEssayToFirestore(essay);
//       feedback.value = analysis;
//     } catch (e) {
//       feedback.value = 'Error: Unable to analyze the essay.';
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
class EssayController extends GetxController {
  final LanguageToolService _service = LanguageToolService();
  final essayText = ''.obs;
  final selectedTopic = 'General'.obs;
  final feedback = ''.obs;
  final isLoading = false.obs;

  final _auth = FirebaseAuth.instance;  // Khởi tạo FirebaseAuth

  Stream<List<Essay>> get essaysStream => _service.getEssaysStream();

  Future<void> analyzeAndSaveEssay() async {
    if (essayText.isEmpty) return;

    isLoading.value = true;
    try {
      final analysis = await _service.analyzeEssay(essayText.value);

      // Lấy userId từ Firebase Authentication
      String? userId = _auth.currentUser?.uid;

      if (userId == null) {
        feedback.value = 'Error: User is not logged in!';
        isLoading.value = false;
        return;
      }

      // Tạo đối tượng Essay với userId và các thông tin cần thiết
      final essay = Essay(
        userId: userId,
        content: essayText.value,
        feedback: analysis,
        topic: selectedTopic.value,
        createdAt: DateTime.now(),
      );

      // Lưu bài luận vào Firestore
      await _service.saveEssayToFirestore(essay);
      feedback.value = analysis;
    } catch (e) {
      feedback.value = 'Error: Unable to analyze the essay.';
    } finally {
      isLoading.value = false;
    }
  }
  // Phân tích lỗi khi người dùng nhập văn bản
  Future<void> analyzeEssayOnChange(String text) async {
    feedback.value = '';  // Reset feedback khi người dùng thay đổi văn bản
    if (text.isEmpty) return;

    try {
      final analysis = await _service.analyzeEssay(text);
      feedback.value = analysis;  // Cập nhật feedback với các lỗi
    } catch (e) {
      feedback.value = 'Error: Unable to analyze the essay.';
    }
  }
}
