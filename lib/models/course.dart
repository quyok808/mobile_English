// app/data/models/course_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class CourseModel {
  String courseId;
  String name;
  String type;
  String description;
  String imageUrl;

  CourseModel({
    required this.courseId,
    required this.name,
    required this.type,
    required this.description,
    required this.imageUrl,
  });

  factory CourseModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return CourseModel(
      courseId: doc.id,
      name: data['name'] ?? '',
      type: data['type'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }
}