// ignore_for_file: use_key_in_widget_constructors, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/flashcard_controller.dart';
import 'widgets/flashcard_widget.dart';

class FlashcardView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FlashcardController controller = Get.put(FlashcardController());

    // Tải danh sách flashcards khi view được khởi tạo
    controller.loadFlashcards();

    return Scaffold(
      backgroundColor: Color(0xFF7B66F0),
      appBar: AppBar(
        title: Center(
          child: Text(
            'Flashcards',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        backgroundColor: Color(0xFF5FBDFF),
      ),
      body: Stack(
        children: [
          Obx(() {
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
                return Draggable<Map<String, dynamic>>(
                  data: currentFlashcard,
                  feedback: FlashcardWidget(
                    word: currentFlashcard['word'] ?? 'Từ không xác định',
                    description:
                        currentFlashcard['description'] ?? 'Không có mô tả',
                    pronounce: currentFlashcard['pronounce'] ?? 'Không có',
                  ),
                  childWhenDragging: Opacity(
                    opacity: 0,
                    child: FlashcardWidget(
                      word: currentFlashcard['word'] ?? 'Từ không xác định',
                      description:
                          currentFlashcard['description'] ?? 'Không có mô tả',
                      pronounce: currentFlashcard['pronounce'] ?? 'Không có',
                    ),
                  ),
                  child: FlashcardWidget(
                    word: currentFlashcard['word'] ?? 'Từ không xác định',
                    description:
                        currentFlashcard['description'] ?? 'Không có mô tả',
                    pronounce: currentFlashcard['pronounce'] ?? 'Không có',
                  ),
                );
              },
            );
          }),
          Positioned(
            bottom: 15,
            left: 20,
            child: DragTarget<Map<String, dynamic>>(
              onWillAccept: (data) => true, // Luôn chấp nhận flashcard
              onAccept: (data) {
                controller.deleteFlashcard(data['id']);
              },
              builder: (context, candidateData, rejectedData) {
                return Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 30,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: controller.addword,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
