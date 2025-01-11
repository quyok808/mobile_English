import 'question.dart';

class Section {
  String audio;
  String transcript;
  String translation;
  List<Question> questions;

  Section({
    required this.audio,
    required this.transcript,
    required this.translation,
    required this.questions,
  });

  factory Section.fromJson(Map<String, dynamic> json) {
    var list = json['questions'] as List;
    List<Question> questionsList =
        list.map((i) => Question.fromJson(i)).toList();

    return Section(
      audio: json['audio'],
      transcript: json['transcript'],
      translation: json['Translation'],
      questions: questionsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'audio': audio,
      'transcript': transcript,
      'Translation': translation,
      'questions': questions.map((e) => e.toJson()).toList(),
    };
  }
}