import 'package:flutter/material.dart';
import '../../../../models/essay_model.dart';

class FullEssayView extends StatelessWidget {
  final Essay essay;

  FullEssayView({required this.essay});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết Bài luận', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thời gian tạo bài luận
            Text(
              'Thời gian: ${essay.createdAt}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 16),
            // Nội dung bài luận
            Text(
              'Nội dung: ${essay.content.replaceAll(RegExp(r'[^\x00-\x7F]'), '')}', // Loại bỏ ký tự không hợp lệ
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            // Phản hồi
            Text(
              'Phản hồi: ${essay.feedback.replaceAll(RegExp(r'[^\x00-\x7F]'), '')}', // Loại bỏ ký tự không hợp lệ
              style: TextStyle(color: Colors.blueGrey, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}