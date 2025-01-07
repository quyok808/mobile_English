import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

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

  String? get displayName => currentUser.value?.displayName; // Lấy tên hiển thị

  Future<bool> register(
      String email, String password, String displayName) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        await userCredential.user!.updateDisplayName(displayName);
        await userCredential.user!.reload();
        currentUser.value =
            _firebaseAuth.currentUser; // Cập nhật thông tin người dùng
      }

      return true;
    } catch (e) {
      print('Registration Error: $e');
      return false;
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

  // Phương thức đăng xuất
  Future<void> logout() async {
    try {
      // Đăng xuất khỏi Firebase
      await _firebaseAuth.signOut();

      // Xóa thông tin đăng nhập từ SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('email');
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred while logging out: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
