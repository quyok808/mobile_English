// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onlya_english/app/modules/auth/controllers/auth_controller.dart';

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
            'Error',
            'Email and Password cannot be empty',
            snackPosition: SnackPosition.BOTTOM,
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
          Get.snackbar(
            'Login Failed',
            'Invalid email or password',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
      ),
      child: Text(
        'Login',
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
