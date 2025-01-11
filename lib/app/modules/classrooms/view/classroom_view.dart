import 'package:flutter/material.dart';
import 'package:onlya_english/app/themes/theme.dart';

class ClassroomView extends StatelessWidget {
  const ClassroomView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Khoá học'),
        centerTitle: true,
        backgroundColor: AppTheme.blue,
      ),
    );
  }
}
