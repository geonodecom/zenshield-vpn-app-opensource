class Environment {
  final String secret;

  final String apiUrl;
  final String peerUrl;
  final String dynamicLinkUrl;
  final String generateDynamicBaseUrl;
  final String peerMonitorUrl;
  final String offerUrl;

  Environment(this.secret, this.apiUrl, this.peerUrl, this.dynamicLinkUrl,
      this.generateDynamicBaseUrl, this.peerMonitorUrl, this.offerUrl);
}

class EnvironmentValue {
  static final Environment staging = Environment(
      'Staging',
      "https://api-staging.repocket.com/api/",
      "https://peer-staging.repocket.com/api/",
      "https://staging-link.repocket.com",
      "https://repocket.com/join",
      "https://monitor.repocket.com/api/",
      "https://staging-repocket-dashboard.netlify.app/offers");
  static final Environment production = Environment(
      'Production',
      "https://api.repocket.com/api/",
      "https://peer.repocket.com/api/",
      "https://link.repocket.com",
      "https://repocket.com/join",
      "https://monitor.repocket.com/api/",
      "https://app.repocket.com/offers");
}
