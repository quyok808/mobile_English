import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onlya_english/app/routes/app_routes.dart';
import 'package:onlya_english/models/course.dart';
import 'package:onlya_english/models/lesson.dart';
import '../controllers/course_controller.dart';

class CourseView extends GetView<CourseController> {
  const CourseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.selectedType.value == ""
            ? "Khóa học"
            : "Danh sách các bài ${controller.selectedType.value}")),
        centerTitle: true,
        leading: Obx(() => controller.selectedType.value == ""
            ? const SizedBox.shrink()
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  controller.resetData();
                },
              )),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.selectedType.value == "") {
          // Hiển thị CourseView (chọn type)
          return _buildCourseTypeSelection();
        } else if (controller.selectedType.value == "nói" &&
            controller.speakingTopics.isNotEmpty) {
          // Hiển thị danh sách speaking_topics
          return _buildSpeakingTopicsList();
        } else if (controller.dbCourses.isNotEmpty &&
            controller.lessons.isEmpty) {
          // Hiển thị CourseView (danh sách khóa học)
          return _buildCourseList();
        } else {
          // Hiển thị LessonView (danh sách bài học)
          return _buildLessonList();
        }
      }),
    );
  }

  // Widget chọn type (Nghe, Nói, Đọc, Viết)
  Widget _buildCourseTypeSelection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1.4,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        children: controller.courses.map((course) {
          return GestureDetector(
            onTap: () {
              if (course['type'] == "nói") {
                controller.getSpeakingTopics(); // Lấy danh sách speaking topics
              }
              controller.getCoursesByType(course['type']!);
            },
            child: Card(
              child: SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Image.asset(
                        course['imageUrl']!,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        course['title']!,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        course['description']!,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // Widget hiển thị danh sách khóa học
  Widget _buildCourseList() {
    return ListView.builder(
      itemCount: controller.dbCourses.length,
      itemBuilder: (context, index) {
        CourseModel course = controller.dbCourses[index];
        return ListTile(
          leading: Image.network(course.imageUrl),
          title: Text(course.name),
          subtitle: Text(course.description),
          onTap: () {
            controller.getLessonsByCourseId(course.courseId);
          },
        );
      },
    );
  }

  // Widget hiển thị danh sách bài học
  Widget _buildLessonList() {
    return ListView.builder(
      itemCount: controller.lessons.length,
      itemBuilder: (context, index) {
        LessonModel lesson = controller.lessons[index];

        if (controller.selectedType.value == "nghe") {
          // Phần Nghe
          return ListTile(
            leading: const Icon(Icons.headset),
            title: Text(lesson.title),
            subtitle: const Text(
                "Cấp độ: Cơ bản"), // Thay bằng thông tin cấp độ thực tế
            trailing: IconButton(
              icon: const Icon(
                  Icons.play_arrow), // Sau này có thể thay bằng AnimatedIcon
              onPressed: () {
                // Xử lý phát âm thanh
                // Get.to(()=>LessonDetailView(), arguments: lesson.content);
              },
            ),
            onTap: () {
              // Get.to(()=>LessonDetailView(), arguments: lesson.content);
            },
          );
        } else if (controller.selectedType.value == "đọc") {
          // Phần Đọc
          return Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(lesson.title),
                  subtitle: const Text(
                      "Cấp độ: Trung cấp"), // Thay bằng thông tin cấp độ thực tế
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    lesson.content.length > 100
                        ? lesson.content.substring(0, 100) + "..."
                        : lesson.content,
                  ),
                ),
                ButtonBar(
                  children: [
                    TextButton(
                      onPressed: () {
                        // Chuyển sang màn hình đọc chi tiết
                        // Get.to(() => ReadingDetailView(), arguments: lesson);
                      },
                      child: const Text("Đọc bài"),
                    ),
                  ],
                ),
              ],
            ),
          );
        } else if (controller.selectedType.value == "viết") {
          // Phần Viết
          return ListTile(
            leading: const Icon(Icons.edit),
            title: Text(lesson.title),
            subtitle: const Text(
                "Chủ đề: Giới thiệu"), // Thay bằng thông tin chủ đề thực tế
            trailing: OutlinedButton(
              onPressed: () {
                // Chuyển sang màn hình luyện viết
                // Get.to(() => WritingPracticeView(), arguments: lesson);
              },
              child: const Text("Viết bài"),
            ),
            onTap: () {
              // Get.to(()=>LessonDetailView(), arguments: lesson.content);
            },
          );
        } else {
          return const SizedBox
              .shrink(); // Trường hợp không xác định, không hiển thị gì
        }
      },
    );
  }

  // Widget hiển thị danh sách speaking topics
  Widget _buildSpeakingTopicsList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 1.4,
        ),
        itemCount: controller.speakingTopics.length,
        itemBuilder: (context, index) {
          final speakingTopic = controller.speakingTopics[index];
          // Biến state để quản lý trạng thái hover
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              bool isHovering = false; // Biến để theo dõi trạng thái hover
              return InkWell(
                onTap: () {
                  controller.getSpeakingTopicData(speakingTopic.topicId);
                  Get.toNamed(AppRoutes.SPEAKING_PRACTICE);
                },
                onHover: (hovering) {
                  setState(() {
                    isHovering = hovering; // Cập nhật trạng thái hover
                  });
                },
                child: Card(
                  elevation:
                      isHovering ? 8.0 : 4.0, // Thay đổi elevation khi hover
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  // Thay đổi màu nền khi hover
                  color: isHovering ? Colors.green[100] : Colors.lightGreen[50],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Hình ảnh bo tròn góc
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          speakingTopic.imageUrl,
                          height: 90.0,
                          width: 90.0,
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
                      const SizedBox(height: 8.0),
                      // Tên chủ đề
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
  }
}
