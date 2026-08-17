// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feedback_view_args.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$FeedbackViewArgs {
  bool get isFromError => throw _privateConstructorUsedError;
  String get previousRouteName => throw _privateConstructorUsedError;

  /// Create a copy of FeedbackViewArgs
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FeedbackViewArgsCopyWith<FeedbackViewArgs> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedbackViewArgsCopyWith<$Res> {
  factory $FeedbackViewArgsCopyWith(
    FeedbackViewArgs value,
    $Res Function(FeedbackViewArgs) then,
  ) = _$FeedbackViewArgsCopyWithImpl<$Res, FeedbackViewArgs>;
  @useResult
  $Res call({bool isFromError, String previousRouteName});
}

/// @nodoc
class _$FeedbackViewArgsCopyWithImpl<$Res, $Val extends FeedbackViewArgs>
    implements $FeedbackViewArgsCopyWith<$Res> {
  _$FeedbackViewArgsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FeedbackViewArgs
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? isFromError = null, Object? previousRouteName = null}) {
    return _then(
      _value.copyWith(
            isFromError: null == isFromError
                ? _value.isFromError
                : isFromError // ignore: cast_nullable_to_non_nullable
                      as bool,
            previousRouteName: null == previousRouteName
                ? _value.previousRouteName
                : previousRouteName // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FeedbackViewArgsImplCopyWith<$Res>
    implements $FeedbackViewArgsCopyWith<$Res> {
  factory _$$FeedbackViewArgsImplCopyWith(
    _$FeedbackViewArgsImpl value,
    $Res Function(_$FeedbackViewArgsImpl) then,
  ) = __$$FeedbackViewArgsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isFromError, String previousRouteName});
}

/// @nodoc
class __$$FeedbackViewArgsImplCopyWithImpl<$Res>
    extends _$FeedbackViewArgsCopyWithImpl<$Res, _$FeedbackViewArgsImpl>
    implements _$$FeedbackViewArgsImplCopyWith<$Res> {
  __$$FeedbackViewArgsImplCopyWithImpl(
    _$FeedbackViewArgsImpl _value,
    $Res Function(_$FeedbackViewArgsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FeedbackViewArgs
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? isFromError = null, Object? previousRouteName = null}) {
    return _then(
      _$FeedbackViewArgsImpl(
        isFromError: null == isFromError
            ? _value.isFromError
            : isFromError // ignore: cast_nullable_to_non_nullable
                  as bool,
        previousRouteName: null == previousRouteName
            ? _value.previousRouteName
            : previousRouteName // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$FeedbackViewArgsImpl implements _FeedbackViewArgs {
  const _$FeedbackViewArgsImpl({
    this.isFromError = false,
    this.previousRouteName = '',
  });

  @override
  @JsonKey()
  final bool isFromError;
  @override
  @JsonKey()
  final String previousRouteName;

  @override
  String toString() {
    return 'FeedbackViewArgs(isFromError: $isFromError, previousRouteName: $previousRouteName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeedbackViewArgsImpl &&
            (identical(other.isFromError, isFromError) ||
                other.isFromError == isFromError) &&
            (identical(other.previousRouteName, previousRouteName) ||
                other.previousRouteName == previousRouteName));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isFromError, previousRouteName);

  /// Create a copy of FeedbackViewArgs
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FeedbackViewArgsImplCopyWith<_$FeedbackViewArgsImpl> get copyWith =>
      __$$FeedbackViewArgsImplCopyWithImpl<_$FeedbackViewArgsImpl>(
        this,
        _$identity,
      );
}

abstract class _FeedbackViewArgs implements FeedbackViewArgs {
  const factory _FeedbackViewArgs({
    final bool isFromError,
    final String previousRouteName,
  }) = _$FeedbackViewArgsImpl;

  @override
  bool get isFromError;
  @override
  String get previousRouteName;

  /// Create a copy of FeedbackViewArgs
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FeedbackViewArgsImplCopyWith<_$FeedbackViewArgsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
