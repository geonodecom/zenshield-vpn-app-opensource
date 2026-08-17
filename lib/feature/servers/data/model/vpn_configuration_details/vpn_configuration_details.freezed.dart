// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vpn_configuration_details.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

VpnConfigurationDetails _$VpnConfigurationDetailsFromJson(
  Map<String, dynamic> json,
) {
  return _VpnConfigurationDetails.fromJson(json);
}

/// @nodoc
mixin _$VpnConfigurationDetails {
  String get url => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _protocolTypeFromJson, toJson: _protocolTypeToJson)
  ProtocolType get protocol => throw _privateConstructorUsedError;

  /// Serializes this VpnConfigurationDetails to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VpnConfigurationDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VpnConfigurationDetailsCopyWith<VpnConfigurationDetails> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VpnConfigurationDetailsCopyWith<$Res> {
  factory $VpnConfigurationDetailsCopyWith(
    VpnConfigurationDetails value,
    $Res Function(VpnConfigurationDetails) then,
  ) = _$VpnConfigurationDetailsCopyWithImpl<$Res, VpnConfigurationDetails>;
  @useResult
  $Res call({
    String url,
    @JsonKey(fromJson: _protocolTypeFromJson, toJson: _protocolTypeToJson)
    ProtocolType protocol,
  });
}

/// @nodoc
class _$VpnConfigurationDetailsCopyWithImpl<
  $Res,
  $Val extends VpnConfigurationDetails
>
    implements $VpnConfigurationDetailsCopyWith<$Res> {
  _$VpnConfigurationDetailsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VpnConfigurationDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? url = null, Object? protocol = null}) {
    return _then(
      _value.copyWith(
            url: null == url
                ? _value.url
                : url // ignore: cast_nullable_to_non_nullable
                      as String,
            protocol: null == protocol
                ? _value.protocol
                : protocol // ignore: cast_nullable_to_non_nullable
                      as ProtocolType,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VpnConfigurationDetailsImplCopyWith<$Res>
    implements $VpnConfigurationDetailsCopyWith<$Res> {
  factory _$$VpnConfigurationDetailsImplCopyWith(
    _$VpnConfigurationDetailsImpl value,
    $Res Function(_$VpnConfigurationDetailsImpl) then,
  ) = __$$VpnConfigurationDetailsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String url,
    @JsonKey(fromJson: _protocolTypeFromJson, toJson: _protocolTypeToJson)
    ProtocolType protocol,
  });
}

/// @nodoc
class __$$VpnConfigurationDetailsImplCopyWithImpl<$Res>
    extends
        _$VpnConfigurationDetailsCopyWithImpl<
          $Res,
          _$VpnConfigurationDetailsImpl
        >
    implements _$$VpnConfigurationDetailsImplCopyWith<$Res> {
  __$$VpnConfigurationDetailsImplCopyWithImpl(
    _$VpnConfigurationDetailsImpl _value,
    $Res Function(_$VpnConfigurationDetailsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VpnConfigurationDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? url = null, Object? protocol = null}) {
    return _then(
      _$VpnConfigurationDetailsImpl(
        url: null == url
            ? _value.url
            : url // ignore: cast_nullable_to_non_nullable
                  as String,
        protocol: null == protocol
            ? _value.protocol
            : protocol // ignore: cast_nullable_to_non_nullable
                  as ProtocolType,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VpnConfigurationDetailsImpl implements _VpnConfigurationDetails {
  const _$VpnConfigurationDetailsImpl({
    required this.url,
    @JsonKey(fromJson: _protocolTypeFromJson, toJson: _protocolTypeToJson)
    required this.protocol,
  });

  factory _$VpnConfigurationDetailsImpl.fromJson(Map<String, dynamic> json) =>
      _$$VpnConfigurationDetailsImplFromJson(json);

  @override
  final String url;
  @override
  @JsonKey(fromJson: _protocolTypeFromJson, toJson: _protocolTypeToJson)
  final ProtocolType protocol;

  @override
  String toString() {
    return 'VpnConfigurationDetails(url: $url, protocol: $protocol)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VpnConfigurationDetailsImpl &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.protocol, protocol) ||
                other.protocol == protocol));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, url, protocol);

  /// Create a copy of VpnConfigurationDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VpnConfigurationDetailsImplCopyWith<_$VpnConfigurationDetailsImpl>
  get copyWith =>
      __$$VpnConfigurationDetailsImplCopyWithImpl<
        _$VpnConfigurationDetailsImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VpnConfigurationDetailsImplToJson(this);
  }
}

abstract class _VpnConfigurationDetails implements VpnConfigurationDetails {
  const factory _VpnConfigurationDetails({
    required final String url,
    @JsonKey(fromJson: _protocolTypeFromJson, toJson: _protocolTypeToJson)
    required final ProtocolType protocol,
  }) = _$VpnConfigurationDetailsImpl;

  factory _VpnConfigurationDetails.fromJson(Map<String, dynamic> json) =
      _$VpnConfigurationDetailsImpl.fromJson;

  @override
  String get url;
  @override
  @JsonKey(fromJson: _protocolTypeFromJson, toJson: _protocolTypeToJson)
  ProtocolType get protocol;

  /// Create a copy of VpnConfigurationDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VpnConfigurationDetailsImplCopyWith<_$VpnConfigurationDetailsImpl>
  get copyWith => throw _privateConstructorUsedError;
}
