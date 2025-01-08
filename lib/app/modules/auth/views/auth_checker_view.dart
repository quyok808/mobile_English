// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../home/views/home_view.dart';
import '../../login/views/login_view.dart';
import '../controllers/auth_controller.dart';

class AuthCheckerView extends StatelessWidget {
  final AuthController _authController = Get.find<AuthController>();

  AuthCheckerView({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _authController.getLoggedIUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData && snapshot.data != null) {
          return HomeView(); // Người dùng đã đăng nhập
        } else {
          return LoginView(); // Người dùng chưa đăng nhập
        }
      },
    );
  }
}
