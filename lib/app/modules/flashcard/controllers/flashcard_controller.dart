import 'package:get/get.dart';
import '../../../../services/flashcard_service.dart';

class FlashcardController extends GetxController {
  final FlashcardService _flashcardService = FlashcardService();
  var flashcards = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var currentIndex = 0.obs;

  // @override
  // void onInit() {
  //   super.onInit();
  //   fetchFlashcards();
  // }

  // /// Lấy danh sách flashcards từ Firestore
  // Future<void> fetchFlashcards() async {
  //   isLoading.value = true;
  //   try {
  //     final data = await _flashcardService.getFlashcards();
  //     flashcards.assignAll(data); // Cập nhật danh sách flashcards
  //   } catch (e) {
  //     print("Lỗi khi tải flashcards: $e");
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  // /// Xóa flashcard theo `id`
  // Future<void> deleteFlashcard(String id) async {
  //   await _flashcardService.deleteFlashcard(id);
  //   flashcards.removeWhere((card) => card['id'] == id); // Xóa khỏi danh sách hiển thị
  // }
  // Lấy flashcards của người dùng
  void loadFlashcards() async {
    isLoading.value = true;
    flashcards.value = await _flashcardService.getFlashcards();
    isLoading.value = false;
  }

  // Thêm flashcard
  void addFlashcard(String word, String description, String pronounce) {
    _flashcardService.addFlashcard(word, description, pronounce);
  }

  // Xóa flashcard
  void deleteFlashcard(String id) {
    _flashcardService.deleteFlashcard(id);
    loadFlashcards(); // Tải lại danh sách flashcards sau khi xóa
  }
}