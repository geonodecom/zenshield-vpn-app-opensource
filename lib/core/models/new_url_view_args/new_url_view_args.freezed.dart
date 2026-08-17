// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'new_url_view_args.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$NewUrlViewArgs {
  String? get name => throw _privateConstructorUsedError;
  String? get url => throw _privateConstructorUsedError;
  UrlsListViewType get urlType => throw _privateConstructorUsedError;

  /// Create a copy of NewUrlViewArgs
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NewUrlViewArgsCopyWith<NewUrlViewArgs> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NewUrlViewArgsCopyWith<$Res> {
  factory $NewUrlViewArgsCopyWith(
    NewUrlViewArgs value,
    $Res Function(NewUrlViewArgs) then,
  ) = _$NewUrlViewArgsCopyWithImpl<$Res, NewUrlViewArgs>;
  @useResult
  $Res call({String? name, String? url, UrlsListViewType urlType});
}

/// @nodoc
class _$NewUrlViewArgsCopyWithImpl<$Res, $Val extends NewUrlViewArgs>
    implements $NewUrlViewArgsCopyWith<$Res> {
  _$NewUrlViewArgsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NewUrlViewArgs
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? url = freezed,
    Object? urlType = null,
  }) {
    return _then(
      _value.copyWith(
            name: freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String?,
            url: freezed == url
                ? _value.url
                : url // ignore: cast_nullable_to_non_nullable
                      as String?,
            urlType: null == urlType
                ? _value.urlType
                : urlType // ignore: cast_nullable_to_non_nullable
                      as UrlsListViewType,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NewUrlViewArgsImplCopyWith<$Res>
    implements $NewUrlViewArgsCopyWith<$Res> {
  factory _$$NewUrlViewArgsImplCopyWith(
    _$NewUrlViewArgsImpl value,
    $Res Function(_$NewUrlViewArgsImpl) then,
  ) = __$$NewUrlViewArgsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? name, String? url, UrlsListViewType urlType});
}

/// @nodoc
class __$$NewUrlViewArgsImplCopyWithImpl<$Res>
    extends _$NewUrlViewArgsCopyWithImpl<$Res, _$NewUrlViewArgsImpl>
    implements _$$NewUrlViewArgsImplCopyWith<$Res> {
  __$$NewUrlViewArgsImplCopyWithImpl(
    _$NewUrlViewArgsImpl _value,
    $Res Function(_$NewUrlViewArgsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NewUrlViewArgs
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? url = freezed,
    Object? urlType = null,
  }) {
    return _then(
      _$NewUrlViewArgsImpl(
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        url: freezed == url
            ? _value.url
            : url // ignore: cast_nullable_to_non_nullable
                  as String?,
        urlType: null == urlType
            ? _value.urlType
            : urlType // ignore: cast_nullable_to_non_nullable
                  as UrlsListViewType,
      ),
    );
  }
}

/// @nodoc

class _$NewUrlViewArgsImpl implements _NewUrlViewArgs {
  const _$NewUrlViewArgsImpl({
    required this.name,
    required this.url,
    required this.urlType,
  });

  @override
  final String? name;
  @override
  final String? url;
  @override
  final UrlsListViewType urlType;

  @override
  String toString() {
    return 'NewUrlViewArgs(name: $name, url: $url, urlType: $urlType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NewUrlViewArgsImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.urlType, urlType) || other.urlType == urlType));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name, url, urlType);

  /// Create a copy of NewUrlViewArgs
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NewUrlViewArgsImplCopyWith<_$NewUrlViewArgsImpl> get copyWith =>
      __$$NewUrlViewArgsImplCopyWithImpl<_$NewUrlViewArgsImpl>(
        this,
        _$identity,
      );
}

abstract class _NewUrlViewArgs implements NewUrlViewArgs {
  const factory _NewUrlViewArgs({
    required final String? name,
    required final String? url,
    required final UrlsListViewType urlType,
  }) = _$NewUrlViewArgsImpl;

  @override
  String? get name;
  @override
  String? get url;
  @override
  UrlsListViewType get urlType;

  /// Create a copy of NewUrlViewArgs
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NewUrlViewArgsImplCopyWith<_$NewUrlViewArgsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
