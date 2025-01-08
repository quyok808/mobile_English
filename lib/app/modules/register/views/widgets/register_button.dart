// ignore_for_file: prefer_const_constructors, use_super_parameters

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onlya_english/app/modules/auth/controllers/auth_controller.dart';
import 'package:onlya_english/app/themes/theme.dart';

class RegisterButton extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController displayNameController;

  const RegisterButton({
    Key? key,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.displayNameController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return ElevatedButton(
      onPressed: () async {
        String email = emailController.text.trim();
        String password = passwordController.text.trim();
        String confirmPassword = confirmPasswordController.text.trim();
        String displayName = displayNameController.text.trim();

        if (email.isEmpty ||
            password.isEmpty ||
            confirmPassword.isEmpty ||
            displayName.isEmpty) {
          Get.snackbar(
            'Lỗi',
            'Cần phải điền đầy đủ thông tin !!!',
            snackPosition: SnackPosition.TOP,
          );
          return;
        }

        if (password != confirmPassword) {
          Get.snackbar(
            'Lỗi',
            'Xác nhận mật khẩu không trùng khớp với mật khẩu',
            snackPosition: SnackPosition.TOP,
          );
          return;
        }

        Get.dialog(
          Center(child: CircularProgressIndicator()),
          barrierDismissible: false,
        );

        bool success =
            await authController.register(email, password, displayName);
        Get.back();

        if (success) {
          Get.toNamed('/otp-verification', arguments: email);
          // Get.offAllNamed('/login'); // Chuyển về màn hình Login
        } else {
          AppTheme.GetSnackBarError(
              title: 'Lỗi', content: 'Đăng kí thất bại !!!');
        }
      },
      style: ElevatedButton.styleFrom(
        // Màu nền chính
        iconColor: Colors.white, // Màu chữ khi nút được kích hoạt
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)), // Bo tròn góc
        elevation: 3, // Thêm đổ bóng nhẹ
      ),
      child: Text(
        'Đăng kí',
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
