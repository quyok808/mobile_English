// ignore_for_file: prefer_typing_uninitialized_variables, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';

class DetailPage extends StatelessWidget {
  final entry;

  DetailPage({required this.entry});

  final FlutterTts _flutterTts = FlutterTts();

  // Hàm phát âm
  void _speakWord(String word) async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.speak(word);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${entry.word}',
          style: TextStyle(
              color: Colors.white), // Đặt màu chữ của tiêu đề thành trắng
        ),
        backgroundColor: Colors.blue[400], // Màu nền bạn yêu cầu
        iconTheme: IconThemeData(
            color: Colors.white), // Đặt màu biểu tượng thành trắng
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hiển thị từ và biểu tượng loa
            Row(
              children: [
                Text(
                  entry.word,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    decoration: TextDecoration.underline,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.volume_up),
                  onPressed: () => _speakWord(entry.word),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              '[${entry.pronounce}]',
              style: TextStyle(
                fontSize: 18, // Cỡ chữ 18
                color: Colors.purpleAccent,
                fontWeight: FontWeight.bold, // Màu chữ tím
              ),
            ),

            SizedBox(height: 16),
            Text(
              '${entry.description}',
              style: TextStyle(
                fontSize: 18, // Cỡ chữ 18
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
