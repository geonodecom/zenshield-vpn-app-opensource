// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) {
  return _UserInfo.fromJson(json);
}

/// @nodoc
mixin _$UserInfo {
  String get id => throw _privateConstructorUsedError;
  String get ip => throw _privateConstructorUsedError;
  AccountStatus get status => throw _privateConstructorUsedError;
  RegionResponse get region => throw _privateConstructorUsedError;
  double get availableTraffic => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  @JsonKey(name: 'secured_since')
  DateTime? get securedSince => throw _privateConstructorUsedError;

  /// Serializes this UserInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserInfoCopyWith<UserInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserInfoCopyWith<$Res> {
  factory $UserInfoCopyWith(UserInfo value, $Res Function(UserInfo) then) =
      _$UserInfoCopyWithImpl<$Res, UserInfo>;
  @useResult
  $Res call({
    String id,
    String ip,
    AccountStatus status,
    RegionResponse region,
    double availableTraffic,
    String? email,
    @JsonKey(name: 'secured_since') DateTime? securedSince,
  });

  $RegionResponseCopyWith<$Res> get region;
}

/// @nodoc
class _$UserInfoCopyWithImpl<$Res, $Val extends UserInfo>
    implements $UserInfoCopyWith<$Res> {
  _$UserInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ip = null,
    Object? status = null,
    Object? region = null,
    Object? availableTraffic = null,
    Object? email = freezed,
    Object? securedSince = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            ip: null == ip
                ? _value.ip
                : ip // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as AccountStatus,
            region: null == region
                ? _value.region
                : region // ignore: cast_nullable_to_non_nullable
                      as RegionResponse,
            availableTraffic: null == availableTraffic
                ? _value.availableTraffic
                : availableTraffic // ignore: cast_nullable_to_non_nullable
                      as double,
            email: freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String?,
            securedSince: freezed == securedSince
                ? _value.securedSince
                : securedSince // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }

  /// Create a copy of UserInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RegionResponseCopyWith<$Res> get region {
    return $RegionResponseCopyWith<$Res>(_value.region, (value) {
      return _then(_value.copyWith(region: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserInfoImplCopyWith<$Res>
    implements $UserInfoCopyWith<$Res> {
  factory _$$UserInfoImplCopyWith(
    _$UserInfoImpl value,
    $Res Function(_$UserInfoImpl) then,
  ) = __$$UserInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String ip,
    AccountStatus status,
    RegionResponse region,
    double availableTraffic,
    String? email,
    @JsonKey(name: 'secured_since') DateTime? securedSince,
  });

  @override
  $RegionResponseCopyWith<$Res> get region;
}

/// @nodoc
class __$$UserInfoImplCopyWithImpl<$Res>
    extends _$UserInfoCopyWithImpl<$Res, _$UserInfoImpl>
    implements _$$UserInfoImplCopyWith<$Res> {
  __$$UserInfoImplCopyWithImpl(
    _$UserInfoImpl _value,
    $Res Function(_$UserInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ip = null,
    Object? status = null,
    Object? region = null,
    Object? availableTraffic = null,
    Object? email = freezed,
    Object? securedSince = freezed,
  }) {
    return _then(
      _$UserInfoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        ip: null == ip
            ? _value.ip
            : ip // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as AccountStatus,
        region: null == region
            ? _value.region
            : region // ignore: cast_nullable_to_non_nullable
                  as RegionResponse,
        availableTraffic: null == availableTraffic
            ? _value.availableTraffic
            : availableTraffic // ignore: cast_nullable_to_non_nullable
                  as double,
        email: freezed == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String?,
        securedSince: freezed == securedSince
            ? _value.securedSince
            : securedSince // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserInfoImpl implements _UserInfo {
  const _$UserInfoImpl({
    required this.id,
    required this.ip,
    required this.status,
    required this.region,
    required this.availableTraffic,
    this.email,
    @JsonKey(name: 'secured_since') this.securedSince,
  });

  factory _$UserInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserInfoImplFromJson(json);

  @override
  final String id;
  @override
  final String ip;
  @override
  final AccountStatus status;
  @override
  final RegionResponse region;
  @override
  final double availableTraffic;
  @override
  final String? email;
  @override
  @JsonKey(name: 'secured_since')
  final DateTime? securedSince;

  @override
  String toString() {
    return 'UserInfo(id: $id, ip: $ip, status: $status, region: $region, availableTraffic: $availableTraffic, email: $email, securedSince: $securedSince)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.ip, ip) || other.ip == ip) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.region, region) || other.region == region) &&
            (identical(other.availableTraffic, availableTraffic) ||
                other.availableTraffic == availableTraffic) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.securedSince, securedSince) ||
                other.securedSince == securedSince));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    ip,
    status,
    region,
    availableTraffic,
    email,
    securedSince,
  );

  /// Create a copy of UserInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserInfoImplCopyWith<_$UserInfoImpl> get copyWith =>
      __$$UserInfoImplCopyWithImpl<_$UserInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserInfoImplToJson(this);
  }
}

abstract class _UserInfo implements UserInfo {
  const factory _UserInfo({
    required final String id,
    required final String ip,
    required final AccountStatus status,
    required final RegionResponse region,
    required final double availableTraffic,
    final String? email,
    @JsonKey(name: 'secured_since') final DateTime? securedSince,
  }) = _$UserInfoImpl;

  factory _UserInfo.fromJson(Map<String, dynamic> json) =
      _$UserInfoImpl.fromJson;

  @override
  String get id;
  @override
  String get ip;
  @override
  AccountStatus get status;
  @override
  RegionResponse get region;
  @override
  double get availableTraffic;
  @override
  String? get email;
  @override
  @JsonKey(name: 'secured_since')
  DateTime? get securedSince;

  /// Create a copy of UserInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserInfoImplCopyWith<_$UserInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
