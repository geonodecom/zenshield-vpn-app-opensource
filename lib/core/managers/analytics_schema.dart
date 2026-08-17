/// Single source of truth for analytics naming and properties.
///
/// Keep event names + property keys here so swapping analytics vendors later
/// won't require touching feature/UI code.
class AnalyticsProps {
  // Required on every event (super properties)
  static const platform = 'platform';
  static const source = 'source';
  static const appVersion = 'app_version';

  /// Set after login when known (person + event property).
  static const email = 'email';

  // Common optional
  static const launchType = 'launch_type'; // cold | resume

  /// ClickFlare click id carried via AppsFlyer OneLink (deferred deep link).
  static const cfClickId = 'cf_click_id';

  // Device identity (super properties, registered once at init)
  static const deviceId = 'device_id';
  static const deviceModel = 'device_model';
  static const osVersion = 'os_version';

  /// User's own country (from device locale — resolved without the tunnel, so
  /// it is not distorted by the VPN exit IP).
  static const userCountry = 'user_country';

  // VPN failure diagnostics (event properties on
  // `vpn_connection_failed` / `vpn_node_death`)
  static const serverIp = 'server_ip';
  static const serverCountry = 'server_country';
  static const serverCity = 'server_city';
  static const serverPort = 'server_port';
  static const protocol = 'protocol';
  static const networkType = 'network_type';

  /// Normalized, low-cardinality failure class — the property dashboards
  /// group by. One of: `traffic_blackhole`, `connection_refused`, `timeout`,
  /// `handshake_failed`, `permission_denied`, `setup_failed`, `connect_failed`.
  static const failureType = 'failure_type';

  /// Where in the lifecycle it failed:
  /// `initial_connect` | `post_connect_probe` | `failover`.
  static const failureStage = 'failure_stage';

  /// Whether the tunnel handshake completed before the failure. Combined with
  /// [probePassed] this separates "node death" (true/false) from a plain
  /// connect failure (false/false).
  static const tunnelEstablished = 'tunnel_established';

  /// Result of the through-the-tunnel traffic probe.
  static const probePassed = 'probe_passed';

  static const connectDurationMs = 'connect_duration_ms';
  static const errorCode = 'error_code';
  static const errorMessage = 'error_message';
  static const errorDetails = 'error_details';

  // Auto-failover outcome on `vpn_node_death`
  /// `switched` | `no_healthy_candidate`.
  static const failoverResult = 'failover_result';
  static const failoverToIp = 'failover_to_ip';
  static const serversTried = 'servers_tried';
}
