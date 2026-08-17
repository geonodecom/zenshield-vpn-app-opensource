// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_configuration.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ApiConfiguration _$ApiConfigurationFromJson(Map<String, dynamic> json) {
  return _ApiConfiguration.fromJson(json);
}

/// @nodoc
mixin _$ApiConfiguration {
  String get host =>
      throw _privateConstructorUsedError; //https://api.zenshield.com/api/v1
  Map<String, String> get endpoints => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  int get version => throw _privateConstructorUsedError;

  /// Serializes this ApiConfiguration to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ApiConfiguration
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApiConfigurationCopyWith<ApiConfiguration> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiConfigurationCopyWith<$Res> {
  factory $ApiConfigurationCopyWith(
    ApiConfiguration value,
    $Res Function(ApiConfiguration) then,
  ) = _$ApiConfigurationCopyWithImpl<$Res, ApiConfiguration>;
  @useResult
  $Res call({
    String host,
    Map<String, String> endpoints,
    DateTime updatedAt,
    int version,
  });
}

/// @nodoc
class _$ApiConfigurationCopyWithImpl<$Res, $Val extends ApiConfiguration>
    implements $ApiConfigurationCopyWith<$Res> {
  _$ApiConfigurationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApiConfiguration
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? host = null,
    Object? endpoints = null,
    Object? updatedAt = null,
    Object? version = null,
  }) {
    return _then(
      _value.copyWith(
            host: null == host
                ? _value.host
                : host // ignore: cast_nullable_to_non_nullable
                      as String,
            endpoints: null == endpoints
                ? _value.endpoints
                : endpoints // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            version: null == version
                ? _value.version
                : version // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ApiConfigurationImplCopyWith<$Res>
    implements $ApiConfigurationCopyWith<$Res> {
  factory _$$ApiConfigurationImplCopyWith(
    _$ApiConfigurationImpl value,
    $Res Function(_$ApiConfigurationImpl) then,
  ) = __$$ApiConfigurationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String host,
    Map<String, String> endpoints,
    DateTime updatedAt,
    int version,
  });
}

/// @nodoc
class __$$ApiConfigurationImplCopyWithImpl<$Res>
    extends _$ApiConfigurationCopyWithImpl<$Res, _$ApiConfigurationImpl>
    implements _$$ApiConfigurationImplCopyWith<$Res> {
  __$$ApiConfigurationImplCopyWithImpl(
    _$ApiConfigurationImpl _value,
    $Res Function(_$ApiConfigurationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ApiConfiguration
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? host = null,
    Object? endpoints = null,
    Object? updatedAt = null,
    Object? version = null,
  }) {
    return _then(
      _$ApiConfigurationImpl(
        host: null == host
            ? _value.host
            : host // ignore: cast_nullable_to_non_nullable
                  as String,
        endpoints: null == endpoints
            ? _value._endpoints
            : endpoints // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        version: null == version
            ? _value.version
            : version // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ApiConfigurationImpl implements _ApiConfiguration {
  const _$ApiConfigurationImpl({
    required this.host,
    required final Map<String, String> endpoints,
    required this.updatedAt,
    this.version = 1,
  }) : _endpoints = endpoints;

  factory _$ApiConfigurationImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApiConfigurationImplFromJson(json);

  @override
  final String host;
  //https://api.zenshield.com/api/v1
  final Map<String, String> _endpoints;
  //https://api.zenshield.com/api/v1
  @override
  Map<String, String> get endpoints {
    if (_endpoints is EqualUnmodifiableMapView) return _endpoints;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_endpoints);
  }

  @override
  final DateTime updatedAt;
  @override
  @JsonKey()
  final int version;

  @override
  String toString() {
    return 'ApiConfiguration(host: $host, endpoints: $endpoints, updatedAt: $updatedAt, version: $version)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApiConfigurationImpl &&
            (identical(other.host, host) || other.host == host) &&
            const DeepCollectionEquality().equals(
              other._endpoints,
              _endpoints,
            ) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.version, version) || other.version == version));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    host,
    const DeepCollectionEquality().hash(_endpoints),
    updatedAt,
    version,
  );

  /// Create a copy of ApiConfiguration
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApiConfigurationImplCopyWith<_$ApiConfigurationImpl> get copyWith =>
      __$$ApiConfigurationImplCopyWithImpl<_$ApiConfigurationImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ApiConfigurationImplToJson(this);
  }
}

