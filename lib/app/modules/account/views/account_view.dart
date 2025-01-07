// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onlya_english/app/modules/auth/controllers/auth_controller.dart';

class AccountView extends StatelessWidget {
  AccountView({super.key});

  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(() {
          String displayName = authController.displayName ?? 'User';
          return Text(
            'Welcome, $displayName!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          );
        }),
      ),
    );
  }
}
