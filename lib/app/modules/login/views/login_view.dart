// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onlya_english/app/modules/login/views/reset_password_view.dart';
import '../../../themes/theme.dart';
import 'widgets/custom_text_field.dart';
import 'widgets/login_button.dart';

class LoginView extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Xin chào, hãy đăng nhập để cùng luyện tiếng anh nhé !',
              style: AppTheme.lobsterFont,
            ),
            SizedBox(height: 20),
            CustomTextField(
              controller: emailController,
              labelText: 'Email',
              icon: Icons.email,
            ),
            SizedBox(height: 15),
            CustomTextField(
              controller: passwordController,
              labelText: 'Password',
              icon: Icons.lock,
              obscureText: true,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Get.toNamed('/forgot-password');
                  },
                  child: Text(
                    'Quên mật khẩu?',
                  ),
                ),
              ],
            ),
            LoginButton(
              emailController: emailController,
              passwordController: passwordController,
            ),
            SizedBox(height: 15),
            TextButton(
              onPressed: () {
                Get.toNamed('/register');
              },
              child: Text('Bạn không có tài khoản? Đăng kí ngay tại đây nhé!'),
            ),
          ],
        ),
      ),
    );
  }
}
