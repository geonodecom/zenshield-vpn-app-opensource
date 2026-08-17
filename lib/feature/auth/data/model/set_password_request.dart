class SetPasswordRequest {
  SetPasswordRequest({required this.password});

  final String password;

  Map<String, dynamic> toJson() {
    return {'password': password};
  }
}
