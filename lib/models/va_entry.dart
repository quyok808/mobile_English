class VAEntry {
  final int id;
  final String word;
  final String html;
  final String description;
  final String pronounce;

  VAEntry({
    required this.id,
    required this.word,
    required this.html,
    required this.description,
    required this.pronounce,
  });

  // Tạo một đối tượng từ Map dữ liệu (khi lấy từ SQLite)
  factory VAEntry.fromMap(Map<String, dynamic> map) {
    return VAEntry(
      id: map['id'] , // Chuyển đổi sang kiểu int nếu cần thiết
      word: map['word'] , // Đảm bảo không null
      html: map['html'] , // Đảm bảo không null
      description: map['description'] , // Đảm bảo không null
      pronounce: map['pronounce'] , // Đảm bảo không null
    );
  }

  // Chuyển đối tượng thành Map để lưu vào cơ sở dữ liệu
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'word': word,
      'html': html,
      'description': description,
      'pronounce': pronounce,
    };
  }
}
