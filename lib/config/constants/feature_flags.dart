/// Temporary runtime flags for development/testing.
///
/// Keep these defaults conservative for production builds.
abstract final class FeatureFlags {
  /// When true, the app will skip the in-app update flow (Android/Desktop).
  static const bool disableInAppUpdates = false;
}

