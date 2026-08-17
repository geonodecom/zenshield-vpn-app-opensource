// ignore_for_file: constant_identifier_names
enum AnalyticsEventNames {
  // Canonical product analytics (raw names expected by dashboard)
  app_installed,
  app_opened,
  login_succeeded,
  login_failed,
  sign_up_submitted,
  onboarding_agreement_accepted,
  onboarding_agreement_declined,
  vpn_connect_requested,
  vpn_connected,
  vpn_disconnected,
  vpn_connection_failed,
  /// Tunnel connected but the exit server carries no real traffic (or died
  /// mid-session) — detected by the post-connect probe / auto-failover.
  vpn_node_death,
  server_selected,
  protocol_changed,
  logout_completed,
  app_update_started,
  app_rated,
  about_privacy_policy_tapped,
  about_terms_of_service_tapped,
  about_bandwidth_sharing_policy_tapped,
  about_eula_tapped,
  about_email_tapped,
  support_email_tapped
}

extension AnalyticsKeyValueParam on String {
  Map<String, String> asAnalyticsParam(String key) => {key: this};
}
