// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../services/flashcard_service.dart';
import '../../../themes/snackbar.dart';

class FlashcardController extends GetxController {
  final FlashcardService _flashcardService = FlashcardService();
  var flashcards = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var currentIndex = 0.obs;

  void loadFlashcards() async {
    isLoading.value = true;
    flashcards.value = await _flashcardService.getFlashcards();
    isLoading.value = false;
  }

  // Thêm flashcard
  void addFlashcard(String word, String description, String pronounce) {
    _flashcardService.addFlashcard(word, description, pronounce);
  }

  Future<void> addFlashcardbtn(
      String word, String description, String pronounce) async {
    if (await _flashcardService.checkExistsWord(word)) {
      SnackBarCustom.GetSnackBarWarning(
          title: 'Thông báo!', content: 'Từ đã tồn tại !!!');
      return;
    }
    _flashcardService.addFlashcard(word, description, pronounce);
  }

  // Xóa flashcard
  void deleteFlashcard(String id) {
    _flashcardService.deleteFlashcard(id);
    loadFlashcards(); // Tải lại danh sách flashcards sau khi xóa
  }

  void addword() {
    Get.defaultDialog(
      title: 'Thêm từ mới',
      content: Column(
        children: [
          TextField(
            controller: TextEditingController(),
            decoration: const InputDecoration(hintText: 'Từ'),
            onChanged: (value) => _newWord.value = value,
          ),
          TextField(
            controller: TextEditingController(),
            decoration: const InputDecoration(hintText: 'Từ loại'),
            onChanged: (value) => _newTypeOfWord.value = value,
          ),
          TextField(
            controller: TextEditingController(),
            decoration: const InputDecoration(hintText: 'Định nghĩa'),
            onChanged: (value) => _newDescription.value = value,
          ),
          TextField(
            controller: TextEditingController(),
            decoration: const InputDecoration(hintText: 'Phát âm'),
            onChanged: (value) => _newPronunciation.value = value,
          ),
        ],
      ),
      textConfirm: 'Xác nhận',
      textCancel: 'Hủy',
      confirmTextColor: Colors.white,
      onConfirm: () {
        if (_newWord.value.isNotEmpty) {
          addFlashcardbtn(
            _newWord.value,
            _newTypeOfWord + ': ' + _newDescription.value,
            _newPronunciation.value,
          );
          // Chờ 2 giây trước khi tải lại danh sách flashcards
          Future.delayed(Duration(seconds: 2), () {
            loadFlashcards(); // Tải lại danh sách flashcards
            Get.back(); // Đóng hộp thoại
          });
        }
      },
    );
  }

  final _newWord = ''.obs;
  final _newDescription = ''.obs;
  final _newPronunciation = ''.obs;
  final _newTypeOfWord = ''.obs;
}
