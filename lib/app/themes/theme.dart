// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // color
  static final lightTheme = ThemeData.light();
  static final darkTheme = ThemeData.dark();
  static final blue = Colors.blue[200];
  static final orange = Color(0xFFF2C18D);

  //font chữ
  static final lobsterFont =
      GoogleFonts.lobster(fontWeight: FontWeight.bold, fontSize: 24);
  static final jetBrainsMono =
      GoogleFonts.jetBrainsMono(fontWeight: FontWeight.bold);

  static void GetSnackBarWarning(
      {required String title, required String content}) {
    Get.snackbar(
      title, // Title
      content, // Message
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppTheme.orange,
      titleText: Row(
        children: [
          Icon(Icons.warning,
              color: Colors.yellow), // Thay đổi icon và màu sắc theo ý muốn
          SizedBox(width: 8), // Khoảng cách giữa icon và chữ
          Text(title,
              style: AppTheme.jetBrainsMono), // Thay đổi màu sắc chữ nếu cần
        ],
      ),
    );
  }

  static void GetSnackBarError(
      {required String title, required String content}) {
    Get.snackbar(
      title, // Title
      content, // Message
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppTheme.orange,
      titleText: Row(
        children: [
          Icon(Icons.error,
              color: Colors.red), // Thay đổi icon và màu sắc theo ý muốn
          SizedBox(width: 8), // Khoảng cách giữa icon và chữ
          Text(title,
              style: AppTheme.jetBrainsMono), // Thay đổi màu sắc chữ nếu cần
        ],
      ),
    );
  }
}
