import 'dart:io';

class CommonConstants {
  CommonConstants._();

  // Vpn turn off timeout
  static const vpnTurnOffTimeoutSec = 7200;

  // Google Sign-In OAuth client IDs. Public identifiers, not secrets — safe
  // to leave as-is. Only change these if you set up your OWN Firebase/Google
  // Cloud project (see README "Firebase setup") and want Google Sign-In to
  // work under that project instead of the original one.
  static const String googleSignInServerClientId =
      '743719985056-e5o8b6k7dsgap6knts8mhhjekmv8ub63.apps.googleusercontent.com';

  static const String googleSignInAndroidClientId =
      '743719985056-bcgvg5s8lisnfvrk1eelc5lpcbomas0i.apps.googleusercontent.com';

  static const String googleSignInIOSClientId =
      '743719985056-ge5b86ht0r395hjc85768lv1qqblrurc.apps.googleusercontent.com';

  // Windows-only GA4 analytics ping (see README "Windows analytics setup").
  // Optional — leave AMBILYTICS_API_SECRET unset and this feature just
  // silently does nothing; no build-define needed for either value unless
  // you want your own GA4 property to receive the events.
  static const String ambilyticsMeasurementId = String.fromEnvironment(
    'AMBILYTICS_MEASUREMENT_ID',
    defaultValue: 'G-KFCZM5BLEH',
  );
  static const String ambilyticsApiSecret = String.fromEnvironment(
    'AMBILYTICS_API_SECRET',
  );

  // App Store ID for the "Rate this app" deep link. Public, not a secret.
  static const String appStoreId = '6761452504';

  // Bandwidth-sharing SDK (package:geonode_sdk, proprietary, from pub.dev).
  // Optional — leave every value below empty and the feature is skipped
  // entirely (code checks .isEmpty before ever touching the SDK); the app
  // then prompts for a key in its own in-app setup screen at runtime instead.
  //
  // TWO WAYS to supply your own key — do NOT edit the first argument (the
  // quoted UPPER_CASE name) in any of the String.fromEnvironment(...) calls
  // below, that's a lookup name, not a value slot, and silently stays empty
  // if you put your key there instead:
  //   1. Build-time: pass --dart-define=GEONODE_API_KEY=your-key (etc.),
  //      e.g. via a gitignored secrets.json — see README.
  //   2. Hardcode directly here instead: replace the empty defaultValue: ''
  //      below with your real key, e.g. defaultValue: 'your-key-here'.
  static const String geonodeSdkApiKeyWindows = String.fromEnvironment(
    'GEONODE_SDK_API_KEY_WINDOWS', 
    defaultValue: '', // ← paste your key here to hardcode it, or leave empty
  );
  static const String geonodeAppIdAndroid = String.fromEnvironment(
    'GEONODE_APP_ID_ANDROID',
    defaultValue: '', // ← paste your key here to hardcode it, or leave empty
  );
  static const String geonodeSdkApiKeyMacOS = String.fromEnvironment(
    'GEONODE_SDK_API_KEY_MACOS', 
    defaultValue: '', // ← paste your key here to hardcode it, or leave empty
  );
  static const String geonodeAppIdIOS = String.fromEnvironment(
    'GEONODE_APP_ID_IOS',
    defaultValue: '', // ← paste your key here to hardcode it, or leave empty
  );

  static const String geonodeApiKey = String.fromEnvironment(
    'GEONODE_API_KEY', 
    defaultValue: '', // ← paste your key here to hardcode it, or leave empty
  );

  /// The build-time app ID/key for whichever platform is currently running —
  /// see the four `geonode*` constants above. Empty on an unsupported
  /// platform or when the build didn't set the corresponding define.
  static String get geonodeAppIdForCurrentPlatform {
    if (Platform.isAndroid) return geonodeAppIdAndroid;
    if (Platform.isWindows) return geonodeSdkApiKeyWindows;
    if (Platform.isMacOS) return geonodeSdkApiKeyMacOS;
    if (Platform.isIOS) return geonodeAppIdIOS;
    return '';
  }
}
