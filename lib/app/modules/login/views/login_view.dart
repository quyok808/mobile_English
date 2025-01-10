// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onlya_english/app/middleware/auth/controllers/auth_controller.dart';
import 'package:onlya_english/app/modules/login/controllers/login_controller.dart';
import '../../../themes/theme.dart';
import 'widgets/custom_text_field.dart';
import 'widgets/login_button.dart';

class LoginView extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    // Lấy chiều cao bàn phím
    final AuthController _auth = Get.find<AuthController>();
    final LoginController _controller = Get.put(LoginController());
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Hình nền
          Positioned.fill(
            child: Image.asset(
              'assets/images/login_screen.png', // Đường dẫn tới ảnh nền
              fit: BoxFit.cover,
            ),
          ),
          // Card hiển thị nội dung
          Center(
            child: Transform.translate(
              offset: Offset(
                0, // Không di chuyển theo chiều ngang
                125, // Di chuyển lên tối đa 100px
              ),
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Xin chào, hãy đăng nhập để cùng luyện tiếng anh nhé!',
                          style: AppTheme.lobsterFont,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        CustomTextField(
                          controller: emailController,
                          labelText: 'Email',
                          prefixIcon: Icons.email,
                          suffixIcon_Password: false,
                        ),
                        SizedBox(height: 15),
                        Obx(() {
                          return CustomTextField(
                            controller: passwordController,
                            labelText: 'Password',
                            prefixIcon: Icons.lock,
                            suffixIcon_Password: true,
                            obscureText: !_auth.isPasswordVisible.value,
                            toggleVisibility: _auth.togglePasswordVisibility,
                            isPasswordVisible: _auth.isPasswordVisible,
                          );
                        }),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Get.toNamed('/forgot-password');
                              },
                              child: Text('Quên mật khẩu?'),
                            ),
                          ],
                        ),
                        Center(
                          child: Row(
                            children: [
                              Obx(() {
                                // Theo dõi trạng thái của user
                                if (_controller.user.value != null) {
                                  // Nếu đã có user, chuyển hướng đến màn hình Home
                                  Future.microtask(() => Get.offAllNamed(
                                      '/home')); // Đảm bảo chuyển trang ngay khi có user
                                  return Container(); // Ẩn nút Google Sign-In khi đã có user
                                }

                                // Nếu chưa có user, hiển thị nút đăng nhập với Google
                                return ElevatedButton(
                                  onPressed: _controller.signInWithGoogle,
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      // Tạo viền bo tròn
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 3),
                                  ),
                                  child: Image.network(
                                      'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/640px-Google_%22G%22_logo.svg.png',
                                      width: 110,
                                      height: 40),
                                );
                              }),
                              SizedBox(width: 10),
                              Spacer(),
                              LoginButton(
                                emailController: emailController,
                                passwordController: passwordController,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15),
                        TextButton(
                          onPressed: () {
                            Get.toNamed('/register');
                          },
                          child: Text(
                              'Bạn không có tài khoản? Đăng kí ngay tại đây nhé!'),
                        ),
                      ],
                    ),
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
