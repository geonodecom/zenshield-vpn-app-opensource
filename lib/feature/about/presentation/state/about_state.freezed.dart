// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'about_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AboutState {
  String get appVersion => throw _privateConstructorUsedError;
  int get versionTapCount => throw _privateConstructorUsedError;

  /// Create a copy of AboutState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AboutStateCopyWith<AboutState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AboutStateCopyWith<$Res> {
  factory $AboutStateCopyWith(
    AboutState value,
    $Res Function(AboutState) then,
  ) = _$AboutStateCopyWithImpl<$Res, AboutState>;
  @useResult
  $Res call({String appVersion, int versionTapCount});
}

/// @nodoc
class _$AboutStateCopyWithImpl<$Res, $Val extends AboutState>
    implements $AboutStateCopyWith<$Res> {
  _$AboutStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AboutState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? appVersion = null, Object? versionTapCount = null}) {
    return _then(
      _value.copyWith(
            appVersion: null == appVersion
                ? _value.appVersion
                : appVersion // ignore: cast_nullable_to_non_nullable
                      as String,
            versionTapCount: null == versionTapCount
                ? _value.versionTapCount
                : versionTapCount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AboutStateImplCopyWith<$Res>
    implements $AboutStateCopyWith<$Res> {
  factory _$$AboutStateImplCopyWith(
    _$AboutStateImpl value,
    $Res Function(_$AboutStateImpl) then,
  ) = __$$AboutStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String appVersion, int versionTapCount});
}

/// @nodoc
class __$$AboutStateImplCopyWithImpl<$Res>
    extends _$AboutStateCopyWithImpl<$Res, _$AboutStateImpl>
    implements _$$AboutStateImplCopyWith<$Res> {
  __$$AboutStateImplCopyWithImpl(
    _$AboutStateImpl _value,
    $Res Function(_$AboutStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AboutState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? appVersion = null, Object? versionTapCount = null}) {
    return _then(
      _$AboutStateImpl(
        appVersion: null == appVersion
            ? _value.appVersion
            : appVersion // ignore: cast_nullable_to_non_nullable
                  as String,
        versionTapCount: null == versionTapCount
            ? _value.versionTapCount
            : versionTapCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$AboutStateImpl implements _AboutState {
  const _$AboutStateImpl({required this.appVersion, this.versionTapCount = 0});

  @override
  final String appVersion;
  @override
  @JsonKey()
  final int versionTapCount;

  @override
  String toString() {
    return 'AboutState(appVersion: $appVersion, versionTapCount: $versionTapCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AboutStateImpl &&
            (identical(other.appVersion, appVersion) ||
                other.appVersion == appVersion) &&
            (identical(other.versionTapCount, versionTapCount) ||
                other.versionTapCount == versionTapCount));
  }

  @override
  int get hashCode => Object.hash(runtimeType, appVersion, versionTapCount);

  /// Create a copy of AboutState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AboutStateImplCopyWith<_$AboutStateImpl> get copyWith =>
      __$$AboutStateImplCopyWithImpl<_$AboutStateImpl>(this, _$identity);
}

abstract class _AboutState implements AboutState {
  const factory _AboutState({
    required final String appVersion,
    final int versionTapCount,
  }) = _$AboutStateImpl;

  @override
  String get appVersion;
  @override
  int get versionTapCount;

  /// Create a copy of AboutState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AboutStateImplCopyWith<_$AboutStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
