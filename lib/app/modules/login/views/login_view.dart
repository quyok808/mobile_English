// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onlya_english/app/middleware/auth/controllers/auth_controller.dart';
import '../../../themes/theme.dart';
import 'widgets/custom_text_field.dart';
import 'widgets/login_button.dart';

class LoginView extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    // Lấy chiều cao bàn phím
    final AuthController _auth = Get.find<AuthController>();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Hình nền
          Positioned.fill(
            child: Image.asset(
              'assets/images/login_screen.png', // Đường dẫn tới ảnh nền
              fit: BoxFit.cover,
            ),
          ),
          // Card hiển thị nội dung
          Center(
            child: Transform.translate(
              offset: Offset(
                0, // Không di chuyển theo chiều ngang
                125, // Di chuyển lên tối đa 100px
              ),
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Xin chào, hãy đăng nhập để cùng luyện tiếng anh nhé!',
                          style: AppTheme.lobsterFont,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        CustomTextField(
                          controller: emailController,
                          labelText: 'Email',
                          prefixIcon: Icons.email,
                          suffixIcon_Password: false,
                        ),
                        SizedBox(height: 15),
                        Obx(() {
                          return CustomTextField(
                            controller: passwordController,
                            labelText: 'Password',
                            prefixIcon: Icons.lock,
                            suffixIcon_Password: true,
                            obscureText: !_auth.isPasswordVisible.value,
                            toggleVisibility: _auth.togglePasswordVisibility,
                            isPasswordVisible: _auth.isPasswordVisible,
                          );
                        }),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Get.toNamed('/forgot-password');
                              },
                              child: Text('Quên mật khẩu?'),
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
                          child: Text(
                              'Bạn không có tài khoản? Đăng kí ngay tại đây nhé!'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
