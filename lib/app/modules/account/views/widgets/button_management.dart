import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onlya_english/app/modules/account/controllers/account_controller.dart';
import 'package:onlya_english/app/modules/account/views/widgets/change-pass-button.dart';
import 'package:onlya_english/app/themes/theme.dart';

import 'CustomText.dart';
import 'louout_button.dart';
import 'update-info-button.dart';
import 'user-info-row.dart';

class ListManagement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AccountController _controller = Get.put(AccountController());

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: RefreshIndicator(
        onRefresh: _controller.loadUserInfo, // Gọi phương thức tải lại dữ liệu
        child: Obx(() {
          // Dữ liệu user từ controller
          final user = _controller.userInfo.value;

          return ListView(
            children: [
              UpdateInfomationButton(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: AppTheme.light_blue,
                      child: const Icon(Icons.email_outlined, size: 30),
                    ),
                    const SizedBox(width: 10),
                    Customtext(
                      NoiDung: user?.email ?? "Email chưa được cung cấp",
                    ),
                  ],
                ),
              ),
              UserInfoRow(
                icon: Icons.cake_outlined,
                label: 'Ngày sinh',
                content: user?.dateOfBirth ?? "Chưa có thông tin",
              ),
              UserInfoRow(
                icon: Icons.male_outlined,
                label: 'Giới tính',
                content: user?.sex ?? "Chưa có thông tin",
              ),
              SizedBox(height: 20),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [Spacer(), ChangePassButton(), Spacer()],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [Spacer(), LogoutButton(), Spacer()],
              ),
            ],
          );
        }),
      ),
    );
  }
}
