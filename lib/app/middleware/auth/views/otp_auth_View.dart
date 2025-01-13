// ignore_for_file: file_names, use_key_in_widget_constructors, library_private_types_in_public_api, unnecessary_brace_in_string_interps

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../themes/snackbar.dart';
import '../controllers/auth_controller.dart';

class OTPVerificationView extends StatefulWidget {
  @override
  _OTPVerificationViewState createState() => _OTPVerificationViewState();
}

class _OTPVerificationViewState extends State<OTPVerificationView> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  final int _otpLength = 6;

  int _remainingTime = 60; // Thời gian đếm ngược (giây)
  Timer? _timer;
  bool _isResendAvailable = false; // Nút Resend OTP
  late final String email;

  @override
  void initState() {
    super.initState();
    email = Get.arguments;
    _controllers =
        List.generate(_otpLength, (index) => TextEditingController());
    _focusNodes = List.generate(_otpLength, (index) => FocusNode());
    _startTimer();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _remainingTime = 300;
    _isResendAvailable = false;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer?.cancel();
          _isResendAvailable = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(title: Text('Verify OTP')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Thời gian xác thực: ${_remainingTime} giây'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_otpLength, (index) {
                return Container(
                  width: 50,
                  height: 50,
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    textAlign: TextAlign.center,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                        counterText: '', border: InputBorder.none),
                    onChanged: (value) {
                      if (value.length == 1) {
                        if (index < _otpLength - 1) {
                          _focusNodes[index + 1].requestFocus();
                        } else {
                          _focusNodes[index]
                              .unfocus(); // Unfocus last node on full input
                        }
                      }
                      if (value.isEmpty) {
                        if (index > 0) {
                          _focusNodes[index - 1].requestFocus();
                        }
                      }
                      setState(
                          () {}); // rebuild if needed to disable submit if any OTP field is empty
                    },
                  ),
                );
              }),
            ),
            SizedBox(height: 20),
            if (_isResendAvailable)
              ElevatedButton(
                onPressed: () {
                  _startTimer();
                  authController.reSendOTPEmail(email);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text("Đã gửi lại OTP")));
                },
                child: Text('Resend OTP'),
              )
            else
              ElevatedButton(
                onPressed: _isOTPValid()
                    ? () async {
                        String inputOTP = _controllers
                            .map((controller) => controller.text)
                            .join();

                        bool success =
                            await authController.verifyOTP(email, inputOTP);
                        if (success) {
                          SnackBarCustom.GetSnackBarSuccess(
                              title: 'Thành công',
                              content: 'Xác thực tài khoản thành công !!!');
                          Get.offAllNamed('/login');
                        } else {
                          SnackBarCustom.GetSnackBarError(
                              title: 'Error',
                              content: 'Sai mã OTP. Vui lòng thử lại !!!.');
                        }
                      }
                    : null,
                child: Text('Verify'),
              ),
          ],
        ),
      ),
    );
  }

  bool _isOTPValid() {
    return _controllers.every((controller) => controller.text.isNotEmpty);
  }
}
