// ignore_for_file: prefer_const_constructors, use_super_parameters

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onlya_english/app/modules/auth/controllers/auth_controller.dart';

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

        bool success =
            await authController.register(email, password, displayName);
        if (success) {
          Get.snackbar(
            'Thành Công',
            'Đăng kí tài khoản thành công.',
            snackPosition: SnackPosition.TOP,
          );
          Get.offAllNamed('/login'); // Chuyển về màn hình Login
        } else {
          Get.snackbar(
            'Lỗi',
            'Đăng kí thất bại.',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
      ),
      child: Text(
        'Đăng kí',
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
