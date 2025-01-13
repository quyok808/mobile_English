// ignore_for_file: unused_import, avoid_print, use_super_parameters, unused_field

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onlya_english/app/modules/course/controllers/course_controller.dart';
import 'package:onlya_english/app/themes/snackbar.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:dart_levenshtein/dart_levenshtein.dart';

class SpeakingPracticeView extends StatefulWidget {
  const SpeakingPracticeView({Key? key}) : super(key: key);

  @override
  State<SpeakingPracticeView> createState() => _SpeakingPracticeViewState();
}

class _SpeakingPracticeViewState extends State<SpeakingPracticeView> {
  final CourseController controller = Get.find<CourseController>();
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = '';
  double _confidence = 1.0;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _requestPermission();
  }

  void _requestPermission() async {
    var status = await Permission.microphone.status;
    if (status.isDenied) {
      // Nếu quyền bị từ chối
      var result = await Permission.microphone.request();
      if (result.isGranted) {
        // Người dùng đã cấp quyền
        _isListening = true;
        print('Microphone permission granted');
      } else if (result.isPermanentlyDenied) {
        _isListening = false;
        // Quyền bị từ chối vĩnh viễn
        SnackBarCustom.GetSnackBarError(
            title: 'Lỗi',
            content: 'Bạn cần cấp phép sử dụng micro để sử dụng chức năng này');
      } else {
        // Người dùng từ chối
        _isListening = false;
        Get.snackbar(
          'Lỗi',
          'Bạn cần cấp quyền microphone để tiếp tục.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } else if (status.isGranted) {
      // Quyền đã được cấp
      _isListening = true;
      print('Microphone permission already granted');
    }
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => {
          print('onError: $val'),
          if (val.errorMsg == "error_speech_timeout" ||
              val.errorMsg == "error_no_match")
            {
              setState(() {
                _isListening = false;
              }),
              controller.incorrectWords.value =
                  "❌ Unrelated sound. Please try again.",
            }
        },
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
            controller.recognizedText.value = _text;

            // Tính toán điểm ngay khi text thay đổi và đã dừng nói
            if (!_isListening) {
              _calculateScore();
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
      // Tính toán điểm ngay sau khi dừng speech
      _calculateScore();
    }
  }

  //chat
  int calculateLevenshteinDistance(String s1, String s2) {
    int m = s1.length;
    int n = s2.length;

    // Tạo ma trận với kích thước (m+1) x (n+1)
    List<List<int>> d = List.generate(m + 1, (i) => List<int>.filled(n + 1, 0));

    // Khởi tạo hàng đầu tiên và cột đầu tiên của ma trận
    for (int i = 0; i <= m; i++) {
      d[i][0] = i;
    }
    for (int j = 0; j <= n; j++) {
      d[0][j] = j;
    }

    // Tính toán các giá trị còn lại của ma trận
    for (int i = 1; i <= m; i++) {
      for (int j = 1; j <= n; j++) {
        int cost = (s1[i - 1] == s2[j - 1]) ? 0 : 1;
        d[i][j] = [
          d[i - 1][j] + 1, // Xóa
          d[i][j - 1] + 1, // Thêm
          d[i - 1][j - 1] + cost // Sửa
        ].reduce((a, b) => a < b ? a : b); // Lấy giá trị nhỏ nhất
      }
    }

    // Giá trị ở ô cuối cùng của ma trận là khoảng cách Levenshtein
    return d[m][n];
  }

  void _calculateScore() {
    try {
      String recognizedText = controller.recognizedText.value.toLowerCase();
      String correctText = "";

      if (controller.currentSpeakingPart.value == 1) {
        correctText = controller.speakingTopicData.value
            .vocabulary[controller.currentQuestionIndex.value]
            .toLowerCase();
      } else if (controller.currentSpeakingPart.value == 2) {
        correctText = controller.speakingTopicData.value
            .sentences[controller.currentQuestionIndex.value]
            .toLowerCase();
      } else if (controller.currentSpeakingPart.value == 3) {
        correctText =
            controller.speakingTopicData.value.paragraph.toLowerCase();
      }

      if (recognizedText.isEmpty || correctText.isEmpty) {
        print("recognizedText hoặc correctText trống!");
        controller.pronunciationScore.value = 0;
        controller.incorrectWords.value =
            "❌ Unrelated sound. Please try again.";
        return;
      }

      int distance = calculateLevenshteinDistance(recognizedText, correctText);

      double score = (1 - (distance / correctText.length)) * 100;

      // Giới hạn điểm trong khoảng 0-100
      score = score.clamp(0.0, 100.0);

      controller.pronunciationScore.value =
          score.round() as double; // Làm tròn thành số nguyên
      controller.incorrectWords.value = score >= 50 ? "Good" : "Passed";
      print("Score: ${score.round()}"); // In ra số nguyên
    } catch (e) {
      print("Lỗi khi tính điểm phát âm: $e");
    }
  }

  void _previousQuestion() {
    _clearData(); // Reset data before moving to the previous question
    if (controller.currentQuestionIndex.value > 0) {
      controller.currentQuestionIndex.value--;
    } else if (controller.currentSpeakingPart.value > 1) {
      controller.currentSpeakingPart.value--;
      if (controller.currentSpeakingPart.value == 1) {
        controller.currentQuestionIndex.value =
            controller.speakingTopicData.value.vocabulary.length - 1;
      } else if (controller.currentSpeakingPart.value == 2) {
        controller.currentQuestionIndex.value =
            controller.speakingTopicData.value.sentences.length - 1;
      }
    }
  }

  void _nextQuestion() {
    _clearData(); // Reset data before moving to the next question
    controller.nextQuestion();
  }

  void _clearData() {
    controller.recognizedText.value = "";
    controller.incorrectWords.value = "";
    controller.pronunciationScore.value = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.speakingTopicData.value.topicName)),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.green,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(() => Text(
                        "Phần ${controller.currentSpeakingPart.value} - Câu ${controller.currentQuestionIndex.value + 1} / ${controller.currentSpeakingPart.value == 1 ? controller.speakingTopicData.value.vocabulary.length : controller.currentSpeakingPart.value == 2 ? controller.speakingTopicData.value.sentences.length : 1}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Look, listen and repeat",
                          style: TextStyle(fontSize: 18.0),
                        ),
                        const SizedBox(height: 16.0),
                        ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxHeight: 150,
                          ),
                          child: Obx(() => Image.network(
                                controller.speakingTopicData.value.imageUrl,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                    const SizedBox(
                                  height: 150,
                                  child: Icon(Icons.image, size: 50),
                                ),
                              )),
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IconButton(
                              onPressed: () {
                                controller.speakCurrentSentence();
                              },
                              icon: const Icon(Icons.play_circle_outline,
                                  size: 40),
                            ),
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: Obx(() {
                                String textToDisplay = "";
                                if (controller.currentSpeakingPart.value == 1) {
                                  textToDisplay = controller
                                          .speakingTopicData.value.vocabulary[
                                      controller.currentQuestionIndex.value];
                                } else if (controller
                                        .currentSpeakingPart.value ==
                                    2) {
                                  textToDisplay = controller
                                          .speakingTopicData.value.sentences[
                                      controller.currentQuestionIndex.value];
                                } else if (controller
                                        .currentSpeakingPart.value ==
                                    3) {
                                  textToDisplay = controller
                                      .speakingTopicData.value.paragraph;
                                }
                                return Text(
                                  textToDisplay,
                                  style: const TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Obx(() {
                          String instructionText = "";
                          String textToDisplay = "";

                          if (controller.currentSpeakingPart.value == 1) {
                            instructionText = "Hãy đọc to từ:";
                            textToDisplay =
                                controller.speakingTopicData.value.vocabulary[
                                    controller.currentQuestionIndex.value];
                          } else if (controller.currentSpeakingPart.value ==
                              2) {
                            instructionText = "Hãy đọc to câu:";
                            textToDisplay =
                                controller.speakingTopicData.value.sentences[
                                    controller.currentQuestionIndex.value];
                          } else if (controller.currentSpeakingPart.value ==
                              3) {
                            instructionText = "Hãy đọc to đoạn văn sau:";
                            textToDisplay =
                                controller.speakingTopicData.value.paragraph ??
                                    "Không có đoạn văn nào!";
                          }

                          return Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8.0),
                              color: Colors.purple[50],
                            ),
                            child: Text(
                              "$instructionText\n$textToDisplay",
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 16.0),
                            ),
                          );
                        }),
                        const SizedBox(height: 32.0),
                        InkWell(
                          onTap: () {
                            _listen();
                          },
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _isListening ? Colors.red : Colors.green,
                            ),
                            child: Icon(
                              _isListening ? Icons.stop : Icons.mic,
                              size: 60,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32.0),
                        Obx(() => Text(
                              "Recognized Text: ${controller.recognizedText.value}",
                              style: TextStyle(fontSize: 16),
                            )),
                        const SizedBox(height: 20),
                        Obx(() => Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              decoration: BoxDecoration(
                                color: controller.incorrectWords.value ==
                                            "❌ Unrelated sound. Please try again." ||
                                        controller.incorrectWords.value ==
                                            "Passed"
                                    ? Colors.pink[100]
                                    : Colors.green[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "Incorrect Words: ${controller.incorrectWords.value}",
                                style: TextStyle(fontSize: 16),
                              ),
                            )),
                        const SizedBox(height: 20),
                        Obx(() => Text(
                              "Pronunciation Score: ${controller.pronunciationScore.value}",
                              style: TextStyle(fontSize: 16),
                            )),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: _previousQuestion,
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                  minimumSize: Size(40, 40)),
                              child: Icon(Icons.arrow_back_ios),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _nextQuestion();
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purple[100],
                                  minimumSize: Size(40, 40)),
                              child: Icon(Icons.arrow_forward_ios),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
