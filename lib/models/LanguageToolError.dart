class LanguageToolError {
  final int offset; // Vị trí bắt đầu của lỗi trong văn bản
  final int length; // Chiều dài của lỗi (số ký tự bị sai)
  final String message; // Thông điệp lỗi
  final List<String> suggestions; // Danh sách các gợi ý sửa lỗi

  LanguageToolError({
    required this.offset,
    required this.length,
    required this.message,
    required this.suggestions,
  });

  factory LanguageToolError.fromJson(Map<String, dynamic> json) {
    return LanguageToolError(
      offset: json['offset'],
      length: json['length'],
      message: json['message'],
      suggestions: List<String>.from(json['replacements']?.map((x) => x['value']) ?? []),
    );
  }
}