import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../models/essay_model.dart';
import '../../../themes/theme.dart';
import '../controllers/essay_controller.dart';
import 'EssayDetailView.dart';

class EssayListView extends StatelessWidget {
  final EssayController controller = Get.find<EssayController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Danh sách Bài luận',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppTheme.color_appbar,
        leading: IconButton(
          onPressed: Get.back,
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<List<Essay>>(
          stream: controller.essaysStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  'Không có bài luận nào.',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              );
            }

            final essays = snapshot.data!;
            final essaysWithTopic =
                essays.where((essay) => essay.topic.isNotEmpty).toList();

            if (essaysWithTopic.isEmpty) {
              return Center(
                child: Text(
                  'Không có bài luận với chủ đề.',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              );
            }

            // Sử dụng Set để đảm bảo chỉ hiển thị một bài luận cho mỗi chủ đề
            final displayedTopics = <String>{};
            final uniqueEssays = essaysWithTopic.where((essay) {
              final isUnique = !displayedTopics.contains(essay.topic);
              if (isUnique) {
                displayedTopics.add(essay.topic);
              }
              return isUnique;
            }).toList();

            return ListView.builder(
              itemCount: uniqueEssays.length,
              itemBuilder: (context, index) {
                final essay = uniqueEssays[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: InkWell(
                    onTap: () {
                      // Truyền danh sách các bài luận cùng chủ đề vào EssayDetailView
                      final topicEssays = essaysWithTopic
                          .where((e) => e.topic == essay.topic)
                          .toList();
                      Get.to(() => EssayDetailView(essays: topicEssays));
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Chủ đề
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
                          // Hiển thị ngày
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Ngày tạo: ${essay.createdAt}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
