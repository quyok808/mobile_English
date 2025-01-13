import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Reactive variables
  final Rx<User?> user = Rx<User?>(null);
  final RxString dateOfBirth = ''.obs;
  final RxString sex = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Listen to user changes
    _googleSignIn.onCurrentUserChanged.listen((account) {
      user.value = account != null ? _auth.currentUser : null;
    });
    _googleSignIn.signInSilently();
  }

  Future<void> signInWithGoogle() async {
    try {
      await _googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return; // Người dùng hủy đăng nhập.
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Kiểm tra xem email của người dùng có tồn tại trong Firestore không
      final email = googleUser.email;
      final userDoc = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (userDoc.docs.isEmpty) {
        // Nếu email đã tồn tại trong Firestore, thông báo lỗi và không cho đăng nhập qua Google
        // Tiến hành đăng nhập nếu email chưa tồn tại
        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        user.value = userCredential.user;

        // Tạo người dùng mới trong Firestore nếu email chưa có
        if (user.value != null) {
          await _firestore.collection('users').doc(user.value?.uid).set({
            'displayName': user.value?.displayName,
            'email': user.value?.email,
            'dateOfBirth': '01/01/0001',
            'sex': 'Khác',
          });
        }
      }

      setGoogleLogin(true);
    } catch (error) {
      Get.snackbar('Error', 'Failed to sign in: $error');
    }
  }

  var isGoogleLogin = false.obs;

  // Lưu trạng thái đăng nhập Google vào SharedPreferences
  void setGoogleLogin(bool isGoogle) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isGoogleLogin', isGoogle);
    isGoogleLogin.value = isGoogle;
  }
}
