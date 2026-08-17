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
  // Optional — leave GEONODE_API_KEY unset and the feature is skipped
  // entirely (code checks .isEmpty before ever touching the SDK).
  static const String geonodeSdkApiKeyWindows = String.fromEnvironment(
    'GEONODE_SDK_API_KEY_WINDOWS', // Windows build of the same SDK feature
  );
  static const String geonodeAppIdAndroid = String.fromEnvironment(
    'GEONODE_APP_ID_ANDROID', // Android build of the same SDK feature
  );
  static const String geonodeSdkApiKeyMacOS = String.fromEnvironment(
    'GEONODE_SDK_API_KEY_MACOS', // macOS build — not part of this OSS release
  );
  static const String geonodeAppIdIOS = String.fromEnvironment(
    'GEONODE_APP_ID_IOS', // iOS build of the same SDK feature
  );

  static const String geonodeApiKey = String.fromEnvironment(
    'GEONODE_API_KEY', // required on every platform above for the SDK to init
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
