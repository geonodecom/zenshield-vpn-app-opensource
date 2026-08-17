import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:zenshield/core/api/api.dart';
import 'package:zenshield/config/constants/common_constants.dart';
import 'package:zenshield/config/constants/secure_storage_keys.dart';
import 'package:zenshield/feature/auth/data/auth_session_repository.dart';
import 'package:zenshield/feature/auth/data/auth_repository.dart';
import 'package:zenshield/feature/auth/data/oauth.dart';
import 'package:zenshield/feature/auth/data/model/auth_models.dart';
import 'package:zenshield/feature/auth/data/model/auth_session_data/auth_session_data.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:zenshield/feature/auth/data/model/init_response.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

abstract class AbstractAuthUserUseCase {
  Future<void> initializeUserWithBackend();

  Future<bool> isAuthorized();

  /// Returns the currently stored user id (if any).
  Future<String?> getUserId();

  /// Account email persisted in secure storage at login. Null if never set.
  Future<String?> getStoredAccountEmail();

  Future<void> login(String email, String password);

  Future<void> registerWithPassword(
    String email,
    AuthType authType, {
    String? password,
  });

  Future<void> verifyCode(String email, String code, AuthType authType);

  Future<void> authWithGoogle();

  Future<void> authWithFacebook();

  Future<void> authWithApple();

  Future<void> forgotPassword(String email);

  Future<void> resetPassword({
    required String email,
    required String password,
    required String token,
  });

  AuthSessionData get session;

  Future<void> saveDeeplinkSessionData({
    required String email,
    required AuthType authType,
    String? password,
  });

  Future<void> clearSession();

  Future<void> resetAuthorization();
}

// ignore: unused-code
@Injectable(as: AbstractAuthUserUseCase)
class AuthUseCase implements AbstractAuthUserUseCase {
  AuthUseCase(
    this._httpClient,
    this._secureStorage,
    this._authRepository,
    this.infoPlugin,
    this._logger,
    this._session,
  );

  final Dio _httpClient;
  final FlutterSecureStorage _secureStorage;
  final DeviceInfoPlugin infoPlugin;
  final Talker _logger;
  final _uuid = const Uuid();
  final AbstractAuthRepository _authRepository;
  final AuthSessionRepository _session;

  @override
  AuthSessionData get session => _session.getAuthData();

  @override
  Future<void> initializeUserWithBackend() async {
    _logger.info('Try to initialize user');

    if (await isAuthorized()) {
      _logger.info('User already initialized');
      return;
    }

    String? previousId;
    if (Platform.isWindows) {
      final deviceInfo = await infoPlugin.windowsInfo;
      final deviceId = deviceInfo.deviceId;
      previousId = deviceId
          .replaceAll('{', '')
          .replaceAll('}', '')
          .toLowerCase();
    }

    previousId != null
        ? _logger.info('User already has id code, id: $previousId')
        : _logger.info('User not initialized, will initialize for first time');

    final resultId = previousId ?? _uuid.v4();
    final cleanedResultId = resultId.replaceAll('-', '');
    final shortId = cleanedResultId.substring(0, 16);
    final endpoint = Api.endpoints.initialize;

    final response = await _httpClient.post<Map<String, dynamic>>(
      endpoint,
      data: shortId,
    );

    _logger.info('User successfully initialized');

    final responseData = response.data;
    if (responseData == null) {
      throw Exception('Empty response data during user initialization');
    }

    final initResponse = InitResponse.fromJson(responseData);

    await _secureStorage.write(
      key: SecureStorageKeys.userId,
      value: initResponse.id,
    );
    await _authRepository.saveAccessToken(initResponse.token);
  }

  @override
  Future<bool> isAuthorized() async {
    try {
      final id = await _secureStorage.read(key: SecureStorageKeys.userId);
      final token = await _secureStorage.read(
        key: SecureStorageKeys.accessToken,
      );
      return id != null && token != null;
    } catch (e) {
      _logger.error('Error checking if user is initialized', e);
      return false;
    }
  }

  @override
  Future<String?> getUserId() async {
    try {
      final id = await _secureStorage.read(key: SecureStorageKeys.userId);
      if (id == null || id.isEmpty) return null;
      return id;
    } catch (e) {
      _logger.error('Failed to read user id from storage', e);
      return null;
    }
  }

  @override
  Future<String?> getStoredAccountEmail() async {
    try {
      final value = await _secureStorage.read(
        key: SecureStorageKeys.accountEmail,
      );
      if (value == null || value.isEmpty) return null;
      return value;
    } catch (e) {
      _logger.error('Failed to read stored account email', e);
      return null;
    }
  }

  Future<void> _persistAccountEmail(String? email) async {
    try {
      final trimmed = email?.trim();
      if (trimmed == null || trimmed.isEmpty) return;
      await _secureStorage.write(
        key: SecureStorageKeys.accountEmail,
        value: trimmed,
      );
    } catch (e, stackTrace) {
      _logger.error('Failed to persist account email', e, stackTrace);
    }
  }

