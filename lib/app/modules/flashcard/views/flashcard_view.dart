// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
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
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Center(
          child: Text(
            'Flashcards',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        backgroundColor: Colors.blue,
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

        return PageView.builder(
          controller:
              PageController(initialPage: controller.currentIndex.value),
          onPageChanged: (index) {
            controller.currentIndex.value =
                index; // Cập nhật chỉ số flashcard hiện tại
          },
          itemCount: controller.flashcards.length,
          itemBuilder: (context, index) {
            final currentFlashcard = controller.flashcards[index];
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
              ],
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}
