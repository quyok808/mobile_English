import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onlya_english/app/modules/account/controllers/account_controller.dart';
import 'package:onlya_english/app/themes/theme.dart';

import '../../../../middleware/auth/controllers/auth_controller.dart';

class ChangePassButton extends StatelessWidget {
  const ChangePassButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        Get.toNamed('/change-pass');
      },
      style: ElevatedButton.styleFrom(
        // Màu nền chính
        backgroundColor: AppTheme.light_blue,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15)), // Bo tròn góc
        elevation: 3, // Thêm đổ bóng nhẹ
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.center, // Để căn giữa cả icon và text
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons
                .admin_panel_settings_outlined, // Chọn icon đăng xuất phù hợp, bạn có thể thay bằng icon khác
            color: Colors.black, // Màu icon
          ),
          SizedBox(width: 8), // Khoảng cách giữa icon và text
          Text(
            'Thay đổi mật khẩu',
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
