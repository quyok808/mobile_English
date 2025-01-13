import 'package:cloud_firestore/cloud_firestore.dart';

import 'feedback_model.dart';

class WritingModel {
  String id; // ID duy nhất của bài luận
  String content; // Nội dung bài luận
  String userId; // ID của người dùng
  List<FeedbackModel> feedback; // Danh sách phản hồi từ API LanguageTool
  DateTime createdAt; // Thời gian tạo bài luận

  WritingModel({
    required this.id,
    required this.content,
    required this.userId,
    required this.feedback,
    required this.createdAt,
  });

  /// Tạo model từ Firebase document
  factory WritingModel.fromFirestore(Map<String, dynamic> data, String id) {
    return WritingModel(
      id: id,
      content: data['content'] ?? '',
      userId: data['userId'] ?? '',
      feedback: (data['feedback'] as List<dynamic>? ?? [])
          .map((e) => FeedbackModel.fromJson(e))
          .toList(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  /// Chuyển model thành Map để lưu vào Firebase
  Map<String, dynamic> toFirestore() {
    return {
      'content': content,
      'userId': userId,
      'feedback': feedback.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toUtc(),
    };
  }
}