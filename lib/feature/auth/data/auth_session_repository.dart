import 'package:injectable/injectable.dart';
import 'package:zenshield/feature/auth/data/model/auth_models.dart';
import 'package:zenshield/feature/auth/data/model/auth_session_data/auth_session_data.dart';

abstract class AuthSessionRepository {
  String? get email;
  AuthType? get authType;
  String? get resetToken;

  AuthSessionData getAuthData();

  Future<void> save({
    required String email,
    required AuthType authType,
    String? password,
  });

  Future<void> clear();
}

// ignore: unused-code
@LazySingleton(as: AuthSessionRepository)
class InMemoryAuthSessionRepository implements AuthSessionRepository {
  String? _email;
  String? _sessionId;
  String? _resetToken;
  AuthType? _authType;

  @override
  String? get email => _email;
  String? get sessionId => _sessionId;
  @override
  AuthType? get authType => _authType;
  @override
  String? get resetToken => _resetToken;

  @override
  AuthSessionData getAuthData() {
    return AuthSessionData(
      email: _email,
      authType: _authType,
      resetToken: _resetToken,
    );
  }

  @override
  Future<void> save({
    required String email,
    required AuthType authType,
    String? password,
  }) async {
    _email = email;
    _authType = authType;
    _resetToken = password;
  }

  @override
  Future<void> clear() async {
    final cleared = AuthSessionData.empty();
    _email = cleared.email;
    _authType = cleared.authType;
    _resetToken = cleared.resetToken;
  }
}
