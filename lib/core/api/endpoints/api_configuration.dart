import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_configuration.freezed.dart';
part 'api_configuration.g.dart';

@freezed
class ApiConfiguration with _$ApiConfiguration {
  const factory ApiConfiguration({
    required String host, //https://api.zenshield.com/api/v1
    required Map<String, String> endpoints,
    required DateTime updatedAt,
    @Default(1) int version,
  }) = _ApiConfiguration;

  factory ApiConfiguration.fromJson(Map<String, dynamic> json) =>
      _$ApiConfigurationFromJson(json);
}

@freezed
class ApiEndpoints with _$ApiEndpoints {
  const factory ApiEndpoints({
    required String initialize,
    required String login,
    required String registerWithPassword,
    required String verifyCode,
    required String googleAuth,
    required String googleAuthToken,
    required String googleIdToken,
    required String setNewPassword,
    required String getUserInfo,
    required String vpnConfigurations,
    required String getUserInfoRegion,
    required String pushLogs,
    required String getAppConfig,
    required String facebookAuth,
    required String appleIdToken,
    required String forgotPassword,
    required String agreements,
    required String consents,
    required String appVersion,
    required String appConfig,
    required String authSuccessRedirect,
  }) = _ApiEndpoints;

  static const _host = 'https://api.zenshield.com';
  factory ApiEndpoints.defaults() => const ApiEndpoints(
    initialize: '',
    login: '$_host/api/v1/auth/password/login',
    registerWithPassword: '$_host/api/v1/auth/password/register',
    verifyCode: '$_host/api/v1/auth/password/verify',
    googleAuth: '$_host/api/v1/auth/google/start',
    googleAuthToken: '$_host/api/v1/auth/google/token',
    googleIdToken: '$_host/api/v1/auth/google/id-token',
    facebookAuth: '$_host/api/v1/auth/facebook/start',
    appleIdToken: '$_host/api/v1/auth/apple/id-token',
    forgotPassword: '$_host/api/v1/auth/password/forgot-password',
    setNewPassword: '$_host/api/v1/auth/password/reset-password',
    getUserInfo: '$_host/api/v1/user/get-user-info',
    vpnConfigurations: '$_host/api/v1/vpn/vpn-configurations',
    getUserInfoRegion: '$_host/api/v1/vpn/get-vpn-server-ip-region',
    pushLogs: '$_host/api/v1/vpn/push-logs',
    getAppConfig: '$_host/api/v1/vpn/get-app-config',
    agreements: '$_host/api/v1/vpn/agreements',
    consents: '$_host/api/v1/vpn/consents',
    appVersion: '$_host/api/v1/vpn/app-version',
    appConfig: 'https://downloads.zenshield.com/api/v2/zenshield/version',
    authSuccessRedirect: '$_host/api/v1/auth/success',
  );

  factory ApiEndpoints.fromMap(Map<String, String> endpoints) {
    final defaults = ApiEndpoints.defaults();
    return ApiEndpoints(
      initialize: endpoints['initialize'] ?? defaults.initialize,
      login: endpoints['login'] ?? defaults.login,
      registerWithPassword:
          endpoints['register_with_password'] ?? defaults.registerWithPassword,
      verifyCode: endpoints['verify_code'] ?? defaults.verifyCode,
      googleAuth: endpoints['google_auth'] ?? defaults.googleAuth,
      googleAuthToken:
          endpoints['google_auth_token'] ?? defaults.googleAuthToken,
      googleIdToken: endpoints['google_id_token'] ?? defaults.googleIdToken,
      facebookAuth: endpoints['facebook_auth'] ?? defaults.facebookAuth,
      appleIdToken: endpoints['apple_id_token'] ?? defaults.appleIdToken,
      setNewPassword: endpoints['set_new_password'] ?? defaults.setNewPassword,
      getUserInfo: endpoints['get_user_info'] ?? defaults.getUserInfo,
      vpnConfigurations: endpoints['data'] ?? defaults.vpnConfigurations,
      getUserInfoRegion: endpoints['region'] ?? defaults.getUserInfoRegion,
      pushLogs: endpoints['push_logs'] ?? defaults.pushLogs,
      getAppConfig: endpoints['get_app_config'] ?? defaults.getAppConfig,
      forgotPassword: endpoints['forgot_password'] ?? defaults.forgotPassword,
      agreements: endpoints['agreements'] ?? defaults.agreements,
      consents: endpoints['consents'] ?? defaults.consents,
      appVersion: endpoints['app_version'] ?? defaults.appVersion,
      appConfig: endpoints['app_config'] ?? defaults.appConfig,
      authSuccessRedirect:
          endpoints['auth_success_redirect'] ?? defaults.authSuccessRedirect,
    );
  }

  factory ApiEndpoints.fromJson(Map<String, dynamic> json) =>
      _$ApiEndpointsFromJson(json);
}
