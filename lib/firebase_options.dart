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
    apiKey: 'AIzaSyAu4k8FXpDQZ9fDqmhmCQaT-LGlV3oA5bk',
    appId: '1:16236300450:web:73ebecc03841e6113aaffb',
    messagingSenderId: '16236300450',
    projectId: 'manager-b2c17',
    authDomain: 'manager-b2c17.firebaseapp.com',
    storageBucket: 'manager-b2c17.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDIfam6Zkn8O5Irn6r7M3neotpexgW38jI',
    appId: '1:16236300450:android:f8add7fedecb4ffb3aaffb',
    messagingSenderId: '16236300450',
    projectId: 'manager-b2c17',
    storageBucket: 'manager-b2c17.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB-cMOMaxRRuUWLSyizCgyRgtUF5ZP8RwE',
    appId: '1:16236300450:ios:38e88379bec13aec3aaffb',
    messagingSenderId: '16236300450',
    projectId: 'manager-b2c17',
    storageBucket: 'manager-b2c17.appspot.com',
    iosBundleId: 'com.example.qubtanManager',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB-cMOMaxRRuUWLSyizCgyRgtUF5ZP8RwE',
    appId: '1:16236300450:ios:38e88379bec13aec3aaffb',
    messagingSenderId: '16236300450',
    projectId: 'manager-b2c17',
    storageBucket: 'manager-b2c17.appspot.com',
    iosBundleId: 'com.example.qubtanManager',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAu4k8FXpDQZ9fDqmhmCQaT-LGlV3oA5bk',
    appId: '1:16236300450:web:3b0a407121cad6653aaffb',
    messagingSenderId: '16236300450',
    projectId: 'manager-b2c17',
    authDomain: 'manager-b2c17.firebaseapp.com',
    storageBucket: 'manager-b2c17.appspot.com',
  );
}
