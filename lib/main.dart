// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:onlya_english/app/themes/theme.dart';
import 'app/middleware/auth/controllers/auth_controller.dart';
import 'app/modules/reading/controllers/reading_controller.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // Khởi tạo Firebase với cấu hình từ firebase_options.dart
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Cấu hình Firebase
  );
  Get.put(AuthController()); // Khởi tạo AuthController

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    print('Pausing ...');
    await Future.delayed(const Duration(seconds: 1));
    print('unPausing');
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      title: 'OnlyA',
      initialRoute: AppRoutes.AUTH_CHECKER,
      getPages: AppPages.pages,
      // Thêm các delegates để hỗ trợ đa ngôn ngữ
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate, // Hỗ trợ Material Components
        GlobalWidgetsLocalizations.delegate, // Hỗ trợ widget localization
        GlobalCupertinoLocalizations.delegate, // Hỗ trợ Cupertino localization
      ],
      supportedLocales: [
        const Locale('en', 'US'), // Ngôn ngữ mặc định
        const Locale('vi', 'VN'), // Hỗ trợ tiếng Việt
      ],
    );
  }
}
