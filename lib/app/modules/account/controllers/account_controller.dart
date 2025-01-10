import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../../models/CustomUser.dart';

class AccountController extends GetxController {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Rx<CustomUser?> userInfo = Rx<CustomUser?>(null); // Dữ liệu người dùng

  @override
  void onInit() {
    super.onInit();
    _loadUserInfo(); // Tải thông tin người dùng khi controller khởi tạo
  }

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
}
