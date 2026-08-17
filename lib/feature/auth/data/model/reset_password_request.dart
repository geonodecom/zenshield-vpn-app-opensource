class ResetPasswordRequest {
  ResetPasswordRequest({
    required this.email,
    required this.password,
    required this.token,
  });

  final String email;
  final String password;
  final String token;

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password, 'token': token};
  }
}
