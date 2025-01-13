// app/data/models/lesson_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class LessonModel {
  String lessonId;
  String courseId;
  String title;
  dynamic content; // Có thể thay đổi kiểu dữ liệu tùy theo nội dung bài học
  int order;

  LessonModel({
    required this.lessonId,
    required this.courseId,
    required this.title,
    required this.content,
    required this.order,
  });

  factory LessonModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return LessonModel(
      lessonId: doc.id,
      courseId: data['courseId'] ?? '',
      title: data['title'] ?? '',
      content: data['content'],
      order: data['order'] ?? 0,
    );
  }
}