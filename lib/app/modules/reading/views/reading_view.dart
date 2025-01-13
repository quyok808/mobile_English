import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reading_controller.dart';
import 'reading_detail_view.dart';

// class ReadingView extends StatelessWidget {
//   final ReadingController controller = Get.find();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Reading Practice'),
//         backgroundColor: Colors.blue[400],
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (controller.readings.isEmpty) {
//           return const Center(child: Text('No readings available.'));
//         }

//         return ListView.builder(
//           itemCount: controller.readings.length,
//           itemBuilder: (context, index) {
//             final reading = controller.readings[index];
//             return Card(
//               margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               elevation: 4,
//               child: ListTile(
//                 title: Text(reading['title']),
//                 subtitle: Text('Level: ${reading['level']}'),
//                 onTap: () {
//                   showReadingDetail(context, reading);
//                 },
//               ),
//             );
//           },
//         );
//       }),
//     );
//   }

//   void showReadingDetail(BuildContext context, Map<String, dynamic> reading) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text(reading['title']),
//           content: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('Level: ${reading['level']}', style: const TextStyle(fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 10),
//                 Text(reading['content']),
//                 const SizedBox(height: 20),
//                 const Text('Vocabulary:', style: TextStyle(fontWeight: FontWeight.bold)),
//                 ...reading['vocabulary'].map<Widget>((vocab) {
//                   return ListTile(
//                     title: Text(vocab['word']),
//                     subtitle: Text('Meaning: ${vocab['meaning']}'),
//                   );
//                 }).toList(),
//                 const SizedBox(height: 20),
//                 const Text('Questions:', style: TextStyle(fontWeight: FontWeight.bold)),
//                 ...reading['questions'].map<Widget>((question) {
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(question['question']),
//                       ...question['options'].map<Widget>((option) {
//                         return Padding(
//                           padding: const EdgeInsets.only(left: 8.0, top: 4),
//                           child: Text('- $option'),
//                         );
//                       }).toList(),
//                       const Divider(),
//                     ],
//                   );
//                 }).toList(),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Close'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

class ReadingView extends StatelessWidget {
  final ReadingController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reading Practice'),
        backgroundColor: Colors.blue[400],
      ),
      body: Obx(() {
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
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 4,
              child: ListTile(
                title: Text(reading['title']),
                subtitle: Text('Level: ${reading['level']}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReadingDetailView(reading: reading),
                    ),
                  );
                },
              ),
            );
          },
        );
      }),
    );
  }
}
