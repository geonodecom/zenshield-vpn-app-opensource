import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:zenshield/core/api/api.dart';
import 'package:zenshield/config/constants/secure_storage_keys.dart';
import 'package:zenshield/feature/auth/data/model/auth_models.dart';
import 'package:zenshield/feature/auth/data/model/oauth_response.dart';
import 'package:talker_flutter/talker_flutter.dart';

abstract class AbstractAuthRepository {
  Future<JwtToken> login({required String email, required String password});

  Future<OAuthResponse> loginWithGoogleIdToken(String idToken);

  Future<OAuthResponse> loginWithAppleIdToken(String idToken);

  Future<void> registerWithPassword({
    required String email,
    required AuthType authType,
    String? password,
  });

  Future<JwtToken> verifyCode({
    required String email,
    required String code,
    required AuthType authType,
  });

  Future<void> forgotPassword({required String email});

  Future<void> resetPassword({
    required String email,
    required String password,
    required String token,
  });

  Future<void> setNewPassword({required String password});

  Future<void> saveAccessToken(String token);
}

// ignore: unused-code
@Injectable(as: AbstractAuthRepository)
class AuthRepository implements AbstractAuthRepository {
  AuthRepository(this._httpClient, this._logger, this._secureStorage);

  final Dio _httpClient;
  final Talker _logger;
  final FlutterSecureStorage _secureStorage;

  @override
  Future<void> saveAccessToken(String token) async {
    try {
      await _secureStorage.write(
        key: SecureStorageKeys.accessToken,
        value: token,
      );
      _logger.info('Access token saved');
    } catch (e) {
      _logger.error('Failed to save access token', e);
    }
  }

  @override
  Future<JwtToken> login({
    required String email,
    required String password,
  }) async {
    _logger.info('Trying to login with email: $email');

    final request = LoginRequest(email: email, password: password);

    final endpoint = Api.endpoints.login;
    final response = await _httpClient.post<Map<String, dynamic>>(
      endpoint,
      data: request.toJson(),
    );

    final responseData = response.data;
    if (responseData == null) {
      throw Exception('Empty response data during login');
    }

    final token = JwtToken.fromJson(responseData);
    await saveAccessToken(token.token);

    _logger.info('User successfully logged in');
    return token;
  }

  @override
  Future<OAuthResponse> loginWithGoogleIdToken(String idToken) async {
    _logger.info('Logging in with Google id_token');

    final endpoint = Api.endpoints.googleIdToken;
    final response = await _httpClient.post<Map<String, dynamic>>(
      endpoint,
      data: <String, dynamic>{'id_token': idToken},
      options: Options(contentType: Headers.jsonContentType),
    );

    final responseData = response.data;
    if (responseData == null) {
      throw Exception('Empty response data during Google token login');
    }

    final authResponse = OAuthResponse.fromJson(responseData);
    await saveAccessToken(authResponse.token);

    _logger.info('Google token login successful');
    return authResponse;
  }

  @override
  Future<OAuthResponse> loginWithAppleIdToken(String idToken) async {
    _logger.info('Logging in with Apple id_token');

    final endpoint = Api.endpoints.appleIdToken;
    final response = await _httpClient.post<Map<String, dynamic>>(
      endpoint,
      data: <String, dynamic>{'id_token': idToken},
      options: Options(contentType: Headers.jsonContentType),
    );

    final responseData = response.data;
    if (responseData == null) {
      throw Exception('Empty response data during Apple token login');
    }

    final authResponse = OAuthResponse.fromJson(responseData);
    await saveAccessToken(authResponse.token);

    _logger.info('Apple token login successful');
    return authResponse;
  }

  @override
  Future<void> registerWithPassword({
    required String email,
    required AuthType authType,
    String? password,
  }) async {
    _logger.info(
      'Sending deeplink for email: $email, '
      'type: ${authType.value}',
    );

    final request = RegisterWithPasswordRequest(
      email: email,
      authType: authType,
      password: password,
    );

    final endpoint = Api.endpoints.registerWithPassword;
    final response = await _httpClient.post<Map<String, dynamic>>(
      endpoint,
      data: request.toJson(),
    );

    final responseData = response.data;
    if (responseData == null) {
      throw Exception('Empty response data during sending deeplink for email');
    }

    _logger.info('Deeplink successfully sent');
  }

  @override
  Future<JwtToken> verifyCode({
    required String email,
    required String code,
    required AuthType authType,
  }) async {
    _logger.info('Verifying deeplink for email: $email');

    final request = VerifyCodeRequest(
      email: email,
      code: code,
      authType: authType,
    );

    final endpoint = Api.endpoints.verifyCode;
    final response = await _httpClient.post<Map<String, dynamic>>(
      endpoint,
      data: request.toJson(),
    );

    final responseData = response.data;
    if (responseData == null) {
      throw Exception('Empty response data during deeplink verification');
    }

    final token = JwtToken.fromJson(responseData);

    if (authType != AuthType.delete) {
      await saveAccessToken(token.token);
    }

    _logger.info('Deeplink successfully verified');
    return token;
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    _logger.info('Requesting password reset for email: $email');

    final request = ForgotPasswordRequest(email: email);

    final endpoint = Api.endpoints.forgotPassword;
    await _httpClient.post<void>(endpoint, data: request.toJson());

    _logger.info('Password reset request sent successfully');
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String password,
    required String token,
  }) async {
    _logger.info('Resetting password for email: $email');

    final request = ResetPasswordRequest(
      email: email,
      password: password,
      token: token,
    );

    final endpoint = Api.endpoints.setNewPassword;
    await _httpClient.post<void>(endpoint, data: request.toJson());

    _logger.info('Password reset successfully');
  }

  @override
  Future<void> setNewPassword({required String password}) async {
    _logger.info('Setting new password');

    final request = SetPasswordRequest(password: password);

    final endpoint = Api.endpoints.setNewPassword;
    await _httpClient.post<void>(endpoint, data: request.toJson());

    _logger.info('Password successfully set');
  }
}
