import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onlya_english/app/modules/account/controllers/account_controller.dart';
import '../../../themes/snackbar.dart';
import '../../login/views/widgets/custom_text_field.dart';

class ChangePassView extends StatelessWidget {
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final RxBool isLoading = false.obs;

  ChangePassView({super.key});

  @override
  Widget build(BuildContext context) {
    final AccountController _auth = Get.find<AccountController>();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          'Thay đổi mật khẩu',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg-changepass.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Card(
                color: Colors.white.withOpacity(0.9),
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Obx(() {
                        return CustomTextField(
                          controller: currentPasswordController,
                          labelText: 'Nhập mật khẩu hiện tại',
                          prefixIcon: Icons.lock,
                          suffixIcon_Password: true,
                          obscureText: !_auth.isCurrentPasswordVisible.value,
                          toggleVisibility:
                              _auth.toggleCurrentPasswordVisibility,
                          isPasswordVisible: _auth.isCurrentPasswordVisible,
                        );
                      }),
                      SizedBox(height: 30),
                      Obx(() {
                        return CustomTextField(
                          controller: newPasswordController,
                          labelText: 'Nhập mật khẩu mới',
                          prefixIcon: Icons.lock,
                          suffixIcon_Password: true,
                          obscureText: !_auth.isPasswordVisible.value,
                          toggleVisibility: _auth.togglePasswordVisibility,
                          isPasswordVisible: _auth.isPasswordVisible,
                        );
                      }),
                      SizedBox(height: 30),
                      Obx(() {
                        return CustomTextField(
                          controller: confirmPasswordController,
                          labelText: 'Xác nhận mật khẩu mới',
                          prefixIcon: Icons.lock,
                          suffixIcon_Password: false,
                          obscureText: !_auth.isPasswordVisible.value,
                          toggleVisibility: _auth.togglePasswordVisibility,
                          isPasswordVisible: _auth.isPasswordVisible,
                        );
                      }),
                      SizedBox(height: 30),
                      Obx(
                        () => isLoading.value
                            ? Center(child: CircularProgressIndicator())
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 75),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    // Lấy giá trị từ các trường nhập liệu
                                    String currentPassword =
                                        currentPasswordController.text.trim();
                                    String newPassword =
                                        newPasswordController.text.trim();
                                    String confirmPassword =
                                        confirmPasswordController.text.trim();

                                    // Kiểm tra thông tin nhập vào
                                    if (currentPassword.isEmpty ||
                                        newPassword.isEmpty ||
                                        confirmPassword.isEmpty) {
                                      SnackBarCustom.GetSnackBarWarning(
                                          title: 'Cảnh báo',
                                          content:
                                              'Thông tin không được để trống');
                                      return;
                                    }

                                    if (newPassword != confirmPassword) {
                                      SnackBarCustom.GetSnackBarWarning(
                                          title: 'Cảnh báo',
                                          content:
                                              'Mật khẩu mới và xác nhận mật khẩu không khớp.');
                                      return;
                                    }

                                    isLoading.value = true;
                                    try {
                                      final authController =
                                          Get.find<AccountController>();
                                      bool success =
                                          await authController.changePassword(
                                        currentPassword,
                                        newPassword,
                                      );

                                      if (success) {
                                        Get.toNamed('/login');
                                        currentPasswordController.clear();
                                        newPasswordController.clear();
                                        confirmPasswordController.clear();
                                      }
                                    } catch (e) {
                                      SnackBarCustom.GetSnackBarError(
                                          title: 'Lỗi',
                                          content: 'Xảy ra rỗi !!!');
                                    } finally {
                                      isLoading.value = false;
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            10)), // Bo tròn góc
                                    elevation: 3,
                                    backgroundColor: Colors.yellow,
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Đổi mật khẩu',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
