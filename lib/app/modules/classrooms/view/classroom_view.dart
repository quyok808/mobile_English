import 'package:flutter/material.dart';
import 'package:onlya_english/app/modules/classrooms/view/widgets/item_column.dart';
import 'package:onlya_english/app/modules/listening/bindings/listening_binding.dart';
import 'package:onlya_english/app/routes/bound_widget.dart';
import 'package:onlya_english/app/themes/theme.dart';

import '../../listening/views/listening_view.dart';

class ClassroomView extends StatelessWidget {
  const ClassroomView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          'Khoá học',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              ItemClassroom(
                imagelink:'assets/images/headphones.png', // trong bên dưới có hết link image có hết
                content: 'Luyện nghe', // thế thôi, không cần chỉnh j thêm
                path: '/listening', // lấy bên app-routes.dart
              ),
              // ItemClassroom(
              //   imagelink: 'assets/images/speak.png',
              //   content: 'Luyện nói',
              // ),
              ItemClassroom(
                imagelink: 'assets/images/read.png',
                content: 'Luyện đọc',
                path: '/reading',
              ),
              // ItemClassroom(
              //   imagelink: 'assets/images/write.png',
              //   content: 'Luyện viết',
              // ),
              // ItemClassroom(
              //   imagelink: 'assets/images/dictionary.png',
              //   content: 'Từ vựng của tôi',
              // ),
              // ItemClassroom(
              //   imagelink: 'assets/images/mini-test.png',
              //   content: 'Bài kiểm tra ngắn',
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
