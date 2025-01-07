// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onlya_english/app/modules/auth/controllers/auth_controller.dart';

class RegisterButton extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const RegisterButton({
    Key? key,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return ElevatedButton(
      onPressed: () async {
        String email = emailController.text.trim();
        String password = passwordController.text.trim();
        String confirmPassword = confirmPasswordController.text.trim();

        if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
          Get.snackbar(
            'Error',
            'All fields are required',
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }

        if (password != confirmPassword) {
          Get.snackbar(
            'Error',
            'Passwords do not match',
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }

        bool success = await authController.register(email, password);
        if (success) {
          Get.snackbar(
            'Success',
            'Account created successfully! Please login.',
            snackPosition: SnackPosition.BOTTOM,
          );
          Get.offAllNamed('/login'); // Chuyển về màn hình Login
        } else {
          Get.snackbar(
            'Error',
            'Registration failed',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
      ),
      child: Text(
        'Register',
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
