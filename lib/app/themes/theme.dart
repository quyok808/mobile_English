// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // color
  static final lightTheme = ThemeData.light();
  static final darkTheme = ThemeData.dark();
  static final blue = Colors.blue[200];
  static final orange = Color(0xFFF2C18D);
  static final green = Colors.greenAccent[400];

  //font chữ
  static final lobsterFont =
      GoogleFonts.lobster(fontWeight: FontWeight.bold, fontSize: 24);
  static final jetBrainsMono =
      GoogleFonts.jetBrainsMono(fontWeight: FontWeight.bold);
  static final ChuVietTay = GoogleFonts.fleurDeLeah(fontSize: 42);
  static final literata = GoogleFonts.literata(fontSize: 24);

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
      backgroundColor: Colors.red[400],
      titleText: Row(
        children: [
          Icon(Icons.error,
              color: Colors.white), // Thay đổi icon và màu sắc theo ý muốn
          SizedBox(width: 8), // Khoảng cách giữa icon và chữ
          Text(title,
              style: AppTheme.jetBrainsMono), // Thay đổi màu sắc chữ nếu cần
        ],
      ),
    );
  }

  static void GetSnackBarSuccess(
      {required String title, required String content}) {
    Get.snackbar(
      title, // Title
      content, // Message
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppTheme.green,
      titleText: Row(
        children: [
          Icon(Icons.check_circle,
              color: Colors.white), // Thay đổi icon và màu sắc theo ý muốn
          SizedBox(width: 8), // Khoảng cách giữa icon và chữ
          Text(title,
              style: AppTheme.jetBrainsMono), // Thay đổi màu sắc chữ nếu cần
        ],
      ),
    );
  }
}
