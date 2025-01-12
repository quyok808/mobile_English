import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:onlya_english/app/themes/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../themes/snackbar.dart';

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

      final email = googleUser.email;

      // Đăng nhập bằng credential Google
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      final User? firebaseUser = userCredential.user;

      // Kiểm tra xem tài khoản đã tồn tại trong Firestore và có phương thức đăng nhập không phải Google không
      if (firebaseUser != null) {
        // Kiểm tra nếu tài khoản đã đăng nhập qua email/password
        final providerData = firebaseUser.providerData;

        bool isEmailPassword =
            providerData.any((userInfo) => userInfo.providerId == 'password');

        if (isEmailPassword) {
          // Nếu đã đăng nhập bằng email/password, thông báo lỗi và không cho phép đăng nhập qua Google
          SnackBarCustom.GetSnackBarError(
            title: 'Lỗi',
            content:
                'Email này đã được đăng ký bằng phương thức email/password. Không thể đăng nhập bằng Google.',
          );
          return;
        }

        // Tiến hành tạo tài khoản nếu chưa đăng ký và lưu thông tin vào Firestore
        await _firestore.collection('users').doc(firebaseUser.uid).set({
          'displayName': firebaseUser.displayName ?? '',
          'email': firebaseUser.email,
          'dateOfBirth': '01/01/0001',
          'sex': 'Khác',
          'SignInMethod': 'Google', // Lưu phương thức đăng nhập
        });

        user.value = firebaseUser;

        setGoogleLogin(true);
      }
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
