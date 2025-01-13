import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onlya_english/app/modules/account/controllers/account_controller.dart';
import 'package:onlya_english/app/themes/theme.dart';

class InfomationWidget extends StatelessWidget {
  const InfomationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final AccountController _controller = Get.put(AccountController());
    return Center(
      child: Column(
        children: [
          SizedBox(height: 30),
          CircleAvatar(
            radius: 40,
            backgroundColor: AppTheme.light_blue,
            child: Image.asset(
              'assets/images/unknown_avt.png',
              fit: BoxFit.contain,
              width: 45,
              height: 45,
            ),
          ),
          SizedBox(height: 10),
          Obx(() {
            String displayName = _controller.displayName ?? "USER";
            return Text(
              displayName,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            );
          }),
        ],
      ),
    );
  }
}
