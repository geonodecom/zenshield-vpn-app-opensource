class OAuthResponse {
  OAuthResponse({required this.token, required this.id});

  factory OAuthResponse.fromJson(Map<String, dynamic> json) {
    return OAuthResponse(
      token: json['token'] as String,
      id: json['id'] as String,
    );
  }

  final String token;
  final String id;
}
