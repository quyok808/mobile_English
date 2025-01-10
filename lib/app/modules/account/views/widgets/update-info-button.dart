import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateInfomationButton extends StatelessWidget {
  const UpdateInfomationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        Get.toNamed('/edit-info');
      },
      style: ElevatedButton.styleFrom(
        // Màu nền chính

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
                .perm_identity_outlined, // Chọn icon đăng xuất phù hợp, bạn có thể thay bằng icon khác
            color: Colors.black, // Màu icon
          ),
          SizedBox(width: 8), // Khoảng cách giữa icon và text
          Text(
            'Cập nhật thông tin',
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
