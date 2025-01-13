// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_super_parameters

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onlya_english/app/middleware/auth/controllers/auth_controller.dart';
import 'package:onlya_english/app/themes/theme.dart';

import '../../../../themes/snackbar.dart';

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
          SnackBarCustom.GetSnackBarWarning(
            title: 'Đăng nhập thất bại',
            content: 'Sai thông tin tài khoản hoặc mật khẩu',
          );
        }
      },
      style: ElevatedButton.styleFrom(
        // Màu nền chính
        backgroundColor: Color(0xFF4bafee),
        iconColor: Colors.blue, // Màu chữ khi nút được kích hoạt
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)), // Bo tròn góc
        elevation: 3, // Thêm đổ bóng nhẹ
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Image.asset(
          'assets/images/login-btn.gif',
          fit: BoxFit.cover,
          width: 100,
          height: 23,
        ),
      ),
    );
  }
}