abstract class _ApiConfiguration implements ApiConfiguration {
  const factory _ApiConfiguration({
    required final String host,
    required final Map<String, String> endpoints,
    required final DateTime updatedAt,
    final int version,
  }) = _$ApiConfigurationImpl;

  factory _ApiConfiguration.fromJson(Map<String, dynamic> json) =
      _$ApiConfigurationImpl.fromJson;

  @override
  String get host; //https://api.zenshield.com/api/v1
  @override
  Map<String, String> get endpoints;
  @override
  DateTime get updatedAt;
  @override
  int get version;

  /// Create a copy of ApiConfiguration
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApiConfigurationImplCopyWith<_$ApiConfigurationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ApiEndpoints _$ApiEndpointsFromJson(Map<String, dynamic> json) {
  return _ApiEndpoints.fromJson(json);
}

/// @nodoc
mixin _$ApiEndpoints {
  String get initialize => throw _privateConstructorUsedError;
  String get login => throw _privateConstructorUsedError;
  String get registerWithPassword => throw _privateConstructorUsedError;
  String get verifyCode => throw _privateConstructorUsedError;
  String get googleAuth => throw _privateConstructorUsedError;
  String get googleAuthToken => throw _privateConstructorUsedError;
  String get googleIdToken => throw _privateConstructorUsedError;
  String get setNewPassword => throw _privateConstructorUsedError;
  String get getUserInfo => throw _privateConstructorUsedError;
  String get vpnConfigurations => throw _privateConstructorUsedError;
  String get getUserInfoRegion => throw _privateConstructorUsedError;
  String get pushLogs => throw _privateConstructorUsedError;
  String get getAppConfig => throw _privateConstructorUsedError;
  String get facebookAuth => throw _privateConstructorUsedError;
  String get appleIdToken => throw _privateConstructorUsedError;
  String get forgotPassword => throw _privateConstructorUsedError;
  String get agreements => throw _privateConstructorUsedError;
  String get consents => throw _privateConstructorUsedError;
  String get appVersion => throw _privateConstructorUsedError;
  String get appConfig => throw _privateConstructorUsedError;
  String get authSuccessRedirect => throw _privateConstructorUsedError;

  /// Serializes this ApiEndpoints to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ApiEndpoints
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApiEndpointsCopyWith<ApiEndpoints> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiEndpointsCopyWith<$Res> {
  factory $ApiEndpointsCopyWith(
    ApiEndpoints value,
    $Res Function(ApiEndpoints) then,
  ) = _$ApiEndpointsCopyWithImpl<$Res, ApiEndpoints>;
  @useResult
  $Res call({
    String initialize,
    String login,
    String registerWithPassword,
    String verifyCode,
    String googleAuth,
    String googleAuthToken,
    String googleIdToken,
    String setNewPassword,
    String getUserInfo,
    String vpnConfigurations,
    String getUserInfoRegion,
    String pushLogs,
    String getAppConfig,
    String facebookAuth,
    String appleIdToken,
    String forgotPassword,
    String agreements,
    String consents,
    String appVersion,
    String appConfig,
    String authSuccessRedirect,
  });
}

/// @nodoc
class _$ApiEndpointsCopyWithImpl<$Res, $Val extends ApiEndpoints>
    implements $ApiEndpointsCopyWith<$Res> {
  _$ApiEndpointsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApiEndpoints
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? initialize = null,
    Object? login = null,
    Object? registerWithPassword = null,
    Object? verifyCode = null,
    Object? googleAuth = null,
    Object? googleAuthToken = null,
    Object? googleIdToken = null,
    Object? setNewPassword = null,
    Object? getUserInfo = null,
    Object? vpnConfigurations = null,
    Object? getUserInfoRegion = null,
    Object? pushLogs = null,
    Object? getAppConfig = null,
    Object? facebookAuth = null,
    Object? appleIdToken = null,
    Object? forgotPassword = null,
    Object? agreements = null,
    Object? consents = null,
    Object? appVersion = null,
    Object? appConfig = null,
    Object? authSuccessRedirect = null,
  }) {
    return _then(
      _value.copyWith(
            initialize: null == initialize
                ? _value.initialize
                : initialize // ignore: cast_nullable_to_non_nullable
                      as String,
            login: null == login
                ? _value.login
                : login // ignore: cast_nullable_to_non_nullable
                      as String,
            registerWithPassword: null == registerWithPassword
                ? _value.registerWithPassword
                : registerWithPassword // ignore: cast_nullable_to_non_nullable
                      as String,
            verifyCode: null == verifyCode
                ? _value.verifyCode
                : verifyCode // ignore: cast_nullable_to_non_nullable
                      as String,
            googleAuth: null == googleAuth
                ? _value.googleAuth
                : googleAuth // ignore: cast_nullable_to_non_nullable
                      as String,
            googleAuthToken: null == googleAuthToken
                ? _value.googleAuthToken
                : googleAuthToken // ignore: cast_nullable_to_non_nullable
                      as String,
            googleIdToken: null == googleIdToken
                ? _value.googleIdToken
                : googleIdToken // ignore: cast_nullable_to_non_nullable
                      as String,
            setNewPassword: null == setNewPassword
                ? _value.setNewPassword
                : setNewPassword // ignore: cast_nullable_to_non_nullable
                      as String,
            getUserInfo: null == getUserInfo
                ? _value.getUserInfo
                : getUserInfo // ignore: cast_nullable_to_non_nullable
                      as String,
            vpnConfigurations: null == vpnConfigurations
                ? _value.vpnConfigurations
                : vpnConfigurations // ignore: cast_nullable_to_non_nullable
                      as String,
            getUserInfoRegion: null == getUserInfoRegion
                ? _value.getUserInfoRegion
                : getUserInfoRegion // ignore: cast_nullable_to_non_nullable
                      as String,
            pushLogs: null == pushLogs
                ? _value.pushLogs
                : pushLogs // ignore: cast_nullable_to_non_nullable
                      as String,
            getAppConfig: null == getAppConfig
                ? _value.getAppConfig
                : getAppConfig // ignore: cast_nullable_to_non_nullable
                      as String,
            facebookAuth: null == facebookAuth
                ? _value.facebookAuth
                : facebookAuth // ignore: cast_nullable_to_non_nullable
                      as String,
            appleIdToken: null == appleIdToken
                ? _value.appleIdToken
                : appleIdToken // ignore: cast_nullable_to_non_nullable
                      as String,
            forgotPassword: null == forgotPassword
                ? _value.forgotPassword
                : forgotPassword // ignore: cast_nullable_to_non_nullable
                      as String,
            agreements: null == agreements
                ? _value.agreements
                : agreements // ignore: cast_nullable_to_non_nullable
                      as String,
            consents: null == consents
                ? _value.consents
                : consents // ignore: cast_nullable_to_non_nullable
                      as String,
            appVersion: null == appVersion
                ? _value.appVersion
                : appVersion // ignore: cast_nullable_to_non_nullable
                      as String,
            appConfig: null == appConfig
                ? _value.appConfig
                : appConfig // ignore: cast_nullable_to_non_nullable
                      as String,
            authSuccessRedirect: null == authSuccessRedirect
                ? _value.authSuccessRedirect
                : authSuccessRedirect // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ApiEndpointsImplCopyWith<$Res>
    implements $ApiEndpointsCopyWith<$Res> {
  factory _$$ApiEndpointsImplCopyWith(
    _$ApiEndpointsImpl value,
    $Res Function(_$ApiEndpointsImpl) then,
  ) = __$$ApiEndpointsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String initialize,
    String login,
    String registerWithPassword,
    String verifyCode,
    String googleAuth,
    String googleAuthToken,
    String googleIdToken,
    String setNewPassword,
    String getUserInfo,
    String vpnConfigurations,
    String getUserInfoRegion,
    String pushLogs,
    String getAppConfig,
    String facebookAuth,
    String appleIdToken,
    String forgotPassword,
    String agreements,
    String consents,
    String appVersion,
    String appConfig,
    String authSuccessRedirect,
  });
}

/// @nodoc
class __$$ApiEndpointsImplCopyWithImpl<$Res>
    extends _$ApiEndpointsCopyWithImpl<$Res, _$ApiEndpointsImpl>
    implements _$$ApiEndpointsImplCopyWith<$Res> {
  __$$ApiEndpointsImplCopyWithImpl(
    _$ApiEndpointsImpl _value,
    $Res Function(_$ApiEndpointsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ApiEndpoints
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? initialize = null,
    Object? login = null,
    Object? registerWithPassword = null,
    Object? verifyCode = null,
    Object? googleAuth = null,
    Object? googleAuthToken = null,
    Object? googleIdToken = null,
    Object? setNewPassword = null,
    Object? getUserInfo = null,
    Object? vpnConfigurations = null,
    Object? getUserInfoRegion = null,
    Object? pushLogs = null,
    Object? getAppConfig = null,
    Object? facebookAuth = null,
    Object? appleIdToken = null,
    Object? forgotPassword = null,
    Object? agreements = null,
    Object? consents = null,
    Object? appVersion = null,
    Object? appConfig = null,
    Object? authSuccessRedirect = null,
  }) {
    return _then(
      _$ApiEndpointsImpl(
        initialize: null == initialize
            ? _value.initialize
            : initialize // ignore: cast_nullable_to_non_nullable
                  as String,
        login: null == login
            ? _value.login
            : login // ignore: cast_nullable_to_non_nullable
                  as String,
        registerWithPassword: null == registerWithPassword
            ? _value.registerWithPassword
            : registerWithPassword // ignore: cast_nullable_to_non_nullable
                  as String,
        verifyCode: null == verifyCode
            ? _value.verifyCode
            : verifyCode // ignore: cast_nullable_to_non_nullable
                  as String,
        googleAuth: null == googleAuth
            ? _value.googleAuth
            : googleAuth // ignore: cast_nullable_to_non_nullable
                  as String,
        googleAuthToken: null == googleAuthToken
            ? _value.googleAuthToken
            : googleAuthToken // ignore: cast_nullable_to_non_nullable
                  as String,
        googleIdToken: null == googleIdToken
            ? _value.googleIdToken
            : googleIdToken // ignore: cast_nullable_to_non_nullable
                  as String,
        setNewPassword: null == setNewPassword
            ? _value.setNewPassword
            : setNewPassword // ignore: cast_nullable_to_non_nullable
                  as String,
        getUserInfo: null == getUserInfo
            ? _value.getUserInfo
            : getUserInfo // ignore: cast_nullable_to_non_nullable
                  as String,
        vpnConfigurations: null == vpnConfigurations
            ? _value.vpnConfigurations
            : vpnConfigurations // ignore: cast_nullable_to_non_nullable
                  as String,
        getUserInfoRegion: null == getUserInfoRegion
            ? _value.getUserInfoRegion
            : getUserInfoRegion // ignore: cast_nullable_to_non_nullable
                  as String,
        pushLogs: null == pushLogs
            ? _value.pushLogs
            : pushLogs // ignore: cast_nullable_to_non_nullable
                  as String,
        getAppConfig: null == getAppConfig
            ? _value.getAppConfig
            : getAppConfig // ignore: cast_nullable_to_non_nullable
                  as String,
        facebookAuth: null == facebookAuth
            ? _value.facebookAuth
            : facebookAuth // ignore: cast_nullable_to_non_nullable
                  as String,
        appleIdToken: null == appleIdToken
            ? _value.appleIdToken
            : appleIdToken // ignore: cast_nullable_to_non_nullable
                  as String,
        forgotPassword: null == forgotPassword
            ? _value.forgotPassword
            : forgotPassword // ignore: cast_nullable_to_non_nullable
                  as String,
        agreements: null == agreements
            ? _value.agreements
            : agreements // ignore: cast_nullable_to_non_nullable
                  as String,
        consents: null == consents
            ? _value.consents
            : consents // ignore: cast_nullable_to_non_nullable
                  as String,
        appVersion: null == appVersion
            ? _value.appVersion
            : appVersion // ignore: cast_nullable_to_non_nullable
                  as String,
        appConfig: null == appConfig
            ? _value.appConfig
            : appConfig // ignore: cast_nullable_to_non_nullable
                  as String,
        authSuccessRedirect: null == authSuccessRedirect
            ? _value.authSuccessRedirect
            : authSuccessRedirect // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ApiEndpointsImpl implements _ApiEndpoints {
  const _$ApiEndpointsImpl({
    required this.initialize,
    required this.login,
    required this.registerWithPassword,
    required this.verifyCode,
    required this.googleAuth,
    required this.googleAuthToken,
    required this.googleIdToken,
    required this.setNewPassword,
    required this.getUserInfo,
    required this.vpnConfigurations,
    required this.getUserInfoRegion,
    required this.pushLogs,
    required this.getAppConfig,
    required this.facebookAuth,
    required this.appleIdToken,
    required this.forgotPassword,
    required this.agreements,
    required this.consents,
    required this.appVersion,
    required this.appConfig,
    required this.authSuccessRedirect,
  });

  factory _$ApiEndpointsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApiEndpointsImplFromJson(json);

  @override
  final String initialize;
  @override
  final String login;
  @override
  final String registerWithPassword;
  @override
  final String verifyCode;
  @override
  final String googleAuth;
  @override
  final String googleAuthToken;
  @override
  final String googleIdToken;
  @override
  final String setNewPassword;
  @override
  final String getUserInfo;
  @override
  final String vpnConfigurations;
  @override
  final String getUserInfoRegion;
  @override
  final String pushLogs;
  @override
  final String getAppConfig;
  @override
  final String facebookAuth;
  @override
  final String appleIdToken;
  @override
  final String forgotPassword;
  @override
  final String agreements;
  @override
  final String consents;
  @override
  final String appVersion;
  @override
  final String appConfig;
  @override
  final String authSuccessRedirect;

  @override
  String toString() {
    return 'ApiEndpoints(initialize: $initialize, login: $login, registerWithPassword: $registerWithPassword, verifyCode: $verifyCode, googleAuth: $googleAuth, googleAuthToken: $googleAuthToken, googleIdToken: $googleIdToken, setNewPassword: $setNewPassword, getUserInfo: $getUserInfo, vpnConfigurations: $vpnConfigurations, getUserInfoRegion: $getUserInfoRegion, pushLogs: $pushLogs, getAppConfig: $getAppConfig, facebookAuth: $facebookAuth, appleIdToken: $appleIdToken, forgotPassword: $forgotPassword, agreements: $agreements, consents: $consents, appVersion: $appVersion, appConfig: $appConfig, authSuccessRedirect: $authSuccessRedirect)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApiEndpointsImpl &&
            (identical(other.initialize, initialize) ||
                other.initialize == initialize) &&
            (identical(other.login, login) || other.login == login) &&
            (identical(other.registerWithPassword, registerWithPassword) ||
                other.registerWithPassword == registerWithPassword) &&
            (identical(other.verifyCode, verifyCode) ||
                other.verifyCode == verifyCode) &&
            (identical(other.googleAuth, googleAuth) ||
                other.googleAuth == googleAuth) &&
            (identical(other.googleAuthToken, googleAuthToken) ||
                other.googleAuthToken == googleAuthToken) &&
            (identical(other.googleIdToken, googleIdToken) ||
                other.googleIdToken == googleIdToken) &&
            (identical(other.setNewPassword, setNewPassword) ||
                other.setNewPassword == setNewPassword) &&
            (identical(other.getUserInfo, getUserInfo) ||
                other.getUserInfo == getUserInfo) &&
            (identical(other.vpnConfigurations, vpnConfigurations) ||
                other.vpnConfigurations == vpnConfigurations) &&
            (identical(other.getUserInfoRegion, getUserInfoRegion) ||
                other.getUserInfoRegion == getUserInfoRegion) &&
            (identical(other.pushLogs, pushLogs) ||
                other.pushLogs == pushLogs) &&
            (identical(other.getAppConfig, getAppConfig) ||
                other.getAppConfig == getAppConfig) &&
            (identical(other.facebookAuth, facebookAuth) ||
                other.facebookAuth == facebookAuth) &&
            (identical(other.appleIdToken, appleIdToken) ||
                other.appleIdToken == appleIdToken) &&
            (identical(other.forgotPassword, forgotPassword) ||
                other.forgotPassword == forgotPassword) &&
            (identical(other.agreements, agreements) ||
                other.agreements == agreements) &&
            (identical(other.consents, consents) ||
                other.consents == consents) &&
            (identical(other.appVersion, appVersion) ||
                other.appVersion == appVersion) &&
            (identical(other.appConfig, appConfig) ||
                other.appConfig == appConfig) &&
            (identical(other.authSuccessRedirect, authSuccessRedirect) ||
                other.authSuccessRedirect == authSuccessRedirect));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    initialize,
    login,
    registerWithPassword,
    verifyCode,
    googleAuth,
    googleAuthToken,
    googleIdToken,
    setNewPassword,
    getUserInfo,
    vpnConfigurations,
    getUserInfoRegion,
    pushLogs,
    getAppConfig,
    facebookAuth,
    appleIdToken,
    forgotPassword,
    agreements,
    consents,
    appVersion,
    appConfig,
    authSuccessRedirect,
  ]);

  /// Create a copy of ApiEndpoints
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApiEndpointsImplCopyWith<_$ApiEndpointsImpl> get copyWith =>
      __$$ApiEndpointsImplCopyWithImpl<_$ApiEndpointsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApiEndpointsImplToJson(this);
  }
}

abstract class _ApiEndpoints implements ApiEndpoints {
  const factory _ApiEndpoints({
    required final String initialize,
    required final String login,
    required final String registerWithPassword,
    required final String verifyCode,
    required final String googleAuth,
    required final String googleAuthToken,
    required final String googleIdToken,
    required final String setNewPassword,
    required final String getUserInfo,
    required final String vpnConfigurations,
    required final String getUserInfoRegion,
    required final String pushLogs,
    required final String getAppConfig,
    required final String facebookAuth,
    required final String appleIdToken,
    required final String forgotPassword,
    required final String agreements,
    required final String consents,
    required final String appVersion,
    required final String appConfig,
    required final String authSuccessRedirect,
  }) = _$ApiEndpointsImpl;

  factory _ApiEndpoints.fromJson(Map<String, dynamic> json) =
      _$ApiEndpointsImpl.fromJson;

  @override
  String get initialize;
  @override
  String get login;
  @override
  String get registerWithPassword;
  @override
  String get verifyCode;
  @override
  String get googleAuth;
  @override
  String get googleAuthToken;
  @override
  String get googleIdToken;
  @override
  String get setNewPassword;
  @override
  String get getUserInfo;
  @override
  String get vpnConfigurations;
  @override
  String get getUserInfoRegion;
  @override
  String get pushLogs;
  @override
  String get getAppConfig;
  @override
  String get facebookAuth;
  @override
  String get appleIdToken;
  @override
  String get forgotPassword;
  @override
  String get agreements;
  @override
  String get consents;
  @override
  String get appVersion;
  @override
  String get appConfig;
  @override
  String get authSuccessRedirect;

  /// Create a copy of ApiEndpoints
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApiEndpointsImplCopyWith<_$ApiEndpointsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
