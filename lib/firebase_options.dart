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
    apiKey: 'AIzaSyDFtVNBW1ysBZFxIj1x21uxinX3fEiEL1k',
    appId: '1:450778588815:web:ff65d0bb8ad92c445e72fa',
    messagingSenderId: '450778588815',
    projectId: 'jotify-96bd1',
    authDomain: 'jotify-96bd1.firebaseapp.com',
    storageBucket: 'jotify-96bd1.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDfAHc-rlxcOE5GilQdMNlb3Mecyhb9nzw',
    appId: '1:450778588815:android:27d9b8923b2f36e95e72fa',
    messagingSenderId: '450778588815',
    projectId: 'jotify-96bd1',
    storageBucket: 'jotify-96bd1.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDcTTm1HKmjou893Vleu4gRAmTurWjKPIo',
    appId: '1:450778588815:ios:d11a54e17b79825d5e72fa',
    messagingSenderId: '450778588815',
    projectId: 'jotify-96bd1',
    storageBucket: 'jotify-96bd1.firebasestorage.app',
    iosBundleId: 'com.akshat.jotify',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDcTTm1HKmjou893Vleu4gRAmTurWjKPIo',
    appId: '1:450778588815:ios:d11a54e17b79825d5e72fa',
    messagingSenderId: '450778588815',
    projectId: 'jotify-96bd1',
    storageBucket: 'jotify-96bd1.firebasestorage.app',
    iosBundleId: 'com.akshat.jotify',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDFtVNBW1ysBZFxIj1x21uxinX3fEiEL1k',
    appId: '1:450778588815:web:14948958f348b8c55e72fa',
    messagingSenderId: '450778588815',
    projectId: 'jotify-96bd1',
    authDomain: 'jotify-96bd1.firebaseapp.com',
    storageBucket: 'jotify-96bd1.firebasestorage.app',
  );
}
