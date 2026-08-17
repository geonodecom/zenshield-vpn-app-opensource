class SecureStorageKeys {
  static const userId = 'userId';
  /// Last known account email (set on login / OAuth when available).
  static const accountEmail = 'accountEmail';
  static const accessToken = 'authToken';
  static const clashApiToken = 'clashApiToken';
  static const clashApiPort = 'clashApiPort';
  static const analyticsDistinctId = 'analyticsDistinctId';
  /// Stable per-install device id for analytics. Unlike [analyticsDistinctId]
  /// it survives logout/reset, so events from the same install stay joinable.
  static const analyticsDeviceId = 'analyticsDeviceId';
}
