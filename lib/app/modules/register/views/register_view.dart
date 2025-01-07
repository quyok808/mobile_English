// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Create an Account',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            CustomTextField(
              controller: displayNameController,
              labelText: 'Tên hiển thị',
              icon: Icons.email,
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
            SizedBox(height: 15),
            CustomTextField(
              controller: confirmPasswordController,
              labelText: 'Confirm Password',
              icon: Icons.lock,
              obscureText: true,
            ),
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
