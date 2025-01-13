import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:flutter/scheduler.dart';
import 'package:onlya_english/services/flashcard_service.dart';

class FishGameController extends GetxController {
  final FlashcardService _flashcardService = FlashcardService();
  RxList<Map<String, dynamic>> flashcards = <Map<String, dynamic>>[].obs;
  RxInt currentWordIndex = 0.obs;
  RxDouble waterLevel = 1.0.obs; // Mức nước (1.0 = đầy, 0 = cạn)
  RxBool isGameOver = false.obs;
  

  @override
  void onInit() {
    super.onInit();
    loadFlashcards();
  }

  Future<void> loadFlashcards() async {
    try {
      // Gọi hàm `getFlashcards` từ FlashcardService
      final List<Map<String, dynamic>> loadedFlashcards =
          await _flashcardService.getFlashcards();
      
      if (loadedFlashcards.isNotEmpty) {
        flashcards.value = loadedFlashcards;
        flashcards.shuffle(); // Xáo trộn danh sách từ
      } else {
        print("Không có flashcard nào để chơi game.");
      }
    } catch (e) {
      print("Lỗi khi tải flashcards: $e");
    }
  }

  void checkAnswer(bool isCorrect) {
    if (isCorrect) {
      waterLevel.value = (waterLevel.value + 0.2).clamp(0.0, 1.0);
    } else {
      waterLevel.value -= 0.2;
    }

    if (waterLevel.value <= 0) {
      isGameOver.value = true;
    } else {
      currentWordIndex.value =
          (currentWordIndex.value + 1) % flashcards.length;
    }
  }

  String get currentWord => flashcards.isNotEmpty
      ? flashcards[currentWordIndex.value]['word']
      : '';

  String get correctMeaning => flashcards.isNotEmpty
      ? flashcards[currentWordIndex.value]['description']
      : '';

  String get randomFakeMeaning {
    if (flashcards.isEmpty) return '';
    final random = Random();
    final fakeWord =
        flashcards[random.nextInt(flashcards.length)]['description'];
    return fakeWord != correctMeaning ? fakeWord : randomFakeMeaning;
  }
}


