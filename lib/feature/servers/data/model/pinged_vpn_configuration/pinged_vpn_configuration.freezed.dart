// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pinged_vpn_configuration.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PingedVpnConfiguration _$PingedVpnConfigurationFromJson(
  Map<String, dynamic> json,
) {
  return _PingedVpnConfiguration.fromJson(json);
}

/// @nodoc
mixin _$PingedVpnConfiguration {
  VpnConfiguration get configuration => throw _privateConstructorUsedError;
  String? get ping => throw _privateConstructorUsedError;

  /// Serializes this PingedVpnConfiguration to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PingedVpnConfiguration
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PingedVpnConfigurationCopyWith<PingedVpnConfiguration> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PingedVpnConfigurationCopyWith<$Res> {
  factory $PingedVpnConfigurationCopyWith(
    PingedVpnConfiguration value,
    $Res Function(PingedVpnConfiguration) then,
  ) = _$PingedVpnConfigurationCopyWithImpl<$Res, PingedVpnConfiguration>;
  @useResult
  $Res call({VpnConfiguration configuration, String? ping});

  $VpnConfigurationCopyWith<$Res> get configuration;
}

/// @nodoc
class _$PingedVpnConfigurationCopyWithImpl<
  $Res,
  $Val extends PingedVpnConfiguration
>
    implements $PingedVpnConfigurationCopyWith<$Res> {
  _$PingedVpnConfigurationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PingedVpnConfiguration
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? configuration = null, Object? ping = freezed}) {
    return _then(
      _value.copyWith(
            configuration: null == configuration
                ? _value.configuration
                : configuration // ignore: cast_nullable_to_non_nullable
                      as VpnConfiguration,
            ping: freezed == ping
                ? _value.ping
                : ping // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of PingedVpnConfiguration
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VpnConfigurationCopyWith<$Res> get configuration {
    return $VpnConfigurationCopyWith<$Res>(_value.configuration, (value) {
      return _then(_value.copyWith(configuration: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PingedVpnConfigurationImplCopyWith<$Res>
    implements $PingedVpnConfigurationCopyWith<$Res> {
  factory _$$PingedVpnConfigurationImplCopyWith(
    _$PingedVpnConfigurationImpl value,
    $Res Function(_$PingedVpnConfigurationImpl) then,
  ) = __$$PingedVpnConfigurationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({VpnConfiguration configuration, String? ping});

  @override
  $VpnConfigurationCopyWith<$Res> get configuration;
}

/// @nodoc
class __$$PingedVpnConfigurationImplCopyWithImpl<$Res>
    extends
        _$PingedVpnConfigurationCopyWithImpl<$Res, _$PingedVpnConfigurationImpl>
    implements _$$PingedVpnConfigurationImplCopyWith<$Res> {
  __$$PingedVpnConfigurationImplCopyWithImpl(
    _$PingedVpnConfigurationImpl _value,
    $Res Function(_$PingedVpnConfigurationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PingedVpnConfiguration
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? configuration = null, Object? ping = freezed}) {
    return _then(
      _$PingedVpnConfigurationImpl(
        configuration: null == configuration
            ? _value.configuration
            : configuration // ignore: cast_nullable_to_non_nullable
                  as VpnConfiguration,
        ping: freezed == ping
            ? _value.ping
            : ping // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PingedVpnConfigurationImpl implements _PingedVpnConfiguration {
  const _$PingedVpnConfigurationImpl({required this.configuration, this.ping});

  factory _$PingedVpnConfigurationImpl.fromJson(Map<String, dynamic> json) =>
      _$$PingedVpnConfigurationImplFromJson(json);

  @override
  final VpnConfiguration configuration;
  @override
  final String? ping;

  @override
  String toString() {
    return 'PingedVpnConfiguration(configuration: $configuration, ping: $ping)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PingedVpnConfigurationImpl &&
            (identical(other.configuration, configuration) ||
                other.configuration == configuration) &&
            (identical(other.ping, ping) || other.ping == ping));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, configuration, ping);

  /// Create a copy of PingedVpnConfiguration
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PingedVpnConfigurationImplCopyWith<_$PingedVpnConfigurationImpl>
  get copyWith =>
      __$$PingedVpnConfigurationImplCopyWithImpl<_$PingedVpnConfigurationImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PingedVpnConfigurationImplToJson(this);
  }
}

abstract class _PingedVpnConfiguration implements PingedVpnConfiguration {
  const factory _PingedVpnConfiguration({
    required final VpnConfiguration configuration,
    final String? ping,
  }) = _$PingedVpnConfigurationImpl;

  factory _PingedVpnConfiguration.fromJson(Map<String, dynamic> json) =
      _$PingedVpnConfigurationImpl.fromJson;

  @override
  VpnConfiguration get configuration;
  @override
  String? get ping;

  /// Create a copy of PingedVpnConfiguration
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PingedVpnConfigurationImplCopyWith<_$PingedVpnConfigurationImpl>
  get copyWith => throw _privateConstructorUsedError;
}
