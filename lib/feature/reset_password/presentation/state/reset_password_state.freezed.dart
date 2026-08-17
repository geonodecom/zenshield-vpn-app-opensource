// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reset_password_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ResetPasswordState {
  String get email => throw _privateConstructorUsedError;
  bool get isEmailValid => throw _privateConstructorUsedError;
  bool get isButtonEnabled => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get showValidationErrors => throw _privateConstructorUsedError;

  /// Create a copy of ResetPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ResetPasswordStateCopyWith<ResetPasswordState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResetPasswordStateCopyWith<$Res> {
  factory $ResetPasswordStateCopyWith(
    ResetPasswordState value,
    $Res Function(ResetPasswordState) then,
  ) = _$ResetPasswordStateCopyWithImpl<$Res, ResetPasswordState>;
  @useResult
  $Res call({
    String email,
    bool isEmailValid,
    bool isButtonEnabled,
    bool isLoading,
    bool showValidationErrors,
  });
}

/// @nodoc
class _$ResetPasswordStateCopyWithImpl<$Res, $Val extends ResetPasswordState>
    implements $ResetPasswordStateCopyWith<$Res> {
  _$ResetPasswordStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ResetPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? isEmailValid = null,
    Object? isButtonEnabled = null,
    Object? isLoading = null,
    Object? showValidationErrors = null,
  }) {
    return _then(
      _value.copyWith(
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            isEmailValid: null == isEmailValid
                ? _value.isEmailValid
                : isEmailValid // ignore: cast_nullable_to_non_nullable
                      as bool,
            isButtonEnabled: null == isButtonEnabled
                ? _value.isButtonEnabled
                : isButtonEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            showValidationErrors: null == showValidationErrors
                ? _value.showValidationErrors
                : showValidationErrors // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ResetPasswordStateImplCopyWith<$Res>
    implements $ResetPasswordStateCopyWith<$Res> {
  factory _$$ResetPasswordStateImplCopyWith(
    _$ResetPasswordStateImpl value,
    $Res Function(_$ResetPasswordStateImpl) then,
  ) = __$$ResetPasswordStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String email,
    bool isEmailValid,
    bool isButtonEnabled,
    bool isLoading,
    bool showValidationErrors,
  });
}

/// @nodoc
class __$$ResetPasswordStateImplCopyWithImpl<$Res>
    extends _$ResetPasswordStateCopyWithImpl<$Res, _$ResetPasswordStateImpl>
    implements _$$ResetPasswordStateImplCopyWith<$Res> {
  __$$ResetPasswordStateImplCopyWithImpl(
    _$ResetPasswordStateImpl _value,
    $Res Function(_$ResetPasswordStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ResetPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? isEmailValid = null,
    Object? isButtonEnabled = null,
    Object? isLoading = null,
    Object? showValidationErrors = null,
  }) {
    return _then(
      _$ResetPasswordStateImpl(
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        isEmailValid: null == isEmailValid
            ? _value.isEmailValid
            : isEmailValid // ignore: cast_nullable_to_non_nullable
                  as bool,
        isButtonEnabled: null == isButtonEnabled
            ? _value.isButtonEnabled
            : isButtonEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        showValidationErrors: null == showValidationErrors
            ? _value.showValidationErrors
            : showValidationErrors // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$ResetPasswordStateImpl implements _ResetPasswordState {
  const _$ResetPasswordStateImpl({
    this.email = '',
    this.isEmailValid = false,
    this.isButtonEnabled = false,
    this.isLoading = false,
    this.showValidationErrors = false,
  });

  @override
  @JsonKey()
  final String email;
  @override
  @JsonKey()
  final bool isEmailValid;
  @override
  @JsonKey()
  final bool isButtonEnabled;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool showValidationErrors;

  @override
  String toString() {
    return 'ResetPasswordState(email: $email, isEmailValid: $isEmailValid, isButtonEnabled: $isButtonEnabled, isLoading: $isLoading, showValidationErrors: $showValidationErrors)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResetPasswordStateImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.isEmailValid, isEmailValid) ||
                other.isEmailValid == isEmailValid) &&
            (identical(other.isButtonEnabled, isButtonEnabled) ||
                other.isButtonEnabled == isButtonEnabled) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.showValidationErrors, showValidationErrors) ||
                other.showValidationErrors == showValidationErrors));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    email,
    isEmailValid,
    isButtonEnabled,
    isLoading,
    showValidationErrors,
  );

  /// Create a copy of ResetPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ResetPasswordStateImplCopyWith<_$ResetPasswordStateImpl> get copyWith =>
      __$$ResetPasswordStateImplCopyWithImpl<_$ResetPasswordStateImpl>(
        this,
        _$identity,
      );
}

abstract class _ResetPasswordState implements ResetPasswordState {
  const factory _ResetPasswordState({
    final String email,
    final bool isEmailValid,
    final bool isButtonEnabled,
    final bool isLoading,
    final bool showValidationErrors,
  }) = _$ResetPasswordStateImpl;

  @override
  String get email;
  @override
  bool get isEmailValid;
  @override
  bool get isButtonEnabled;
  @override
  bool get isLoading;
  @override
  bool get showValidationErrors;

  /// Create a copy of ResetPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ResetPasswordStateImplCopyWith<_$ResetPasswordStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
