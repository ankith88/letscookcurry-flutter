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
    apiKey: 'AIzaSyBg1UAiUEzOwgdXOFld7WdCYXgACbGpkgQ',
    appId: '1:365487480731:web:d2265d6853c1c5897f8b3e',
    messagingSenderId: '365487480731',
    projectId: 'letscookcurry',
    authDomain: 'letscookcurry.firebaseapp.com',
    storageBucket: 'letscookcurry.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB4HKyJqrfGvrcqoGYyvaawiMeNvxseJ9o',
    appId: '1:365487480731:android:99c21da61677af347f8b3e',
    messagingSenderId: '365487480731',
    projectId: 'letscookcurry',
    storageBucket: 'letscookcurry.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB8foMCtqaVo06h3tjbgFk7vVzzDcvcvRo',
    appId: '1:365487480731:ios:d750550aefd2a6447f8b3e',
    messagingSenderId: '365487480731',
    projectId: 'letscookcurry',
    storageBucket: 'letscookcurry.appspot.com',
    iosClientId: '365487480731-01pe49ndq14vj9kjefgbu8au7511ftt9.apps.googleusercontent.com',
    iosBundleId: 'com.letscookcurry.letscookcurry',
  );
}
