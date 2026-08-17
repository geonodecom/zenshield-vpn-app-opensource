// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'region_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RegionResponse _$RegionResponseFromJson(Map<String, dynamic> json) {
  return _RegionResponse.fromJson(json);
}

/// @nodoc
mixin _$RegionResponse {
  String get countryCode => throw _privateConstructorUsedError;
  String get flagImage => throw _privateConstructorUsedError;

  /// Serializes this RegionResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RegionResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RegionResponseCopyWith<RegionResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegionResponseCopyWith<$Res> {
  factory $RegionResponseCopyWith(
    RegionResponse value,
    $Res Function(RegionResponse) then,
  ) = _$RegionResponseCopyWithImpl<$Res, RegionResponse>;
  @useResult
  $Res call({String countryCode, String flagImage});
}

/// @nodoc
class _$RegionResponseCopyWithImpl<$Res, $Val extends RegionResponse>
    implements $RegionResponseCopyWith<$Res> {
  _$RegionResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RegionResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? countryCode = null, Object? flagImage = null}) {
    return _then(
      _value.copyWith(
            countryCode: null == countryCode
                ? _value.countryCode
                : countryCode // ignore: cast_nullable_to_non_nullable
                      as String,
            flagImage: null == flagImage
                ? _value.flagImage
                : flagImage // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RegionResponseImplCopyWith<$Res>
    implements $RegionResponseCopyWith<$Res> {
  factory _$$RegionResponseImplCopyWith(
    _$RegionResponseImpl value,
    $Res Function(_$RegionResponseImpl) then,
  ) = __$$RegionResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String countryCode, String flagImage});
}

/// @nodoc
class __$$RegionResponseImplCopyWithImpl<$Res>
    extends _$RegionResponseCopyWithImpl<$Res, _$RegionResponseImpl>
    implements _$$RegionResponseImplCopyWith<$Res> {
  __$$RegionResponseImplCopyWithImpl(
    _$RegionResponseImpl _value,
    $Res Function(_$RegionResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RegionResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? countryCode = null, Object? flagImage = null}) {
    return _then(
      _$RegionResponseImpl(
        countryCode: null == countryCode
            ? _value.countryCode
            : countryCode // ignore: cast_nullable_to_non_nullable
                  as String,
        flagImage: null == flagImage
            ? _value.flagImage
            : flagImage // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RegionResponseImpl implements _RegionResponse {
  const _$RegionResponseImpl({
    required this.countryCode,
    required this.flagImage,
  });

  factory _$RegionResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$RegionResponseImplFromJson(json);

  @override
  final String countryCode;
  @override
  final String flagImage;

  @override
  String toString() {
    return 'RegionResponse(countryCode: $countryCode, flagImage: $flagImage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegionResponseImpl &&
            (identical(other.countryCode, countryCode) ||
                other.countryCode == countryCode) &&
            (identical(other.flagImage, flagImage) ||
                other.flagImage == flagImage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, countryCode, flagImage);

  /// Create a copy of RegionResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RegionResponseImplCopyWith<_$RegionResponseImpl> get copyWith =>
      __$$RegionResponseImplCopyWithImpl<_$RegionResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RegionResponseImplToJson(this);
  }
}

abstract class _RegionResponse implements RegionResponse {
  const factory _RegionResponse({
    required final String countryCode,
    required final String flagImage,
  }) = _$RegionResponseImpl;

  factory _RegionResponse.fromJson(Map<String, dynamic> json) =
      _$RegionResponseImpl.fromJson;

  @override
  String get countryCode;
  @override
  String get flagImage;

  /// Create a copy of RegionResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RegionResponseImplCopyWith<_$RegionResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