  @override
  Future<void> login(String email, String password) async {
    try {
      _logger.info('Attempting to login with email: $email');

      await _authRepository.login(email: email, password: password);

      await _syncCanonicalUserId(fallbackUserId: email);
      await _persistAccountEmail(email);

      _logger.info('Login successful');
    } catch (e, stackTrace) {
      _logger.error('Login failed', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> registerWithPassword(
    String email,
    AuthType authType, {
    String? password,
  }) async {
    try {
      _logger.info(
        'Sending deeplink for email: $email, auth type: ${authType.value}',
      );

      await _authRepository.registerWithPassword(
        email: email,
        authType: authType,
        password: password,
      );

      _logger.info('Deeplink sent successfully');
    } catch (e, stackTrace) {
      _logger.error('Failed to send Deeplink', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> verifyCode(String email, String code, AuthType authType) async {
    try {
      _logger.info(
        'Verifying deeplink for email: $email, auth type: ${authType.value}',
      );

      await _authRepository.verifyCode(
        email: email,
        code: code,
        authType: authType,
      );

      await _syncCanonicalUserId(fallbackUserId: email);
      await _persistAccountEmail(email);

      _logger.info('Deeplink verified successfully');
    } catch (e, stackTrace) {
      _logger.error('Failed to verify deeplink', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> authWithGoogle() async {
    try {
      _logger.info('Authenticating with Google');

      if (Platform.isWindows || Platform.isMacOS) {
        final oAuth = OAuth();
        final serverResult = await oAuth.createLocalServer();
        final redirectPort = serverResult.port;
        final responseFuture = serverResult.responseFuture;

        _logger.info('Local server created on port: $redirectPort');

        final endpoint = Api.endpoints.googleAuth;
        final url = Uri.parse('$endpoint?port=$redirectPort');

        if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
          throw Exception('Could not launch $url');
        }

        _logger.info('Google authentication URL opened in browser');
        _logger.info(
          'Waiting for response from backend on port: $redirectPort',
        );

        final authResponse = await responseFuture;

        await _secureStorage.write(
          key: SecureStorageKeys.userId,
          value: authResponse.id,
        );
        await _authRepository.saveAccessToken(authResponse.token);
        await _syncCanonicalUserId(fallbackUserId: authResponse.id);

        _logger.info(
          'UserId saved after Google authentication: ${authResponse.id}',
        );
        _logger.info('Google authentication successful');
      } else if (Platform.isIOS || Platform.isAndroid) {
        final signIn = GoogleSignIn(
          clientId: Platform.isAndroid
              ? CommonConstants.googleSignInAndroidClientId
              : Platform.isIOS
              ? CommonConstants.googleSignInIOSClientId
              : "",
          serverClientId: CommonConstants.googleSignInServerClientId,
        );

        final subscription = signIn.onCurrentUserChanged.listen(
          _handleGoogleSignInUserChanged,
          onError: _handleGoogleSignInError,
        );

        try {
          if (await signIn.isSignedIn()) {
            signIn.signOut();
          }
          final GoogleSignInAccount? googleUser = await signIn.signIn();

          final GoogleSignInAuthentication? googleAuth =
              await googleUser?.authentication;
          final String? idToken = googleAuth?.idToken;

          if (idToken == null || idToken.isEmpty) {
            throw Exception(
              'Google Sign-In was cancelled or id_token was not received',
            );
          }

          final authResponse = await _authRepository.loginWithGoogleIdToken(
            idToken,
          );

          await _secureStorage.write(
            key: SecureStorageKeys.userId,
            value: authResponse.id,
          );
          await _persistAccountEmail(googleUser?.email);

          _logger.info(
            'UserId saved after Google authentication: ${authResponse.id}',
          );
          _logger.info('Google authentication successful');
        } finally {
          await subscription.cancel();
        }
      }
    } catch (e, stackTrace) {
      _logger.error('Google authentication failed', e, stackTrace);
      rethrow;
    }
  }

  void _handleGoogleSignInUserChanged(GoogleSignInAccount? user) {
    if (user != null) {
      _logger.info('Google Sign-In: user changed, email=${user.email}');
    } else {
      _logger.info('Google Sign-In: user signed out');
    }
  }

  void _handleGoogleSignInError(Object error, [StackTrace? stackTrace]) {
    _logger.error('Google Sign-In stream error', error, stackTrace);
  }

  @override
  Future<void> authWithFacebook() async {
    try {
      _logger.info('Authenticating with Facebook');

      if (Platform.isWindows ||
          Platform.isMacOS ||
          Platform.isAndroid ||
          Platform.isIOS) {
        final oAuth = OAuth();
        final serverResult = await oAuth.createLocalServer();
        final redirectPort = serverResult.port;
        final responseFuture = serverResult.responseFuture;

        _logger.info('Local server created on port: $redirectPort');

        final endpoint = Api.endpoints.facebookAuth;
        final url = Uri.parse('$endpoint?port=$redirectPort');

        // On Android, some OEM skins (e.g. MIUI's "XSpace" resolver) hijack
        // an externally-launched browser Activity and shove it to the
        // background before the user ever sees the login page. Launching as
        // an in-app browser tab (Chrome Custom Tabs / SFSafariViewController)
        // keeps the browser inside our own task, which sidesteps that
        // interception; desktop has no such OEM layer, so external browser
        // is still correct there.
        final launchMode = (Platform.isAndroid || Platform.isIOS)
            ? LaunchMode.inAppBrowserView
            : LaunchMode.externalApplication;

        if (!await launchUrl(url, mode: launchMode)) {
          throw Exception('Could not launch $url');
        }

        _logger.info('Facebook authentication URL opened in browser');
        _logger.info(
          'Waiting for response from backend on port: $redirectPort',
        );

        final authResponse = await responseFuture;

        await _secureStorage.write(
          key: SecureStorageKeys.userId,
          value: authResponse.id,
        );
        await _authRepository.saveAccessToken(authResponse.token);
        await _syncCanonicalUserId(fallbackUserId: authResponse.id);

        _logger.info(
          'UserId saved after Facebook authentication: ${authResponse.id}',
        );
        _logger.info('Facebook authentication successful');
      } else {
        throw UnsupportedError(
          'Facebook OAuth is only supported on desktop platforms',
        );
      }
    } catch (e, stackTrace) {
      _logger.error('Facebook authentication failed', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> authWithApple() async {
    try {
      _logger.info('Authenticating with Apple');

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final idToken = credential.identityToken;
      if (idToken == null || idToken.isEmpty) {
        throw Exception(
          'Apple Sign-In was cancelled or identity token was not received',
        );
      }

      final authResponse = await _authRepository.loginWithAppleIdToken(idToken);

      await _secureStorage.write(
        key: SecureStorageKeys.userId,
        value: authResponse.id,
      );
      await _persistAccountEmail(credential.email);

      _logger.info(
        'UserId saved after Apple authentication: ${authResponse.id}',
      );
      _logger.info('Apple authentication successful');
    } catch (e, stackTrace) {
      _logger.error('Apple authentication failed', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      _logger.info('Requesting password reset for email: $email');

      await _authRepository.forgotPassword(email: email);

      await _session.save(email: email, authType: AuthType.changePass);

      _logger.info('Password reset request sent successfully');
    } catch (e, stackTrace) {
      _logger.error('Failed to request password reset', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String password,
    required String token,
  }) async {
    try {
      _logger.info('Resetting password for email: $email');

      await _authRepository.resetPassword(
        email: email,
        password: password,
        token: token,
      );

      _logger.info('Password reset successfully');
    } catch (e, stackTrace) {
      _logger.error('Failed to reset password', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> saveDeeplinkSessionData({
    required String email,
    required AuthType authType,
    String? password,
  }) => _session.save(email: email, authType: authType, password: password);

  @override
  Future<void> clearSession() => _session.clear();

  @override
  Future<void> resetAuthorization() async {
    try {
      _logger.info('Resetting authorization');

      await _secureStorage.delete(key: SecureStorageKeys.userId);
      await _secureStorage.delete(key: SecureStorageKeys.accountEmail);
      await _secureStorage.delete(key: SecureStorageKeys.accessToken);
      await _session.clear();

      _logger.info('Authorization reset successfully');
    } catch (e, stackTrace) {
      _logger.error('Failed to reset authorization', e, stackTrace);
      rethrow;
    }
  }

  Future<void> _syncCanonicalUserId({required String fallbackUserId}) async {
    try {
      final response = await _httpClient.get<Map<String, dynamic>>(
        Api.endpoints.getUserInfo,
      );
      final data = response.data;
      final emailRaw = data?['email'];
      if (emailRaw is String && emailRaw.trim().isNotEmpty) {
        await _persistAccountEmail(emailRaw);
      }
      final backendUserId = data?['id']?.toString();
      final userIdToStore = (backendUserId != null && backendUserId.isNotEmpty)
          ? backendUserId
          : fallbackUserId;
      await _secureStorage.write(
        key: SecureStorageKeys.userId,
        value: userIdToStore,
      );
      _logger.info('Canonical userId saved: $userIdToStore');
    } catch (e, stackTrace) {
      _logger.warning('Failed to fetch canonical userId, using fallback value');
      _logger.error('Canonical userId sync failed', e, stackTrace);
      await _secureStorage.write(
        key: SecureStorageKeys.userId,
        value: fallbackUserId,
      );
    }
  }
}
