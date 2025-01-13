// ignore_for_file: prefer_const_constructors

import 'package:get/get.dart';
import 'package:onlya_english/app/modules/Search/views/search_view.dart';
import 'package:onlya_english/app/modules/account/bindings/account_binding.dart';
import 'package:onlya_english/app/modules/account/views/change-pass-view.dart';
import 'package:onlya_english/app/modules/classrooms/bindings/classroom_binding.dart';
import 'package:onlya_english/app/modules/classrooms/view/classroom_view.dart';
import 'package:onlya_english/app/modules/edit_infomation/bindings/editInfomation_binding.dart';
import 'package:onlya_english/app/modules/edit_infomation/views/edit_infomation_view.dart';
import 'package:onlya_english/app/modules/essay/bindings/essay_binding.dart';
import 'package:onlya_english/app/modules/essay/views/essay_view.dart';
import 'package:onlya_english/app/modules/flashcard/views/flashcard_view.dart';
import 'package:onlya_english/app/modules/game/bindings/fish_game_binding.dart';
import 'package:onlya_english/app/modules/game/views/fish_game_view.dart';
import 'package:onlya_english/app/modules/listening/bindings/listening_binding.dart';
import 'package:onlya_english/app/modules/listening/views/listening_view.dart';
import 'package:onlya_english/app/modules/reading/bindings/reading_binding.dart';
import 'package:onlya_english/app/modules/reading/views/reading_view.dart';
import '../modules/flashcard/bindings/flashcard_binding.dart';
import 'package:onlya_english/app/middleware/auth/views/otp_auth_View.dart';
import 'package:onlya_english/app/modules/home/bindings/home_bindings.dart';
import '../modules/Search/bindings/search_binding.dart';
import '../modules/account/views/account_view.dart';
import '../middleware/auth/bindings/auth_binding.dart';
import '../middleware/auth/views/auth_checker_view.dart';
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
    GetPage(
      name: AppRoutes.EDIT_INFOMATION,
      page: () => EditInfomationView(),
      binding: EditinfomationBinding(),
    ),
    GetPage(
      name: AppRoutes.FLASHCARD,
      page: () => FlashcardView(),
      binding: FlashcardBinding(),
    ),
    GetPage(
      name: AppRoutes.LISTENING,
      page: () => ListeningPage(),
      binding: ListeningBinding(),
    ),
    GetPage(
      name: AppRoutes.CHANGE_PASS,
      page: () => ChangePassView(),
    ),
    GetPage(
      name: AppRoutes.CLASSROOM,
      page: () => ClassroomView(),
      binding: ClassroomBinding(),
    ),
    GetPage(
      name: AppRoutes.ESSAY,
      page: () => EssayView(),
      binding: EssayBinding(),
    ),
    GetPage(
      name: AppRoutes.GAME,
      page: () => FishGameView(),
      binding: FishGameBinding (),
    ),
    GetPage(
      name: AppRoutes.READING,
      page: () => ReadingView(),
      binding: ReadingBinding(),
    )
  ];
}
