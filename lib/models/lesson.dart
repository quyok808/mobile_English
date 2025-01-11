class Question {
  final String question;
  final String answer;

  Question({required this.question, required this.answer});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      question: json['question'],
      answer: json['answer'],
    );
  }
}

class Section {
  final String audio;
  final String transcript;
  final String translation;
  final List<Question> questions;

  Section({
    required this.audio,
    required this.transcript,
    required this.translation,
    required this.questions,
  });

  // Getter để lấy đường dẫn từ assets
  String get audioPath => 'assets/audios/$audio';

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      audio: json['audio'],
      transcript: json['transcript'],
      translation: json['translation'],
      questions: (json['questions'] as List)
          .map((q) => Question.fromJson(q))
          .toList(),
    );
  }
}

class Lesson {
  final Map<String, Section> sections;

  Lesson({required this.sections});

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      sections: json.map((key, value) => MapEntry(key, Section.fromJson(value))),
    );
  }
}