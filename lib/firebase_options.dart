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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDM-Au7eTr4N2Wz5anS3W8hwyvO2t8FB4g',
    appId: '1:467544295906:android:d61f2590f2e6129bf811bb',
    messagingSenderId: '467544295906',
    projectId: 'manga-reader-manganelo',
    storageBucket: 'manga-reader-manganelo.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCxYdVSJgd-mITl8mTMMJebG4SpCvit1nY',
    appId: '1:467544295906:ios:410cef79d593c13ef811bb',
    messagingSenderId: '467544295906',
    projectId: 'manga-reader-manganelo',
    storageBucket: 'manga-reader-manganelo.appspot.com',
    androidClientId: '467544295906-8gu7292hgqfag9m516ccpr8ufa208k2o.apps.googleusercontent.com',
    iosClientId: '467544295906-t4dg613rq1q8f0bb5nlgjq3ue6fptf1k.apps.googleusercontent.com',
    iosBundleId: 'manga.fox.manga.reader.free',
  );
}
