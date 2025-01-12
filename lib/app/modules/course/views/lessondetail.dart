// lesson_detail/views/lesson_detail_view.dart (hoặc bạn có thể để chung thư mục views với first.dart)
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onlya_english/models/lesson.dart';

class LessonDetailView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final LessonModel lesson = Get.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(lesson.title),
      ),
      body: Center(
        child: Text("Nội dung bài học: ${lesson.content}"),
      ),
    );
  }
}