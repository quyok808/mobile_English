// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onlya_english/app/themes/theme.dart';
import '../../../middleware/auth/controllers/auth_controller.dart';

class ForgotPasswordView extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Quên mật khẩu ?'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Nhập email để nhận link reset password',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String email = emailController.text.trim();
                if (email.isEmpty) {
                  AppTheme.GetSnackBarError(
                      title: 'Lỗi', content: 'Email không được để trống !!!');
                  return;
                }

                Get.dialog(
                  Center(child: CircularProgressIndicator()),
                  barrierDismissible: false,
                );

                bool success =
                    await authController.sendPasswordResetEmail(email);
                Get.back();
                if (success) {
                  AppTheme.GetSnackBarSuccess(
                      title: 'Thành công',
                      content: 'Đã gửi link reset password đến $email');
                  Get.offAllNamed('/login');
                } else {
                  AppTheme.GetSnackBarError(
                      title: 'Lỗi', content: 'Không tìm thấy email !!!');
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
              child: Text('Gửi yêu cầu đặt lại mật khẩu'),
            ),
          ],
        ),
      ),
    );
  }
}
