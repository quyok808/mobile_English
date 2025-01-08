// ignore_for_file: prefer_const_constructors

import 'package:get/get.dart';
import 'package:onlya_english/app/modules/Search/views/search_view.dart';
import 'package:onlya_english/app/modules/account/bindings/account_binding.dart';
import 'package:onlya_english/app/modules/auth/views/otp_auth_View.dart';
import 'package:onlya_english/app/modules/home/bindings/home_bindings.dart';
import '../modules/Search/bindings/search_binding.dart';
import '../modules/account/views/account_view.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/auth_checker_view.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/views/reset_password_view.dart';
import '../modules/login/views/login_view.dart';
import '../modules/register/views/register_view.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.AUTH_CHECKER,
      page: () => AuthCheckerView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.HOME,
      page: () => const HomeView(),
      binding: HomeBindings(),
    ),
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => LoginView(),
    ),
    GetPage(
      name: AppRoutes.REGISTER,
      page: () => RegisterView(),
    ),
    GetPage(
      name: AppRoutes.ACCOUNT,
      page: () => AccountView(),
      binding: AccountBinding(),
    ),
    GetPage(
      name: AppRoutes.OTP_VERIFY,
      page: () => OTPVerificationView(),
    ),
    GetPage(
      name: AppRoutes.FORGOT_PASSWORD,
      page: () => ForgotPasswordView(),
    ),
    GetPage(
      name: AppRoutes.SEARCH,
      page: () => SearchView(),
      binding: SearchBinding(),
    ),
  ];
}
