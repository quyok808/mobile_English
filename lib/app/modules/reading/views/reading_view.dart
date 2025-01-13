import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onlya_english/app/themes/theme.dart';
import '../controllers/reading_controller.dart';
import 'reading_detail_view.dart';

class ReadingView extends StatelessWidget {
  final ReadingController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text(
          'Reading Practice',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: AppTheme.color_appbar,
        centerTitle: true,
        leading: IconButton(
          onPressed: Get.back,
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.readings.isEmpty) {
            return const Center(child: Text('No readings available.'));
          }

          return ListView.builder(
            itemCount: controller.readings.length,
            itemBuilder: (context, index) {
              final reading = controller.readings[index];
              return Card(
                color: Colors.white,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 4,
                child: ListTile(
                  title: Text(
                    reading['title'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Level: ${reading['level']}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ReadingDetailView(reading: reading),
                      ),
                    );
                  },
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
