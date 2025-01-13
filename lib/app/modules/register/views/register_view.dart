// ignore_for_file: prefer_const_constructors, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../middleware/auth/controllers/auth_controller.dart';
import '../../../themes/theme.dart';
import '../../login/views/widgets/custom_text_field.dart';
import 'widgets/register_button.dart';

class RegisterView extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController displayNameController = TextEditingController();

  RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController _auth = Get.find<AuthController>();
    return Scaffold(
      body: Stack(
        children: [
          // Hình nền
          Positioned.fill(
            child: Image.asset(
              'assets/images/login_screen.png', // Đường dẫn tới ảnh nền
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Transform.translate(
              offset: Offset(
                0, // Không di chuyển theo chiều ngang
                100, // Di chuyển lên tối đa 100px
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  color: Colors.white,
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Hãy tạo tài khoản để cùng tham gia luyện tiếng anh nhé !',
                          style: AppTheme.lobsterFont,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        CustomTextField(
                          controller: displayNameController,
                          labelText: 'Tên hiển thị',
                          prefixIcon: Icons.account_box,
                          suffixIcon_Password: false,
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
                        SizedBox(height: 15),
                        Obx(() {
                          return CustomTextField(
                            controller: confirmPasswordController,
                            labelText: 'Confirm Password',
                            prefixIcon: Icons.lock,
                            suffixIcon_Password: false,
                            obscureText: !_auth.isPasswordVisible.value,
                            toggleVisibility: _auth.togglePasswordVisibility,
                            isPasswordVisible: _auth.isPasswordVisible,
                          );
                        }),
                        SizedBox(height: 20),
                        RegisterButton(
                          emailController: emailController,
                          passwordController: passwordController,
                          confirmPasswordController: confirmPasswordController,
                          displayNameController: displayNameController,
                        ),
                        TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Row(
                            children: [
                              Text(
                                'Bạn đã có tài khoản? ',
                                style: TextStyle(
                                  color: AppTheme.purple,
                                ),
                              ),
                              Text(
                                'Đăng nhập và cùng học nhé!',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  decorationThickness: 2.0,
                                  color: AppTheme.purple,
                                  decorationColor: AppTheme.purple,
                                ),
                              ),
                            ],
                          ),
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
