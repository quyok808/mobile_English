// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onlya_english/app/modules/account/views/widgets/louout_button.dart';
import 'package:onlya_english/app/modules/auth/controllers/auth_controller.dart';

class AccountView extends StatelessWidget {
  AccountView({super.key});

  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() {
              String displayName = authController.displayName ?? 'User';
              return Text(
                'Welcome, $displayName!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              );
            }),
            SizedBox(height: 10),
            Center(
              // Đơn giản hơn Align trong trường hợp căn giữa
              child: LogoutButton(),
            ),
          ],
        ),
      ),
    );
  }
}
