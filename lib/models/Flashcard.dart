class Flashcard {
  late final String id;
  final String word;
  final String description;
  final String pronunciation;

  Flashcard({
    required this.id,
    required this.word,
    required this.description,
    required this.pronunciation,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'word': word,
      'description': description,
      'pronunciation': pronunciation,
    };
  }

  factory Flashcard.fromMap(Map<String, dynamic> map) {
    return Flashcard(
      id: map['id'],
      word: map['word'],
      description: map['description'],
      pronunciation: map['pronunciation'],
    );
  }
}
