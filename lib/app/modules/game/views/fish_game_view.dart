import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/fish_game_controller.dart';

// class FishGameView extends StatelessWidget {
//   final FishGameController controller = Get.find<FishGameController>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Fish Vocabulary Game')),
//       body: Obx(() {
//         if (controller.isGameOver.value) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text(
//                   'Game Over!',
//                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     controller.isGameOver.value = false;
//                     controller.waterLevel.value = 1.0;
//                     controller.currentWordIndex.value = 0;
//                   },
//                   child: const Text('Play Again'),
//                 ),
//               ],
//             ),
//           );
//         }

//         return Column(
//           children: [
//             LinearProgressIndicator(value: controller.waterLevel.value),
//             const SizedBox(height: 20),
//             Text(
//               controller.currentWord,
//               style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton(
//                   onPressed: () =>
//                       controller.checkAnswer(true), // Đáp án đúng
//                   child: Text(controller.correctMeaning),
//                 ),
//                 ElevatedButton(
//                   onPressed: () =>
//                       controller.checkAnswer(false), // Đáp án sai
//                   child: Text(controller.randomFakeMeaning),
//                 ),
//               ],
//             ),
//           ],
//         );
//       }),
//     );
//   }
// }


class FishGameView extends StatelessWidget {
  final FishGameController controller = Get.find<FishGameController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fish Vocabulary Game'),
        backgroundColor: Colors.teal,
      ),
      body: Obx(() {
        if (controller.isGameOver.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Game Over!',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Final Water Level: ${controller.waterLevel.value * 100}%',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  onPressed: () {
                    // Reset the game
                    controller.isGameOver.value = false;
                    controller.waterLevel.value = 1.0;
                    controller.currentWordIndex.value = 0;
                  },
                  child: const Text(
                    'Play Again',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          );
        }

        return Container(
  decoration: BoxDecoration(
    image: DecorationImage(
      image: AssetImage('assets/images/underwater.jpg'), // Nền
      fit: BoxFit.cover,
    ),
  ),
  child: Stack(
    children: [
      // Lớp mực nước với hiệu ứng chuyển động
      Obx(() {
        return Align(
          alignment: Alignment.bottomCenter,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 500), // Thời gian thay đổi mực nước
            curve: Curves.easeInOut, // Mượt mà khi thay đổi
            height: MediaQuery.of(context).size.height * controller.waterLevel.value, // Chiều cao theo tỷ lệ
            width: double.infinity,
            color: Colors.blue.withOpacity(0.5), // Màu nước bán trong suốt
          ),
        );
      }),
      // Nội dung chính của trò chơi
      Column(
        children: [
          const SizedBox(height: 20),
          Obx(() => LinearProgressIndicator(
                value: controller.waterLevel.value,
                backgroundColor: Colors.blue.shade100,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              )),
          const SizedBox(height: 40),
          Card(
            elevation: 5,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Obx(() {
                return Text(
                  controller.currentWord,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                );
              }),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: InkWell(
                    onTap: () => controller.checkAnswer(true),
                    child: Container(
                      height: 100,
                      alignment: Alignment.center,
                      child: Obx(() => Text(
                            controller.correctMeaning,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          )),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: InkWell(
                    onTap: () => controller.checkAnswer(false),
                    child: Container(
                      height: 100,
                      alignment: Alignment.center,
                      child: Obx(() => Text(
                            controller.randomFakeMeaning,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          )),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  ),
);

      
      }),
    );
  }
}
