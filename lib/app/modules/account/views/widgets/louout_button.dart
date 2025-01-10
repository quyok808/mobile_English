import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../middleware/auth/controllers/auth_controller.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    return ElevatedButton(
      onPressed: () async {
        // Gọi phương thức đăng xuất
        await authController.logout();
        // Chuyển hướng về LoginView sau khi đăng xuất
        Get.offAllNamed('/login');
      },
      style: ElevatedButton.styleFrom(
        // Màu nền chính
        backgroundColor: Colors.red[400],
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
                .logout, // Chọn icon đăng xuất phù hợp, bạn có thể thay bằng icon khác
            color: Colors.white, // Màu icon
          ),
          SizedBox(width: 8), // Khoảng cách giữa icon và text
          Text(
            'Đăng xuất',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
