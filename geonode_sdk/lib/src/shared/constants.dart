// ignore_for_file: non_constant_identifier_names

class AppConstants {
  // PREFS
  static String CONFIG_VERSION_TOKEN = "config_version_token";
  static String SOCKET_CONNECTION_KEY = "socket_connection_key";
  static String LOGIN_TOKEN = "loginToken";
  static String PEER_TOKEN = "p-api-token";
  static String SDK_API_KEY = "api-key";
  static String USER_ID = "user_id";
  static String PEER_ID = "peer_id";
  static String SHARE_INTERNET = "shareInternet";
  static String CONNECTION_STATUS = "connectionStatus";

  // Service
  static String HEADER_AUTH_TOKEN = "auth-token";
  static String HEADER_PEER_TOKEN = "auth-token";

  // API
  static String API_URL = "api_url";
  static String PEER_URL = "peer_url";
  static String PEER_MONITOR_URL = "peer_monitor_url";
  static String OFFERS_URL = "offers_url";
}

/// Build-time secrets for this package. Provide values using `--dart-define`.
class BuildConfig {
  /// Shared password for the debug curl command logged during peer
  /// connection setup (proxy auth diagnostics). See peer.service.dart.
  static const tcpAuthSecret = String.fromEnvironment('GEONODE_TCP_AUTH_SECRET');
}
