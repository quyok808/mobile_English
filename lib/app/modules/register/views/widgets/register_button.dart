// ignore_for_file: prefer_const_constructors, use_super_parameters

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onlya_english/app/middleware/auth/controllers/auth_controller.dart';
import '../../../../themes/snackbar.dart';

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
          SnackBarCustom.GetSnackBarWarning(
              title: 'Thông báo!', content: 'Bạn phải điền đầy đủ thông tin');
          return;
        }

        if (password != confirmPassword) {
          SnackBarCustom.GetSnackBarWarning(
              title: 'Thông báo!',
              content: 'Xác nhận mật khẩu không trùng khớp.');
          return;
        }

        // Kiểm tra mật khẩu có đủ yêu cầu chưa
        if (password.length < 6) {
          SnackBarCustom.GetSnackBarWarning(
              title: 'Thông báo!',
              content: 'Mật khẩu phải có ít nhất 6 kí tự ');
          return;
        }
        if (!password.contains(RegExp(r'[a-z]'))) {
          SnackBarCustom.GetSnackBarWarning(
              title: 'Thông báo!',
              content: 'Mật khẩu phải có ít nhất 1 kí tự viết thường');
          return;
        }
        if (!password.contains(RegExp(r'[A-Z]'))) {
          SnackBarCustom.GetSnackBarWarning(
              title: 'Thông báo!',
              content: 'Mật khẩu phải có ít nhất 1 kí tự viết hoa');
          return;
        }
        if (!password.contains(RegExp(r'[0-9]'))) {
          SnackBarCustom.GetSnackBarWarning(
              title: 'Thông báo!',
              content: 'Mật khẩu phải có ít nhất 1 kí tự số');
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
        } else {
          SnackBarCustom.GetSnackBarWarning(
              title: 'Thông báo!',
              content: 'Email đã đăng kí. Vui lòng đăng kí với email khác');
          return;
        }
      },
      style: ElevatedButton.styleFrom(
        // Màu nền chính
        backgroundColor: Colors.blue[400],
        iconColor: Colors.white, // Màu chữ khi nút được kích hoạt
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)), // Bo tròn góc
        elevation: 3, // Thêm đổ bóng nhẹ
      ),
      child: Text(
        'Đăng kí',
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }
}
