import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zenshield/feature/auth/data/model/auth_models.dart';

part 'auth_session_data.freezed.dart';
part 'auth_session_data.g.dart';

@freezed
class AuthSessionData with _$AuthSessionData {
  const factory AuthSessionData({
    String? email,
    AuthType? authType,
    String? resetToken,
  }) = _AuthSessionData;
  factory AuthSessionData.fromJson(Map<String, dynamic> json) =>
      _$AuthSessionDataFromJson(json);

  const AuthSessionData._();

  factory AuthSessionData.empty() => const AuthSessionData();

  bool get isEmpty => email == null && authType == null && resetToken == null;

  bool get isNotEmpty => !isEmpty;
}
