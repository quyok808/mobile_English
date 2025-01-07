// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC_A4a2aOqJ5ca4U1H21jr4Ol0K6sAJEjc',
    appId: '1:759705698991:web:b22bd7749728c31a76ca5a',
    messagingSenderId: '759705698991',
    projectId: 'onlyaenglish',
    authDomain: 'onlyaenglish.firebaseapp.com',
    storageBucket: 'onlyaenglish.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAW2R9nK0QrK9hSaqzF9Ece_4s3AVP0lpE',
    appId: '1:759705698991:android:feae7a38f976248876ca5a',
    messagingSenderId: '759705698991',
    projectId: 'onlyaenglish',
    storageBucket: 'onlyaenglish.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCMXpNPoAEsa0VI1wW6K4vOlmW2_HChkcQ',
    appId: '1:759705698991:ios:fcdc8f56a3dc74e376ca5a',
    messagingSenderId: '759705698991',
    projectId: 'onlyaenglish',
    storageBucket: 'onlyaenglish.firebasestorage.app',
    iosClientId: '759705698991-8eo2s0kvnk0e2850ovo18djkocbcok3n.apps.googleusercontent.com',
    iosBundleId: 'com.example.onlyaEnglish',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCMXpNPoAEsa0VI1wW6K4vOlmW2_HChkcQ',
    appId: '1:759705698991:ios:fcdc8f56a3dc74e376ca5a',
    messagingSenderId: '759705698991',
    projectId: 'onlyaenglish',
    storageBucket: 'onlyaenglish.firebasestorage.app',
    iosClientId: '759705698991-8eo2s0kvnk0e2850ovo18djkocbcok3n.apps.googleusercontent.com',
    iosBundleId: 'com.example.onlyaEnglish',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC_A4a2aOqJ5ca4U1H21jr4Ol0K6sAJEjc',
    appId: '1:759705698991:web:f1d5fa69f491c1ff76ca5a',
    messagingSenderId: '759705698991',
    projectId: 'onlyaenglish',
    authDomain: 'onlyaenglish.firebaseapp.com',
    storageBucket: 'onlyaenglish.firebasestorage.app',
  );

}