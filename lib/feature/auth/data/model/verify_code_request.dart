import 'package:zenshield/feature/auth/data/model/auth_models.dart';

class VerifyCodeRequest {
  VerifyCodeRequest({
    required this.authType,
    required this.email,
    required this.code,
  });

  final AuthType authType;
  final String email;
  final String code;

  Map<String, dynamic> toJson() {
    return {'authType': authType.value, 'email': email, 'code': code};
  }
}
