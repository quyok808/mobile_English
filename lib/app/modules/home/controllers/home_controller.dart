import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../../middleware/auth/controllers/auth_controller.dart';

class HomeController extends GetxController {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Trạng thái người dùng hiện tại
  Rx<User?> currentUser = Rx<User?>(null);

  // Dùng RxString để quản lý displayName
  RxString displayName = 'User'.obs;

  @override
  void onInit() {
    super.onInit();
    // Theo dõi trạng thái người dùng
    currentUser.bindStream(_firebaseAuth.authStateChanges());
    // Cập nhật displayName khi currentUser thay đổi
    ever(currentUser, (_) {
      displayName.value = currentUser.value?.displayName ?? 'User';
    });
  }

  // Reference to AuthController to fetch the displayName
  final AuthController authController = Get.find<AuthController>();

  // Method to refresh displayName and other data
  Future<void> refreshData() async {
    // Refresh the displayName from AuthController or any other data source
    await Future.delayed(
        Duration(seconds: 2)); // Simulate delay for data refresh
    update(); // Update all dependent widgets
  }
}
