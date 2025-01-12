import 'package:cloud_firestore/cloud_firestore.dart';

class SpeakingTopicModel {
  String topicId;
  String topicName;
  List<String> vocabulary;
  List<String> sentences;
  String paragraph;
  String imageUrl;

  SpeakingTopicModel({
    required this.topicId,
    required this.topicName,
    required this.vocabulary,
    required this.sentences,
    required this.paragraph,
    required this.imageUrl
  });

  factory SpeakingTopicModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return SpeakingTopicModel(
      topicId: doc.id,
      topicName: data['topicName'] ?? '',
      vocabulary: List<String>.from(data['vocabulary'] ?? []),
      sentences: List<String>.from(data['sentences'] ?? []),
      paragraph: data['paragraph'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }
}