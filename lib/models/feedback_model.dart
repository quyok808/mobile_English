class FeedbackModel {
  int offset; // Vị trí của lỗi trong nội dung
  int length; // Độ dài của lỗi
  String message; // Mô tả lỗi

  FeedbackModel({
    required this.offset,
    required this.length,
    required this.message,
  });

  /// Tạo model từ JSON
  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      offset: json['offset'],
      length: json['length'],
      message: json['message'],
    );
  }

  /// Chuyển model thành JSON
  Map<String, dynamic> toJson() {
    return {
      'offset': offset,
      'length': length,
      'message': message,
    };
  }
}