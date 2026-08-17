enum AuthType {
  login('login'),
  register('register'),
  changePass('changePass'),
  delete('delete');

  const AuthType(this.value);
  final String value;
}

class RegisterWithPasswordRequest {
  RegisterWithPasswordRequest({
    required this.authType,
    required this.email,
    this.password,
  });

  final AuthType authType;
  final String email;
  final String? password;

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{
      'authType': authType.value,
      'email': email,
    };

    if (password != null) {
      result['password'] = password;
    }

    return result;
  }
}
