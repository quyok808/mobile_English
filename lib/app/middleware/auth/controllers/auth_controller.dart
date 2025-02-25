// ignore_for_file: avoid_print, deprecated_member_use, unnecessary_null_comparison

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../themes/snackbar.dart';

class AuthController extends GetxController {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Trạng thái người dùng hiện tại
  Rx<User?> currentUser = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    // Theo dõi trạng thái người dùng
    currentUser.bindStream(_firebaseAuth.authStateChanges());
  }

  Future<User?> getLoggedIUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? email =
        prefs.getString('email'); // Lấy email đã lưu trong SharedPreferences
    if (email != null) {
      // Nếu có email trong SharedPreferences, trả về thông tin người dùng
      return _firebaseAuth.currentUser;
    }
    return null;
  }

  bool hasUser({required String email}) {
    Future<List<String>> userCredential =
        _firebaseAuth.fetchSignInMethodsForEmail(email);
    if (userCredential != null) return true;
    return false;
  }

  String? get displayName => currentUser.value?.displayName; // Lấy tên hiển thị

  Future<bool> register(
      String email, String password, String displayName) async {
    try {
      // Kiểm tra email đã tồn tại chưa
      final existingUser =
          await _firebaseAuth.fetchSignInMethodsForEmail(email);
      if (existingUser.isNotEmpty) {
        Get.snackbar(
          'Email Already In Use',
          'The email address is already in use by another account. Please try logging in or use a different email.',
          snackPosition: SnackPosition.TOP,
        );
        return false; // Email đã tồn tại, không thể đăng ký
      }
      // Thực hiện đăng ký với Firebase
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // In ra trạng thái sau khi tạo tài khoản
      print('User created: ${userCredential.user?.email}');

      await saveAdditionalUserInfo("01/01/0001", "Khác");

      if (userCredential.user != null) {
        // Cập nhật display name
        await userCredential.user!.updateDisplayName(displayName);

        // Tạo OTP
        String otp = generateOTP();
        await saveOTP(email, otp);

        // Gửi OTP qua email
        await sendOTPEmail(email, otp);

        // Đăng xuất để chờ xác nhận OTP
        await _firebaseAuth.signOut();

        SnackBarCustom.GetSnackBarSuccess(
            title: 'Verify Email', content: 'Đã gửi OTP đến email $email.');

        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> verifyOTP(String email, String inputOTP) async {
    try {
      DocumentSnapshot otpDoc =
          await _firestore.collection('otps').doc(email).get();

      if (otpDoc.exists && otpDoc['otp'] == inputOTP) {
        await _firestore
            .collection('otps')
            .doc(email)
            .delete(); // Xoá OTP sau khi xác minh
        return true;
      }
      return false;
    } catch (e) {
      print('OTP Verification Error: $e');
      return false;
    }
  }

  // Tạo mã OTP ngẫu nhiên
  String generateOTP() {
    Random random = Random();
    return (100000 + random.nextInt(900000)).toString(); // 6 chữ số
  }

  // Lưu OTP vào Firestore
  Future<void> saveOTP(String email, String otp) async {
    await _firestore.collection('otps').doc(email).set({'otp': otp});
  }

  // Gửi OTP qua email
  Future<void> sendOTPEmail(String email, String otp) async {
    String username = 'quyok8080@gmail.com'; // Địa chỉ email của bạn
    String password = 'uaab ylsf uikl mnnd'; // Mật khẩu email

    final smtpServer =
        gmail(username, password); // Hoặc cấu hình SMTP của riêng bạn
    final message = Message()
      ..from = Address(username, 'OnlyA English')
      ..recipients.add(email)
      ..subject = 'Your OTP Code'
      ..text = 'Your OTP code is: $otp';

    try {
      final sendReport = await send(message, smtpServer);
      print('OTP Sent: ${sendReport.toString()}');
    } catch (e) {
      print('OTP Send Error: $e');
    }
  }

  // Gửi OTP qua email
  Future<void> reSendOTPEmail(String email) async {
    //Xoá otp trước đã lưu
    DocumentSnapshot otpDoc =
        await _firestore.collection('otps').doc(email).get();

    if (otpDoc.exists) {
      await _firestore
          .collection('otps')
          .doc(email)
          .delete(); // Xoá OTP sau khi xác minh
    }
    //Tạo otp mới
    String otp = generateOTP();
    saveOTP(email, otp);
    //Gửi email
    sendOTPEmail(email, otp);
  }

  // Gửi email khôi phục mật khẩu
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      // Gửi email khôi phục mật khẩu
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return true; // Email gửi thành công
    } catch (e) {
      print('Password Reset Error: $e');
      return false; // Gửi email thất bại
    }
  }

  Future<void> saveAdditionalUserInfo(String dateOfBirth, String sex) async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(user.uid);

      await userDoc.set({
        'email': user.email,
        'dateOfBirth': dateOfBirth,
        'sex': sex,
      });
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Kiểm tra xem đăng nhập có thành công không
      if (userCredential.user != null) {
        // Lưu thông tin đăng nhập (email) vào SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', email); // Lưu email của người dùng

        return true;
      }
      return false;
    } catch (e) {
      print('Login Error: $e');
      return false;
    }
  }

  RxBool isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Phương thức đăng xuất
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      bool isGoogleLogin =
          prefs.getBool('isGoogleLogin') ?? false; // Kiểm tra isGoogleLogin

      if (isGoogleLogin) {
        // Nếu đã đăng nhập bằng Google, thực hiện đăng xuất Google
        await GoogleSignIn().signOut();
        print("Logged out from Google");

        // Cập nhật trạng thái trong SharedPreferences (xóa isGoogleLogin)
        await prefs.remove('isGoogleLogin');
        Get.offAllNamed('/login');
      } else {
        // Đăng xuất khỏi Firebase
        await _firebaseAuth.signOut();

        // Xóa thông tin đăng nhập từ SharedPreferences
        await prefs.remove('email');
        Get.offAllNamed('/login');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred while logging out: $e',
        snackPosition: SnackPosition.TOP,
      );
    }
  }
}
