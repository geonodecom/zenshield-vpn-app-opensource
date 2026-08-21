// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_configuration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApiConfigurationImpl _$$ApiConfigurationImplFromJson(
  Map<String, dynamic> json,
) => _$ApiConfigurationImpl(
  host: json['host'] as String,
  endpoints: Map<String, String>.from(json['endpoints'] as Map),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  version: (json['version'] as num?)?.toInt() ?? 1,
);

Map<String, dynamic> _$$ApiConfigurationImplToJson(
  _$ApiConfigurationImpl instance,
) => <String, dynamic>{
  'host': instance.host,
  'endpoints': instance.endpoints,
  'updatedAt': instance.updatedAt.toIso8601String(),
  'version': instance.version,
};

_$ApiEndpointsImpl _$$ApiEndpointsImplFromJson(Map<String, dynamic> json) =>
    _$ApiEndpointsImpl(
      initialize: json['initialize'] as String,
      login: json['login'] as String,
      registerWithPassword: json['registerWithPassword'] as String,
      verifyCode: json['verifyCode'] as String,
      googleAuth: json['googleAuth'] as String,
      googleAuthToken: json['googleAuthToken'] as String,
      googleIdToken: json['googleIdToken'] as String,
      setNewPassword: json['setNewPassword'] as String,
      getUserInfo: json['getUserInfo'] as String,
      vpnConfigurations: json['vpnConfigurations'] as String,
      getAppConfig: json['getAppConfig'] as String,
      facebookAuth: json['facebookAuth'] as String,
      appleIdToken: json['appleIdToken'] as String,
      forgotPassword: json['forgotPassword'] as String,
      authSuccessRedirect: json['authSuccessRedirect'] as String,
    );

Map<String, dynamic> _$$ApiEndpointsImplToJson(_$ApiEndpointsImpl instance) =>
    <String, dynamic>{
      'initialize': instance.initialize,
      'login': instance.login,
      'registerWithPassword': instance.registerWithPassword,
      'verifyCode': instance.verifyCode,
      'googleAuth': instance.googleAuth,
      'googleAuthToken': instance.googleAuthToken,
      'googleIdToken': instance.googleIdToken,
      'setNewPassword': instance.setNewPassword,
      'getUserInfo': instance.getUserInfo,
      'vpnConfigurations': instance.vpnConfigurations,
      'getAppConfig': instance.getAppConfig,
      'facebookAuth': instance.facebookAuth,
      'appleIdToken': instance.appleIdToken,
      'forgotPassword': instance.forgotPassword,
      'authSuccessRedirect': instance.authSuccessRedirect,
    };
