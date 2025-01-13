import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../../models/CustomUser.dart';
import '../../../themes/snackbar.dart';

class AccountController extends GetxController {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Rx<User?> currentUser = Rx<User?>(null);
  Rx<CustomUser?> userInfo = Rx<CustomUser?>(null); // Dữ liệu người dùng

  @override
  void onInit() {
    super.onInit();
    _loadUserInfo(); // Tải thông tin người dùng khi controller khởi tạo
    currentUser.bindStream(_firebaseAuth.authStateChanges());
  }

  String? get displayName => currentUser.value?.displayName;

  Future<void> loadUserInfo() async {
    final User? currentUser = _firebaseAuth.currentUser;
    if (currentUser != null) {
      final docRef = _firestore.collection('users').doc(currentUser.uid);
      final snapshot = await docRef.get();

      if (snapshot.exists) {
        userInfo.value = CustomUser.fromMap(snapshot.data()!, currentUser.uid);
      }
    }
  }

  void _loadUserInfo() async {
    try {
      print("Đang tải thông tin người dùng...");
      final User? currentUser = _firebaseAuth.currentUser;

      if (currentUser == null) {
        print("Người dùng chưa đăng nhập!");
        return;
      }

      print("UID của người dùng: ${currentUser.uid}");
      final docRef = _firestore.collection('users').doc(currentUser.uid);
      final snapshot = await docRef.get();

      if (snapshot.exists) {
        print("Dữ liệu Firestore: ${snapshot.data()}");
        userInfo.value = CustomUser.fromMap(snapshot.data()!, currentUser.uid);
      } else {
        print("Không tìm thấy tài liệu cho uid: ${currentUser.uid}");
      }
    } catch (e) {
      print("Lỗi khi tải thông tin người dùng: $e");
    }
  }

  // Đổi mật khẩu
  Future<bool> changePassword(
      String currentPassword, String newPassword) async {
    try {
      final User? user = _firebaseAuth.currentUser;
      if (user == null) {
        throw Exception('Người dùng chưa đăng nhập');
      }

      // Xác thực lại người dùng bằng mật khẩu hiện tại
      final AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);

      // Cập nhật mật khẩu mới
      await user.updatePassword(newPassword);

      SnackBarCustom.GetSnackBarSuccess(
          title: 'Thành Công',
          content: 'Mật khẩu đã được thay đổi thành công !!');

      return true;
    } catch (e) {
      print('Change Password Error: $e');
      SnackBarCustom.GetSnackBarError(
          title: 'Lỗi', content: 'Không thay đổi được mật khẩu');
      return false;
    }
  }

  RxBool isPasswordVisible = false.obs;
  RxBool isCurrentPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleCurrentPasswordVisibility() {
    isCurrentPasswordVisible.value = !isCurrentPasswordVisible.value;
  }
}
