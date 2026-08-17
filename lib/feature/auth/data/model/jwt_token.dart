class JwtToken {
  JwtToken({required this.token});

  factory JwtToken.fromJson(Map<String, dynamic> json) {
    return JwtToken(token: json['token'] as String);
  }

  final String token;
}
