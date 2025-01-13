import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../themes/theme.dart';
import '../controllers/essay_controller.dart';
import 'essay_list_view.dart';

class EssayView extends StatelessWidget {
  final EssayController controller = Get.find<EssayController>();
  final TextEditingController _essayController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Write an Essay',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: AppTheme.color_appbar, // AppBar color
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Dropdown for Topic selection
            Obx(() => DropdownButton<String>(
                  value: controller.selectedTopic.value,
                  onChanged: (value) {
                    if (value != null) {
                      controller.selectedTopic.value = value;
                      controller.essayText.value = ''; // Reset essay content
                      _essayController.clear(); // Clear TextField
                    }
                  },
                  items: [
                    'General',
                    'Technology',
                    'Environment',
                    'Education',
                    'Health'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: TextStyle(fontSize: 16)),
                    );
                  }).toList(),
                  isExpanded: true, // Make the dropdown take full width
                )),
            SizedBox(
                height: 16), // Adjusted space between dropdown and text field

            // TextField for Essay input
            Expanded(
              child: TextField(
                controller: _essayController,
                onChanged: (value) => controller.essayText.value = value,
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                  hintText: 'Type your essay here...',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(16),
                ),
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 20),
            // Analyze Button
            Obx(() => ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () => controller.analyzeAndSaveEssay(),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Analyze Essay',
                          style: TextStyle(fontSize: 16),
                        ),
                )),
            SizedBox(height: 20),

            // Feedback Section
            Obx(() => controller.feedback.value.isNotEmpty
                ? Flexible(
                    child: SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          controller.feedback.value,
                          style:
                              TextStyle(color: Colors.blueGrey, fontSize: 16),
                        ),
                      ),
                    ),
                  )
                : SizedBox.shrink()),
            SizedBox(height: 20),

            // View Essay List Button
            ElevatedButton(
              onPressed: () {
                Get.to(() => EssayListView());
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'View Essay List',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
