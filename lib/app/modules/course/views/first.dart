import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onlya_english/app/routes/app_routes.dart';
import 'package:onlya_english/app/themes/theme.dart';
import '../controllers/course_controller.dart';

class CourseView extends GetView<CourseController> {
  const CourseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Obx(() => Text(
              controller.selectedType.value == ""
                  ? "Khóa học"
                  : "Danh sách các bài ${controller.selectedType.value}",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            )),
        centerTitle: true,
        leading: Obx(
          () => controller.selectedType.value == ""
              ? const SizedBox.shrink()
              : IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    controller.resetData();
                    Get.back();
                  },
                ),
        ),
        backgroundColor: AppTheme.color_appbar,
      ),
      body: _buildSpeakingTopicsList(),
    );
  }

  // Widget hiển thị danh sách speaking topics
  Widget _buildSpeakingTopicsList() {
    return Obx(() {
      return Padding(
        padding: EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.8,
          ),
          itemCount: controller.speakingTopics.length,
          itemBuilder: (context, index) {
            final speakingTopic = controller.speakingTopics[index];
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                bool isHovering = false;
                return InkWell(
                  onTap: () async {
                    await controller
                        .getSpeakingTopicData(speakingTopic.topicId);
                    Get.toNamed(AppRoutes.SPEAKING_PRACTICE);
                  },
                  onHover: (hovering) {
                    setState(() {
                      isHovering = hovering;
                    });
                  },
                  child: Card(
                    elevation: isHovering ? 8.0 : 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    color:
                        isHovering ? Colors.green[100] : Colors.lightGreen[50],
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            speakingTopic.imageUrl,
                            height: 120.0,
                            width: 120.0,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                              Icons.error,
                              size: 64,
                              color: Colors.red,
                            ),
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            speakingTopic.topicName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.blueGrey[800],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      );
    });
  }
}
