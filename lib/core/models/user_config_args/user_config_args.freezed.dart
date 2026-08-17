// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_config_args.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$UserConfigArgs {
  UserVpnConfiguration? get config => throw _privateConstructorUsedError;
  bool get isSelectedConfig => throw _privateConstructorUsedError;

  /// Create a copy of UserConfigArgs
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserConfigArgsCopyWith<UserConfigArgs> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserConfigArgsCopyWith<$Res> {
  factory $UserConfigArgsCopyWith(
    UserConfigArgs value,
    $Res Function(UserConfigArgs) then,
  ) = _$UserConfigArgsCopyWithImpl<$Res, UserConfigArgs>;
  @useResult
  $Res call({UserVpnConfiguration? config, bool isSelectedConfig});
}

/// @nodoc
class _$UserConfigArgsCopyWithImpl<$Res, $Val extends UserConfigArgs>
    implements $UserConfigArgsCopyWith<$Res> {
  _$UserConfigArgsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserConfigArgs
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? config = freezed, Object? isSelectedConfig = null}) {
    return _then(
      _value.copyWith(
            config: freezed == config
                ? _value.config
                : config // ignore: cast_nullable_to_non_nullable
                      as UserVpnConfiguration?,
            isSelectedConfig: null == isSelectedConfig
                ? _value.isSelectedConfig
                : isSelectedConfig // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserConfigArgsImplCopyWith<$Res>
    implements $UserConfigArgsCopyWith<$Res> {
  factory _$$UserConfigArgsImplCopyWith(
    _$UserConfigArgsImpl value,
    $Res Function(_$UserConfigArgsImpl) then,
  ) = __$$UserConfigArgsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({UserVpnConfiguration? config, bool isSelectedConfig});
}

/// @nodoc
class __$$UserConfigArgsImplCopyWithImpl<$Res>
    extends _$UserConfigArgsCopyWithImpl<$Res, _$UserConfigArgsImpl>
    implements _$$UserConfigArgsImplCopyWith<$Res> {
  __$$UserConfigArgsImplCopyWithImpl(
    _$UserConfigArgsImpl _value,
    $Res Function(_$UserConfigArgsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserConfigArgs
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? config = freezed, Object? isSelectedConfig = null}) {
    return _then(
      _$UserConfigArgsImpl(
        config: freezed == config
            ? _value.config
            : config // ignore: cast_nullable_to_non_nullable
                  as UserVpnConfiguration?,
        isSelectedConfig: null == isSelectedConfig
            ? _value.isSelectedConfig
            : isSelectedConfig // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$UserConfigArgsImpl implements _UserConfigArgs {
  const _$UserConfigArgsImpl({
    required this.config,
    required this.isSelectedConfig,
  });

  @override
  final UserVpnConfiguration? config;
  @override
  final bool isSelectedConfig;

  @override
  String toString() {
    return 'UserConfigArgs(config: $config, isSelectedConfig: $isSelectedConfig)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserConfigArgsImpl &&
            const DeepCollectionEquality().equals(other.config, config) &&
            (identical(other.isSelectedConfig, isSelectedConfig) ||
                other.isSelectedConfig == isSelectedConfig));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(config),
    isSelectedConfig,
  );

  /// Create a copy of UserConfigArgs
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserConfigArgsImplCopyWith<_$UserConfigArgsImpl> get copyWith =>
      __$$UserConfigArgsImplCopyWithImpl<_$UserConfigArgsImpl>(
        this,
        _$identity,
      );
}

abstract class _UserConfigArgs implements UserConfigArgs {
  const factory _UserConfigArgs({
    required final UserVpnConfiguration? config,
    required final bool isSelectedConfig,
  }) = _$UserConfigArgsImpl;

  @override
  UserVpnConfiguration? get config;
  @override
  bool get isSelectedConfig;

  /// Create a copy of UserConfigArgs
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserConfigArgsImplCopyWith<_$UserConfigArgsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
