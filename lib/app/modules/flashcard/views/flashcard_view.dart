import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:onlya_english/app/themes/theme.dart';
import '../controllers/flashcard_controller.dart';

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

        // return ListView.builder(
        //   itemCount: controller.flashcards.length,
        //   itemBuilder: (context, index) {
        //     final flashcard = controller.flashcards[index];
        //
        //     return FlashcardWidget(
        //       word: flashcard['word'] ?? 'Từ không xác định',
        //       description: flashcard['description'] ?? 'Không có mô tả',
        //       pronounce: flashcard['pronounce'] ?? 'Không có',
        //       onDelete: () {
        //         _showDeleteDialog(context, controller, flashcard['id']);
        //       },
        //     );
        //   },
        // );
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
    );
  }

  // void _showDeleteDialog(
  //     BuildContext context, FlashcardController controller, String id) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text('Xóa Flashcard'),
  //       content: const Text('Bạn có chắc chắn muốn xóa flashcard này không?'),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.of(context).pop(),
  //           child: const Text('Hủy'),
  //         ),
  //         TextButton(
  //           onPressed: () {
  //             controller.deleteFlashcard(id);
  //             Navigator.of(context).pop();
  //           },
  //           child: const Text('Xóa', style: TextStyle(color: Colors.red)),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}

class FlashcardWidget extends StatelessWidget {
  final String word;
  final String description;
  final String pronounce;
  // final VoidCallback onDelete;

  FlashcardWidget({
    Key? key,
    required this.word,
    required this.description,
    required this.pronounce,
    // required this.onDelete,
  }) : super(key: key);

  final FlutterTts flutterTts = FlutterTts(); // Khởi tạo đối tượng FlutterTts
  // Hàm để phát âm từ
  void _speak() async {
    await flutterTts.setLanguage("en-US"); // Ngôn ngữ tiếng Anh
    await flutterTts.setPitch(1.0); // Độ cao giọng
    await flutterTts.speak(word); // Phát âm từ
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 220),
      child: SizedBox(
        //height: 200, // Đặt chiều cao cho card
        child: FlipCard(
          front: _buildFrontCard(),
          back: _buildBackCard(),
        ),
      ),
    );
  }

  Widget _buildFrontCard() {
    return SizedBox(
      width: 250, // Đảm bảo chiều rộng bằng với parent
      //height: 200, // Đảm bảo chiều cao bằng với parent
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(8.0), // Đặt padding cho toàn bộ thẻ
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Căn giữa nội dung trong thẻ
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _speak, // Khi nhấn loa, phát âm từ
                child: Container(
                  padding:
                      const EdgeInsets.all(10.0), // Padding bên trong vòng tròn
                  decoration: BoxDecoration(
                    color: Colors.blue[300], // Màu nền vòng tròn
                    shape: BoxShape.circle, // Đảm bảo vòng tròn
                  ),
                  child: Icon(Icons.volume_up, // Biểu tượng loa
                      size: 30, // Kích thước biểu tượng
                      color: Colors.white // Màu biểu tượng
                      ),
                ),
              ),
              // Thêm biểu tượng loa phía trên từ

              const SizedBox(height: 8), // Khoảng cách giữa loa và từ
              Text(
                word,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  color: Color.fromARGB(255, 0, 125, 227),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8), // Khoảng cách giữa từ và phát âm
              Text(
                '/$pronounce/',
                style: const TextStyle(
                  color: Color.fromARGB(255, 111, 111, 111),
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackCard() {
    return SizedBox(
      width: 300, // Đảm bảo chiều rộng bằng với parent
      //height: 200, // Đảm bảo chiều cao bằng với parent
      child: Card(
        elevation: 4,
        color: const Color.fromARGB(255, 62, 172, 251),
        child: Center(
          // Dùng Center để căn giữa nội dung
          child: Padding(
            padding: const EdgeInsets.all(8.0), // Đặt padding trong thẻ
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Căn giữa nội dung trong thẻ
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(221, 255, 254, 254),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
