// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyDV0Ri8lLzlipAPhj4APbIjSI06St704jY',
    appId: '1:897338692724:web:494e5e7bee095339606d21',
    messagingSenderId: '897338692724',
    projectId: 'fortune-50ef2',
    authDomain: 'fortune-50ef2.firebaseapp.com',
    storageBucket: 'fortune-50ef2.appspot.com',
    measurementId: 'G-V7ELGM3GWJ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBeHIQOfmd2jDZdg5Iw4zmasS1nSyLoA28',
    appId: '1:897338692724:android:9104ff5508d6833c606d21',
    messagingSenderId: '897338692724',
    projectId: 'fortune-50ef2',
    storageBucket: 'fortune-50ef2.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBVY17cPPmzDFSbjLW_nkgTwxmQbgamF9A',
    appId: '1:897338692724:ios:65aedda0c4f61fb0606d21',
    messagingSenderId: '897338692724',
    projectId: 'fortune-50ef2',
    storageBucket: 'fortune-50ef2.appspot.com',
    iosClientId: '897338692724-43nvkrjo88k80rdcr5ab65jdtqml96e1.apps.googleusercontent.com',
    iosBundleId: 'com.foresh.fortune',
  );
}
