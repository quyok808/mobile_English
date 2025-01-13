// user_info_row.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onlya_english/app/themes/theme.dart';
import 'CustomText.dart';

class UserInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String content; // Dữ liệu đã được truyền vào

  const UserInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppTheme.light_blue,
            child: Icon(icon, size: 30),
          ),
          SizedBox(width: 10),
          Customtext(NoiDung: content), // Hiển thị nội dung đã truyền vào
        ],
      ),
    );
  }
}
