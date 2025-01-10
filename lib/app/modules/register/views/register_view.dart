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
      appBar: AppBar(
        backgroundColor: AppTheme.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Hãy tạo tài khoản để cùng tham gia luyện tiếng anh nhé !',
              style: AppTheme.lobsterFont,
            ),
            SizedBox(height: 20),
            CustomTextField(
              controller: displayNameController,
              labelText: 'Tên hiển thị',
              prefixIcon: Icons.email,
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
                controller: passwordController,
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
          ],
        ),
      ),
    );
  }
}
