// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_super_parameters

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onlya_english/app/modules/auth/controllers/auth_controller.dart';
import 'package:onlya_english/app/themes/theme.dart';

class LoginButton extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const LoginButton({
    Key? key,
    required this.emailController,
    required this.passwordController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return ElevatedButton(
      onPressed: () async {
        String email = emailController.text.trim();
        String password = passwordController.text.trim();

        if (email.isEmpty || password.isEmpty) {
          Get.snackbar(
            'Cảnh báo !', // Title
            'Thông tin không được để trống !!!', // Message
            snackPosition: SnackPosition.TOP,
            backgroundColor: AppTheme.orange,
            titleText: Row(
              children: [
                Icon(Icons.warning, color: Colors.red),
                SizedBox(width: 8),
                Text('Cảnh báo !', style: AppTheme.jetBrainsMono),
              ],
            ),
          );
          return;
        }

        Get.dialog(
          Center(child: CircularProgressIndicator()),
          barrierDismissible: false,
        );

        bool success = await authController.login(email, password);
        Get.back();

        if (success) {
          Get.offAllNamed('/home');
        } else {
          AppTheme.GetSnackBarWarning(
            title: 'Đăng nhập thất bại',
            content: 'Không tìm thấy thông tin tài khoản',
          );
        }
      },
      style: ElevatedButton.styleFrom(
        // Màu nền chính
        iconColor: Colors.white, // Màu chữ khi nút được kích hoạt
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)), // Bo tròn góc
        elevation: 3, // Thêm đổ bóng nhẹ
      ),
      child: Text(
        'Đăng nhập',
        style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500), // Chỉnh font chữ và độ dày
      ),
    );
  }
}
