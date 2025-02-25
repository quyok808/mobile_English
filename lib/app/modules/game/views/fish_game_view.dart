import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onlya_english/app/themes/theme.dart';
import '../controllers/fish_game_controller.dart';

class FishGameView extends StatefulWidget {
  @override
  _FishGameViewState createState() => _FishGameViewState();
}

class _FishGameViewState extends State<FishGameView>
    with TickerProviderStateMixin {
  final FishGameController controller = Get.find<FishGameController>();
  late AnimationController _animationController;
  late Animation<double> _fishMovement;

  @override
  void initState() {
    super.initState();

    // Khởi tạo AnimationController
    _animationController = AnimationController(
      duration: const Duration(seconds: 3), // Thời gian di chuyển 3 giây
      vsync: this,
    )..repeat(reverse: true); // Lặp lại chuyển động (qua lại)

    // Tạo Tween cho vị trí con cá (từ trái sang phải)
    _fishMovement = Tween<double>(begin: 100, end: 300).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut, // Hiệu ứng di chuyển mượt mà
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Fish Vocabulary Game',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: Get.back,
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.color_appbar,
      ),
      body: Obx(() {
        if (controller.isGameOver.value) {
          return Stack(
            children: [
              // Hình nền
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/images/deadfish.jpg'), // Đường dẫn hình nền
                      fit: BoxFit.cover, // Phủ đầy màn hình
                    ),
                  ),
                ),
              ),
              // Nội dung "Game Over"
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Game Over!',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 244, 244, 244),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Nếu cần hiển thị thêm thông tin, bỏ comment các dòng dưới
                    // Text(
                    //    'Final Water Level: ${controller.waterLevel.value * 100}%',
                    //   style: TextStyle(fontSize: 18, color: Colors.grey),
                    // ),
                    // const SizedBox(height: 40),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal),
                      onPressed: () {
                        // Đặt lại trò chơi
                        controller.isGameOver.value = false;
                        controller.waterLevel.value = 1.0;
                        controller.currentWordIndex.value = 0;
                        _animationController.reset(); // Đặt lại animation
                      },
                      child: const Text(
                        'Play Again',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }

        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/underwater.jpg'), // Hình nền
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              // Mực nước với hiệu ứng chuyển động
              Obx(() {
                return Align(
                  alignment: Alignment.bottomCenter,
                  child: AnimatedContainer(
                    duration: Duration(
                        milliseconds: 500), // Thời gian chuyển động mực nước
                    curve: Curves.easeInOut,
                    height: (MediaQuery.of(context).size.height - 100) *
                        controller.waterLevel.value,
                    width: double.infinity,
                    color: Colors.blue.withOpacity(0.5), // Màu nước trong suốt
                  ),
                );
              }),

              // Con cá di chuyển theo mực nước và bơi qua lại
              Obx(() {
                return Positioned(
                  top: MediaQuery.of(context).size.height *
                      (1.0 -
                          controller.waterLevel
                              .value), // Đảm bảo con cá ở trong mực nước
                  left: _fishMovement.value, // Vị trí ngang của con cá
                  child: AnimatedOpacity(
                    opacity: controller.waterLevel.value > 0.1
                        ? 1.0
                        : 0.0, // Con cá mờ dần khi mực nước thấp
                    duration: Duration(milliseconds: 450),
                    child: Image.asset(
                      'assets/images/fish.png', // Đường dẫn đến hình ảnh con cá
                      width: 150,
                      height: 150,
                    ),
                  ),
                );
              }),

              // Nội dung trò chơi
              Column(
                children: [
                  Obx(() => LinearProgressIndicator(
                        value: controller.waterLevel.value,
                        backgroundColor: Colors.blue.shade100,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      )),
                  const SizedBox(height: 450),
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
                            color: Color.fromARGB(255, 37, 56, 255),
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

// class FishGameView extends StatelessWidget {
//   final FishGameController controller = Get.find<FishGameController>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Fish Vocabulary Game'),
//         backgroundColor: Colors.teal,
//       ),
//       body: Obx(() {
//         if (controller.isGameOver.value) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text(
//                   'Game Over!',
//                   style: TextStyle(
//                     fontSize: 32,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.red,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Text(
//                   'Final Water Level: ${controller.waterLevel.value * 100}%',
//                   style: TextStyle(fontSize: 18, color: Colors.grey),
//                 ),
//                 const SizedBox(height: 40),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
//                   onPressed: () {
//                     // Reset the game
//                     controller.isGameOver.value = false;
//                     controller.waterLevel.value = 1.0;
//                     controller.currentWordIndex.value = 0;
//                   },
//                   child: const Text(
//                     'Play Again',
//                     style: TextStyle(fontSize: 18),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }

//         return Container(
//   decoration: BoxDecoration(
//     image: DecorationImage(
//       image: AssetImage('assets/images/underwater.jpg'), // Nền
//       fit: BoxFit.cover,
//     ),
//   ),
//   child: Stack(
//     children: [
//       // Lớp mực nước với hiệu ứng chuyển động
//       Obx(() {
//         return Align(
//           alignment: Alignment.bottomCenter,
//           child: AnimatedContainer(
//             duration: Duration(milliseconds: 500), // Thời gian thay đổi mực nước
//             curve: Curves.easeInOut, // Mượt mà khi thay đổi
//             height: MediaQuery.of(context).size.height * controller.waterLevel.value, // Chiều cao theo tỷ lệ
//             width: double.infinity,
//             color: Colors.blue.withOpacity(0.5), // Màu nước bán trong suốt
//           ),
//         );
//       }),
//       // Nội dung chính của trò chơi
//       Column(
//         children: [
//           const SizedBox(height: 20),
//           Obx(() => LinearProgressIndicator(
//                 value: controller.waterLevel.value,
//                 backgroundColor: Colors.blue.shade100,
//                 valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
//               )),
//           const SizedBox(height: 450),
//           Card(
//             elevation: 5,
//             margin: const EdgeInsets.symmetric(horizontal: 16),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Obx(() {
//                 return Text(
//                   controller.currentWord,
//                   style: const TextStyle(
//                     fontSize: 28,
//                     fontWeight: FontWeight.bold,
//                     color: Color.fromARGB(255, 37, 56, 255),
//                   ),
//                   textAlign: TextAlign.center,
//                 );
//               }),
//             ),
//           ),
//           const SizedBox(height: 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Expanded(
//                 child: Card(
//                   elevation: 5,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   child: InkWell(
//                     onTap: () => controller.checkAnswer(true),
//                     child: Container(
//                       height: 100,
//                       alignment: Alignment.center,
//                       child: Obx(() => Text(
//                             controller.correctMeaning,
//                             style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                             textAlign: TextAlign.center,
//                           )),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Card(
//                   elevation: 5,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   child: InkWell(
//                     onTap: () => controller.checkAnswer(false),
//                     child: Container(
//                       height: 100,
//                       alignment: Alignment.center,
//                       child: Obx(() => Text(
//                             controller.randomFakeMeaning,
//                             style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                             textAlign: TextAlign.center,
//                           )),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     ],
//   ),
// );

      
//       }),
//     );
//   }
// }
// class FishGameView extends StatefulWidget {
//   @override
//   _FishGameViewState createState() => _FishGameViewState();
// }

// class _FishGameViewState extends State<FishGameView> with TickerProviderStateMixin {
//   final FishGameController controller = Get.find<FishGameController>();
//   late AnimationController _waveController;

//   @override
//   void initState() {
//     super.initState();
//     _waveController = AnimationController(
//       vsync: this, // Use the current State as TickerProvider
//       duration: const Duration(seconds: 2),
//     )..repeat(reverse: true); // Repeat the animation with reverse
//   }

//   @override
//   void dispose() {
//     _waveController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Fish Vocabulary Game'),
//         backgroundColor: Colors.teal,
//       ),
//       body: Obx(() {
//         if (controller.isGameOver.value) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text(
//                   'Game Over!',
//                   style: TextStyle(
//                     fontSize: 32,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.red,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Text(
//                   'Final Water Level: ${controller.waterLevel.value * 100}%',
//                   style: TextStyle(fontSize: 18, color: Colors.grey),
//                 ),
//                 const SizedBox(height: 40),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
//                   onPressed: () {
//                     // Reset the game
//                     controller.isGameOver.value = false;
//                     controller.waterLevel.value = 1.0;
//                     controller.currentWordIndex.value = 0;
//                   },
//                   child: const Text(
//                     'Play Again',
//                     style: TextStyle(fontSize: 18),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }

//         return Container(
//           decoration: BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage('assets/images/underwater.jpg'), // Background image
//               fit: BoxFit.cover,
//             ),
//           ),
//           child: Stack(
//             children: [
              
//               // Water wave effect
//               AnimatedBuilder(
//                 animation: _waveController,
//                 builder: (context, child) {
//                   return ClipPath(
//                     clipper: WaveClipper(_waveController.value),
//                     child: Container(
//                       height: MediaQuery.of(context).size.height * (1.0 - controller.waterLevel.value) * 0.5, // Water height
//                       color: Colors.blue.withOpacity(0.5), // Semi-transparent water color
//                     ),
//                   );
//                 },
//               ),
//               // Game content
//               Column(
//                 children: [
//                   const SizedBox(height: 20),
//                   Obx(() => LinearProgressIndicator(
//                         value: controller.waterLevel.value,
//                         backgroundColor: Colors.blue.shade100,
//                         valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
//                       )),
//                   const SizedBox(height: 450),
//                   Card(
//                     elevation: 5,
//                     margin: const EdgeInsets.symmetric(horizontal: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16),
//                       child: Obx(() {
//                         return Text(
//                           controller.currentWord,
//                           style: const TextStyle(
//                             fontSize: 28,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black,
//                           ),
//                           textAlign: TextAlign.center,
//                         );
//                       }),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Expanded(
//                         child: Card(
//                           elevation: 5,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                           child: InkWell(
//                             onTap: () => controller.checkAnswer(true),
//                             child: Container(
//                               height: 100,
//                               alignment: Alignment.center,
//                               child: Obx(() => Text(
//                                     controller.correctMeaning,
//                                     style: const TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                     textAlign: TextAlign.center,
//                                   )),
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 16),
//                       Expanded(
//                         child: Card(
//                           elevation: 5,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                           child: InkWell(
//                             onTap: () => controller.checkAnswer(false),
//                             child: Container(
//                               height: 100,
//                               alignment: Alignment.center,
//                               child: Obx(() => Text(
//                                     controller.randomFakeMeaning,
//                                     style: const TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                     textAlign: TextAlign.center,
//                                   )),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }

// class WaveClipper extends CustomClipper<Path> {
//   final double animationValue;

//   WaveClipper(this.animationValue);

//   @override
//   Path getClip(Size size) {
//     final Path path = Path();
//     final double waveHeight = 20.0; // Wave height
//     final double waveLength = size.width / 2.0; // Wave length
//     final double waveOffset = animationValue * waveLength; // Wave offset

//     path.lineTo(0.0, size.height);

//     for (double x = 0.0; x <= size.width; x++) {
//       // double y = sin((x + waveOffset) * pi / waveLength) * waveHeight + size.height / 2;
//       double y = sin((x + waveOffset) * pi / waveLength) * waveHeight + size.height / 2;
//       path.lineTo(x, y);
//     }

//     path.lineTo(size.width, size.height);
//     path.lineTo(size.width, 0.0);
//     path.close();

//     return path;
//   }

//   @override
//   bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
//     return true; // Always reclip to update the effect
//   }
// }