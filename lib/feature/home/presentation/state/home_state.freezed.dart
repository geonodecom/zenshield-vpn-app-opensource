// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$HomeState {
  String get timerValue => throw _privateConstructorUsedError;
  bool get showUpdateBanner => throw _privateConstructorUsedError;
  String? get updateVersion => throw _privateConstructorUsedError;
  bool get isUpdatePopupShowing => throw _privateConstructorUsedError;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HomeStateCopyWith<HomeState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeStateCopyWith<$Res> {
  factory $HomeStateCopyWith(HomeState value, $Res Function(HomeState) then) =
      _$HomeStateCopyWithImpl<$Res, HomeState>;
  @useResult
  $Res call({
    String timerValue,
    bool showUpdateBanner,
    String? updateVersion,
    bool isUpdatePopupShowing,
  });
}

/// @nodoc
class _$HomeStateCopyWithImpl<$Res, $Val extends HomeState>
    implements $HomeStateCopyWith<$Res> {
  _$HomeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timerValue = null,
    Object? showUpdateBanner = null,
    Object? updateVersion = freezed,
    Object? isUpdatePopupShowing = null,
  }) {
    return _then(
      _value.copyWith(
            timerValue: null == timerValue
                ? _value.timerValue
                : timerValue // ignore: cast_nullable_to_non_nullable
                      as String,
            showUpdateBanner: null == showUpdateBanner
                ? _value.showUpdateBanner
                : showUpdateBanner // ignore: cast_nullable_to_non_nullable
                      as bool,
            updateVersion: freezed == updateVersion
                ? _value.updateVersion
                : updateVersion // ignore: cast_nullable_to_non_nullable
                      as String?,
            isUpdatePopupShowing: null == isUpdatePopupShowing
                ? _value.isUpdatePopupShowing
                : isUpdatePopupShowing // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HomeStateImplCopyWith<$Res>
    implements $HomeStateCopyWith<$Res> {
  factory _$$HomeStateImplCopyWith(
    _$HomeStateImpl value,
    $Res Function(_$HomeStateImpl) then,
  ) = __$$HomeStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String timerValue,
    bool showUpdateBanner,
    String? updateVersion,
    bool isUpdatePopupShowing,
  });
}

/// @nodoc
class __$$HomeStateImplCopyWithImpl<$Res>
    extends _$HomeStateCopyWithImpl<$Res, _$HomeStateImpl>
    implements _$$HomeStateImplCopyWith<$Res> {
  __$$HomeStateImplCopyWithImpl(
    _$HomeStateImpl _value,
    $Res Function(_$HomeStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timerValue = null,
    Object? showUpdateBanner = null,
    Object? updateVersion = freezed,
    Object? isUpdatePopupShowing = null,
  }) {
    return _then(
      _$HomeStateImpl(
        timerValue: null == timerValue
            ? _value.timerValue
            : timerValue // ignore: cast_nullable_to_non_nullable
                  as String,
        showUpdateBanner: null == showUpdateBanner
            ? _value.showUpdateBanner
            : showUpdateBanner // ignore: cast_nullable_to_non_nullable
                  as bool,
        updateVersion: freezed == updateVersion
            ? _value.updateVersion
            : updateVersion // ignore: cast_nullable_to_non_nullable
                  as String?,
        isUpdatePopupShowing: null == isUpdatePopupShowing
            ? _value.isUpdatePopupShowing
            : isUpdatePopupShowing // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$HomeStateImpl implements _HomeState {
  const _$HomeStateImpl({
    required this.timerValue,
    this.showUpdateBanner = false,
    this.updateVersion,
    this.isUpdatePopupShowing = false,
  });

  @override
  final String timerValue;
  @override
  @JsonKey()
  final bool showUpdateBanner;
  @override
  final String? updateVersion;
  @override
  @JsonKey()
  final bool isUpdatePopupShowing;

  @override
  String toString() {
    return 'HomeState(timerValue: $timerValue, showUpdateBanner: $showUpdateBanner, updateVersion: $updateVersion, isUpdatePopupShowing: $isUpdatePopupShowing)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeStateImpl &&
            (identical(other.timerValue, timerValue) ||
                other.timerValue == timerValue) &&
            (identical(other.showUpdateBanner, showUpdateBanner) ||
                other.showUpdateBanner == showUpdateBanner) &&
            (identical(other.updateVersion, updateVersion) ||
                other.updateVersion == updateVersion) &&
            (identical(other.isUpdatePopupShowing, isUpdatePopupShowing) ||
                other.isUpdatePopupShowing == isUpdatePopupShowing));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    timerValue,
    showUpdateBanner,
    updateVersion,
    isUpdatePopupShowing,
  );

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeStateImplCopyWith<_$HomeStateImpl> get copyWith =>
      __$$HomeStateImplCopyWithImpl<_$HomeStateImpl>(this, _$identity);
}

abstract class _HomeState implements HomeState {
  const factory _HomeState({
    required final String timerValue,
    final bool showUpdateBanner,
    final String? updateVersion,
    final bool isUpdatePopupShowing,
  }) = _$HomeStateImpl;

  @override
  String get timerValue;
  @override
  bool get showUpdateBanner;
  @override
  String? get updateVersion;
  @override
  bool get isUpdatePopupShowing;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HomeStateImplCopyWith<_$HomeStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
