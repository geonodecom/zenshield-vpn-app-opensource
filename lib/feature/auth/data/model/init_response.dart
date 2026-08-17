class InitResponse {
  InitResponse({required this.id, required this.token});

  factory InitResponse.fromJson(Map<String, dynamic> json) {
    return InitResponse(
      id: json['id'] as String,
      token: json['token'] as String,
    );
  }

  final String id;
  final String token;
}
