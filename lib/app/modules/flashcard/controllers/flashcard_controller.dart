// ignore_for_file: prefer_interpolation_to_compose_strings, no_leading_underscores_for_local_identifiers

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
    SnackBarCustom.GetSnackBarSuccess(
        title: 'Thành công', content: 'Đã xoá từ vựng khỏi bộ từ của bạn!');
  }

  void updateFlashcard(
      String id, String word, String description, String pronounce) {
    _flashcardService.updateFlashcard(id, word, description, pronounce);
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
            decoration: const InputDecoration(hintText: 'Phiên âm'),
            onChanged: (value) => _newPronunciation.value = value,
          ),
        ],
      ),
      textConfirm: 'Xác nhận',
      textCancel: 'Hủy',
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.dialog(
          Center(child: CircularProgressIndicator()),
          barrierDismissible: false,
        );
        if (_newWord.value.isNotEmpty) {
          addFlashcardbtn(
            _newWord.value,
            _newTypeOfWord + ': ' + _newDescription.value.trim(),
            _newPronunciation.value,
          );
          // Chờ 2 giây trước khi tải lại danh sách flashcards
          Future.delayed(Duration(seconds: 2), () {
            Get.back();
            Get.back();
            loadFlashcards(); // Tải lại danh sách flashcards
            // Đóng hộp thoại
          });
        }
      },
    );
  }

  final _newWord = ''.obs;
  final _newDescription = ''.obs;
  final _newPronunciation = ''.obs;
  final _newTypeOfWord = ''.obs;

  void updateWord(String id, String currentWord, String currentTypeOfWord,
      String currentDescription, String currentPronunciation) {
    // Khởi tạo các controller với giá trị hiện tại của từ cần sửa
    TextEditingController _wordController =
        TextEditingController(text: currentWord);
    TextEditingController _typeOfWordController =
        TextEditingController(text: currentTypeOfWord);
    TextEditingController _descriptionController =
        TextEditingController(text: currentDescription);
    TextEditingController _pronunciationController =
        TextEditingController(text: currentPronunciation);

    Get.defaultDialog(
      title: 'Cập nhật từ',
      content: Column(
        children: [
          Row(
            children: [
              Text('Từ: '),
              Expanded(
                child: TextField(
                  controller: _wordController,
                  decoration: const InputDecoration(
                    hintText: 'Từ mới',
                    border: InputBorder.none,
                  ),
                  onChanged: (value) => _wordController.text = value,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text('Từ loại: '),
              Expanded(
                child: TextField(
                  controller: _typeOfWordController,
                  decoration: const InputDecoration(
                    hintText: 'Từ loại',
                    border: InputBorder.none,
                  ),
                  onChanged: (value) => _typeOfWordController.text = value,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text('Định nghĩa: '),
              Expanded(
                child: TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    hintText: 'Định nghĩa',
                    border: InputBorder.none,
                  ),
                  onChanged: (value) => _descriptionController.text = value,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Center(child: Text('Phiên âm: ')),
              Expanded(
                child: TextField(
                  controller: _pronunciationController,
                  decoration: const InputDecoration(
                    hintText: 'Phát âm',
                    border: InputBorder.none,
                  ),
                  onChanged: (value) => _pronunciationController.text = value,
                ),
              ),
            ],
          ),
        ],
      ),
      textConfirm: 'Xác nhận',
      textCancel: 'Hủy',
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.dialog(
          Center(child: CircularProgressIndicator()),
          barrierDismissible: false,
        );
        if (_wordController.text.isNotEmpty) {
          print(
              'id: ${id}, word: ${_wordController.text}, description: ${_typeOfWordController.text + ': ' + _descriptionController.text.trim()}, pronoun: ${_pronunciationController.text}');
          updateFlashcard(
            id,
            _wordController.text,
            _typeOfWordController.text +
                ': ' +
                _descriptionController.text.trim(),
            _pronunciationController.text,
          );
          // Chờ 2 giây trước khi tải lại danh sách flashcards
          Future.delayed(Duration(seconds: 2), () {
            Get.back();
            Get.back();
            loadFlashcards();
          });
        }
      },
    );
  }
}
