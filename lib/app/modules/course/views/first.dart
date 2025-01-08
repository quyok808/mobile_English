import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/course_controller.dart';

class CourseView extends GetView<CourseController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Khóa Học'),
        centerTitle: true, // Sửa lại: centerTitle đúng chính tả và đúng vị trí
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() {
          return GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 1.4,
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
            children: controller.courses.map((course) {
              return Card(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        course['imageUrl']!,
                        fit: BoxFit.contain, 
                        height: 100,
                        width: 100,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          course['title']!,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          course['description']!,
                          textAlign: TextAlign.center, // Căn giữa text
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        }),
      ),
    );
  }
}