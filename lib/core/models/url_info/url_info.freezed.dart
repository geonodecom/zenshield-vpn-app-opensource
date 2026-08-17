// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'url_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UrlInfo _$UrlInfoFromJson(Map<String, dynamic> json) {
  return _UrlInfo.fromJson(json);
}

/// @nodoc
mixin _$UrlInfo {
  String get url => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  bool get isUsersUrl => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

  /// Serializes this UrlInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UrlInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UrlInfoCopyWith<UrlInfo> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UrlInfoCopyWith<$Res> {
  factory $UrlInfoCopyWith(UrlInfo value, $Res Function(UrlInfo) then) =
      _$UrlInfoCopyWithImpl<$Res, UrlInfo>;
  @useResult
  $Res call({String url, String name, bool isUsersUrl, bool isActive});
}

/// @nodoc
class _$UrlInfoCopyWithImpl<$Res, $Val extends UrlInfo>
    implements $UrlInfoCopyWith<$Res> {
  _$UrlInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UrlInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? name = null,
    Object? isUsersUrl = null,
    Object? isActive = null,
  }) {
    return _then(
      _value.copyWith(
            url: null == url
                ? _value.url
                : url // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            isUsersUrl: null == isUsersUrl
                ? _value.isUsersUrl
                : isUsersUrl // ignore: cast_nullable_to_non_nullable
                      as bool,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UrlInfoImplCopyWith<$Res> implements $UrlInfoCopyWith<$Res> {
  factory _$$UrlInfoImplCopyWith(
    _$UrlInfoImpl value,
    $Res Function(_$UrlInfoImpl) then,
  ) = __$$UrlInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String url, String name, bool isUsersUrl, bool isActive});
}

/// @nodoc
class __$$UrlInfoImplCopyWithImpl<$Res>
    extends _$UrlInfoCopyWithImpl<$Res, _$UrlInfoImpl>
    implements _$$UrlInfoImplCopyWith<$Res> {
  __$$UrlInfoImplCopyWithImpl(
    _$UrlInfoImpl _value,
    $Res Function(_$UrlInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UrlInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? name = null,
    Object? isUsersUrl = null,
    Object? isActive = null,
  }) {
    return _then(
      _$UrlInfoImpl(
        url: null == url
            ? _value.url
            : url // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        isUsersUrl: null == isUsersUrl
            ? _value.isUsersUrl
            : isUsersUrl // ignore: cast_nullable_to_non_nullable
                  as bool,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UrlInfoImpl extends _UrlInfo {
  const _$UrlInfoImpl({
    required this.url,
    required this.name,
    this.isUsersUrl = false,
    this.isActive = false,
  }) : super._();

  factory _$UrlInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$UrlInfoImplFromJson(json);

  @override
  final String url;
  @override
  final String name;
  @override
  @JsonKey()
  final bool isUsersUrl;
  @override
  @JsonKey()
  final bool isActive;

  @override
  String toString() {
    return 'UrlInfo(url: $url, name: $name, isUsersUrl: $isUsersUrl, isActive: $isActive)';
  }

  /// Create a copy of UrlInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UrlInfoImplCopyWith<_$UrlInfoImpl> get copyWith =>
      __$$UrlInfoImplCopyWithImpl<_$UrlInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UrlInfoImplToJson(this);
  }
}

abstract class _UrlInfo extends UrlInfo {
  const factory _UrlInfo({
    required final String url,
    required final String name,
    final bool isUsersUrl,
    final bool isActive,
  }) = _$UrlInfoImpl;
  const _UrlInfo._() : super._();

  factory _UrlInfo.fromJson(Map<String, dynamic> json) = _$UrlInfoImpl.fromJson;

  @override
  String get url;
  @override
  String get name;
  @override
  bool get isUsersUrl;
  @override
  bool get isActive;

  /// Create a copy of UrlInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UrlInfoImplCopyWith<_$UrlInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
