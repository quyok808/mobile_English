import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../models/essay_model.dart';
import 'FullEssayView.dart';

class EssayDetailView extends StatefulWidget {
  final List<Essay> essays;

  EssayDetailView({required this.essays});

  @override
  _EssayDetailViewState createState() => _EssayDetailViewState();
}

class _EssayDetailViewState extends State<EssayDetailView> {
  int? expandedIndex; // Biến để lưu chỉ số của card đang mở rộng

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
        child: ListView.builder(
          itemCount: widget.essays.length,
          itemBuilder: (context, index) {
            final essay = widget.essays[index];
            return EssayCard(
              essay: essay,
              isExpanded: expandedIndex == index, // Kiểm tra xem card này có mở rộng không
              onTap: () {
                setState(() {
                  if (expandedIndex == index) {
                    expandedIndex = null; // Nếu card đang mở rộng, thu lại
                  } else {
                    expandedIndex = index; // Mở rộng card mới và thu lại các card khác
                  }
                });
              },
            );
          },
        ),
      ),
    );
  }
}

class EssayCard extends StatelessWidget {
  final Essay essay;
  final bool isExpanded;
  final VoidCallback onTap;

  EssayCard({required this.essay, required this.isExpanded, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap, // Gọi hàm onTap khi nhấn vào card
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hiển thị chủ đề
              Text(
                essay.topic,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              SizedBox(height: 8),
              // Tóm tắt nội dung bài luận
              Text(
                essay.content.length > 100
                    ? '${essay.content.substring(0, 100)}...'
                    : essay.content,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 12),
              // Hiển thị ngày tạo
              Text(
                'Ngày tạo: ${essay.createdAt}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              // Nếu card được mở rộng, hiển thị toàn bộ nội dung và phản hồi
              if (isExpanded) ...[
                SizedBox(height: 16),
                Text(
                  'Nội dung: ${essay.content}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Text(
                  'Phản hồi: ${essay.feedback}',
                  style: TextStyle(color: Colors.blueGrey, fontSize: 14),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
