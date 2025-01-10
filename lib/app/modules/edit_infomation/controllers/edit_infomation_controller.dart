import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../themes/snackbar.dart';

class EditInfomationController extends GetxController {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxString displayName = ''.obs;
  RxString dateOfBirth = ''.obs;
  RxString sex = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserInfo();
  }

  Future<void> loadUserInfo() async {
    try {
      final User? user = _firebaseAuth.currentUser;

      if (user != null) {
        // Đồng bộ lại dữ liệu người dùng
        await user.reload();
        final updatedUser = _firebaseAuth.currentUser;

        // Lấy thông tin từ Authentication
        displayName.value = updatedUser?.displayName ?? '';

        // Lấy thông tin bổ sung từ Firestore
        final userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          dateOfBirth.value = userDoc.data()?['dateOfBirth'] ?? '';
          sex.value = userDoc.data()?['sex'] ?? '';
        }
      }
    } catch (e) {
      print('Load User Info Error: $e');
      Get.snackbar(
        'Error',
        'Failed to load user information: $e',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<bool> updateUserInfo(
      String displayName, String dateOfBirth, String sex) async {
    try {
      final User? user = _firebaseAuth.currentUser;

      if (user != null) {
        await user.updateDisplayName(displayName);

        final userDoc = _firestore.collection('users').doc(user.uid);
        await userDoc.update({
          'displayName': displayName,
          'dateOfBirth': dateOfBirth,
          'sex': sex,
        });

        // Cập nhật giá trị trong biến quan sát
        this.displayName.value = displayName;
        this.dateOfBirth.value = dateOfBirth;
        this.sex.value = sex;

        SnackBarCustom.GetSnackBarSuccess(
            title: 'Thành Công', content: 'Cập nhật thông tin thành công');
        Get.offAllNamed('/home');
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Update User Info Error: $e');
      SnackBarCustom.GetSnackBarError(
          title: 'Lỗi', content: 'Cập nhật thông tin thất bại');
      return false;
    }
  }
}
