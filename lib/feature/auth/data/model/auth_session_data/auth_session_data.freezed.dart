// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_session_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AuthSessionData _$AuthSessionDataFromJson(Map<String, dynamic> json) {
  return _AuthSessionData.fromJson(json);
}

/// @nodoc
mixin _$AuthSessionData {
  String? get email => throw _privateConstructorUsedError;
  AuthType? get authType => throw _privateConstructorUsedError;
  String? get resetToken => throw _privateConstructorUsedError;

  /// Serializes this AuthSessionData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AuthSessionData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthSessionDataCopyWith<AuthSessionData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthSessionDataCopyWith<$Res> {
  factory $AuthSessionDataCopyWith(
    AuthSessionData value,
    $Res Function(AuthSessionData) then,
  ) = _$AuthSessionDataCopyWithImpl<$Res, AuthSessionData>;
  @useResult
  $Res call({String? email, AuthType? authType, String? resetToken});
}

/// @nodoc
class _$AuthSessionDataCopyWithImpl<$Res, $Val extends AuthSessionData>
    implements $AuthSessionDataCopyWith<$Res> {
  _$AuthSessionDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthSessionData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = freezed,
    Object? authType = freezed,
    Object? resetToken = freezed,
  }) {
    return _then(
      _value.copyWith(
            email: freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String?,
            authType: freezed == authType
                ? _value.authType
                : authType // ignore: cast_nullable_to_non_nullable
                      as AuthType?,
            resetToken: freezed == resetToken
                ? _value.resetToken
                : resetToken // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AuthSessionDataImplCopyWith<$Res>
    implements $AuthSessionDataCopyWith<$Res> {
  factory _$$AuthSessionDataImplCopyWith(
    _$AuthSessionDataImpl value,
    $Res Function(_$AuthSessionDataImpl) then,
  ) = __$$AuthSessionDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? email, AuthType? authType, String? resetToken});
}

/// @nodoc
class __$$AuthSessionDataImplCopyWithImpl<$Res>
    extends _$AuthSessionDataCopyWithImpl<$Res, _$AuthSessionDataImpl>
    implements _$$AuthSessionDataImplCopyWith<$Res> {
  __$$AuthSessionDataImplCopyWithImpl(
    _$AuthSessionDataImpl _value,
    $Res Function(_$AuthSessionDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthSessionData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = freezed,
    Object? authType = freezed,
    Object? resetToken = freezed,
  }) {
    return _then(
      _$AuthSessionDataImpl(
        email: freezed == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String?,
        authType: freezed == authType
            ? _value.authType
            : authType // ignore: cast_nullable_to_non_nullable
                  as AuthType?,
        resetToken: freezed == resetToken
            ? _value.resetToken
            : resetToken // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthSessionDataImpl extends _AuthSessionData {
  const _$AuthSessionDataImpl({this.email, this.authType, this.resetToken})
    : super._();

  factory _$AuthSessionDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthSessionDataImplFromJson(json);

  @override
  final String? email;
  @override
  final AuthType? authType;
  @override
  final String? resetToken;

  @override
  String toString() {
    return 'AuthSessionData(email: $email, authType: $authType, resetToken: $resetToken)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthSessionDataImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.authType, authType) ||
                other.authType == authType) &&
            (identical(other.resetToken, resetToken) ||
                other.resetToken == resetToken));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, email, authType, resetToken);

  /// Create a copy of AuthSessionData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthSessionDataImplCopyWith<_$AuthSessionDataImpl> get copyWith =>
      __$$AuthSessionDataImplCopyWithImpl<_$AuthSessionDataImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthSessionDataImplToJson(this);
  }
}

abstract class _AuthSessionData extends AuthSessionData {
  const factory _AuthSessionData({
    final String? email,
    final AuthType? authType,
    final String? resetToken,
  }) = _$AuthSessionDataImpl;
  const _AuthSessionData._() : super._();

  factory _AuthSessionData.fromJson(Map<String, dynamic> json) =
      _$AuthSessionDataImpl.fromJson;

  @override
  String? get email;
  @override
  AuthType? get authType;
  @override
  String? get resetToken;

  /// Create a copy of AuthSessionData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthSessionDataImplCopyWith<_$AuthSessionDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
