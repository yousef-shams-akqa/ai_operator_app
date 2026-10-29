import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';

/// Compile-time debug token for App Check (local dev / CI).
///
/// Register the same value in Firebase Console:
/// App Check → your app → Debug tokens → Add debug token.
///
/// Example:
/// `flutter run --dart-define=APP_CHECK_DEBUG_TOKEN=<your-token>`
/// Activates App Check after [Firebase.initializeApp] and before Firebase AI usage.

class AppCheckSetup {  
  static Future<void> activateAppCheck() async {
    const appCheckDebugToken = String.fromEnvironment('APP_CHECK_DEBUG_TOKEN', defaultValue: '');
    final optionalDebugToken = appCheckDebugToken.isNotEmpty ? appCheckDebugToken : null;
    if (kDebugMode) {
      await FirebaseAppCheck.instance.activate(
        providerWeb: WebDebugProvider(debugToken: optionalDebugToken),
        providerAndroid: AndroidDebugProvider(debugToken: optionalDebugToken),
        providerApple: AppleDebugProvider(debugToken: optionalDebugToken),
        providerWindows: WindowsDebugProvider(debugToken: optionalDebugToken),
      );
      return;
    }

    await FirebaseAppCheck.instance.activate(
      providerAndroid: const AndroidPlayIntegrityProvider(),
      providerApple: const AppleDeviceCheckProvider(),
    );
  }

}