import 'package:cloud_firestore/cloud_firestore.dart';

class Essay {
  final String content;
  final String feedback;
  final String topic;
  final String userId;
  final DateTime createdAt;

  Essay({required this.userId,required this.content, required this.feedback, required this.topic, required this.createdAt});

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'content': content,
      'feedback': feedback,
      'topic': topic,
      'createdAt': createdAt,
    };
  }

  factory Essay.fromMap(Map<String, dynamic> map) {
    return Essay( 
      userId: map['userId'],
      content: map['content'] ?? '',
      feedback: map['feedback'] ?? '',
      topic: map['topic'] ?? 'General',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}
