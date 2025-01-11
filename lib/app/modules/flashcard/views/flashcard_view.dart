import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:onlya_english/app/themes/theme.dart';
import '../controllers/flashcard_controller.dart';
import 'widgets/flashcard_widget.dart';

class FlashcardView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FlashcardController controller = Get.put(FlashcardController());

    // Tải danh sách flashcards khi view được khởi tạo
    controller.loadFlashcards();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Center(
          child: Text(
            'Flashcards',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            textAlign: TextAlign.center,
          ),
        ),
        backgroundColor: AppTheme.blue,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.flashcards.isEmpty) {
          return const Center(
            child: Text(
              'Chưa có flashcard nào!',
              style: TextStyle(fontSize: 25, color: Colors.grey),
            ),
          );
        }
        final currentFlashcard =
            controller.flashcards[controller.currentIndex.value];
        return Column(
          children: [
            Expanded(
              child: FlashcardWidget(
                word: currentFlashcard['word'] ?? 'Từ không xác định',
                description:
                    currentFlashcard['description'] ?? 'Không có mô tả',
                pronounce: currentFlashcard['pronounce'] ?? 'Không có',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Nút Previous
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      if (controller.currentIndex.value > 0) {
                        controller.currentIndex.value--;
                      }
                    },
                  ),
                  // Nút Next
                  IconButton(
                    icon: Icon(Icons.arrow_forward),
                    onPressed: () {
                      if (controller.currentIndex.value <
                          controller.flashcards.length - 1) {
                        controller.currentIndex.value++;
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}
