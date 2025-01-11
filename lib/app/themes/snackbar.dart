// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'theme.dart';

class SnackBarCustom {
  //SnackBar
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
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red[400],
      titleText: Row(
        children: [
          Icon(Icons.error,
              color: Colors.white), // Thay đổi icon và màu sắc theo ý muốn
          SizedBox(width: 8), // Khoảng cách giữa icon và chữ
          Text(
            title,
            style: GoogleFonts.jetBrainsMono(
                fontWeight: FontWeight.bold, color: Colors.white),
          ), // Thay đổi màu sắc chữ nếu cần
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
