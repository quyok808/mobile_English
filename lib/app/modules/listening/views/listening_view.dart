import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:onlya_english/app/modules/listening/views/DetailPage.dart';
import 'package:onlya_english/app/themes/theme.dart';
import '../controllers/listening_controller.dart';

class ListeningPage extends StatelessWidget {
  final ListeningController controller = Get.put(ListeningController());
  final AudioPlayer audioPlayer =
      AudioPlayer(); // Tạo AudioPlayer từ just_audio

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text(
          'Listening Practice',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          onPressed: Get.back,
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.color_appbar,
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.lessons.isEmpty) {
          return const Center(child: Text('No lessons available.'));
        }
        return ListView.builder(
          itemCount: controller.lessons.length,
          itemBuilder: (context, index) {
            final lesson = controller.lessons[index];
            return Card(
              color: Colors.white,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 4,
              child: InkWell(
                onTap: () {
                  // Chuyển sang trang chi tiết bài học
                  Get.to(() => LessonDetailPage(lesson: lesson));
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    lesson['title'],
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
          },
        );

        // return ListView.builder(
        //   itemCount: controller.lessons.length,
        //   itemBuilder: (context, index) {
        //     final lesson = controller.lessons[index];
        //     return ExpansionTile(
        //       title: Card(
        //         margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        //         elevation: 4,
        //         child: Padding(
        //           padding: const EdgeInsets.all(8.0),
        //           child: Text(lesson['title']),
        //         ),
        //       ),
        //       children: (lesson['sections'] as Map<String, dynamic>).entries.map((entry) {
        //         final section = entry.value;
        //         return Card(
        //           margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        //           elevation: 4,
        //           child: ListTile(
        //             title: Text(section['transcript']),
        //             subtitle: Text(section['Translation']),
        //             trailing: IconButton(
        //               icon: const Icon(Icons.play_arrow),
        //               onPressed: () {
        //                 playAudio(section['audio']);
        //               },
        //             ),
        //             onTap: () {
        //               showQuestionsDialog(context, section['questions']);
        //             },
        //           ),
        //         );
        //       }).toList(),
        //     );
        //   },
        // );
      }),
    );
  }

  // Future<void> playAudio(String audioFile) async {
  //   final assetPath = "assets/audio/$audioFile";
  //
  //   try {
  //     await audioPlayer.setAsset(assetPath); // Đặt asset audio
  //     audioPlayer.play(); // Phát audio
  //     print("Playing: $assetPath");
  //   } catch (e) {
  //     print("Error playing audio: $e");
  //   }
  // }

  // void showQuestionsDialog(BuildContext context, List<dynamic> questions) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: const Text('Questions'),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: questions.map((q) {
  //             return ListTile(
  //               title: Text(q['question']),
  //               subtitle: Text('Answer: ${q['answer']}'),
  //             );
  //           }).toList(),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: const Text('Close'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
