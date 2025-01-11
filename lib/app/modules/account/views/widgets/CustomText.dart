// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class Customtext extends StatelessWidget {
  final String NoiDung;

  const Customtext({super.key, required this.NoiDung});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        NoiDung,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w300,
          fontStyle: FontStyle.italic,
        ),
        overflow: TextOverflow.ellipsis, // Thêm dấu ba chấm nếu chữ quá dài
        maxLines: 1, // Giới hạn số dòng hiển thị
      ),
    );
  }
}
