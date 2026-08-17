// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_progress_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$OnboardingProgressState {
  int get currentPage => throw _privateConstructorUsedError;
  Agreement? get currentAgreement => throw _privateConstructorUsedError;
  bool get isLoadingAgreements => throw _privateConstructorUsedError;
  bool get isSendingConsent => throw _privateConstructorUsedError;
  bool get showOnlyBandwidthSharingPolicy => throw _privateConstructorUsedError;

  /// Create a copy of OnboardingProgressState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OnboardingProgressStateCopyWith<OnboardingProgressState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OnboardingProgressStateCopyWith<$Res> {
  factory $OnboardingProgressStateCopyWith(
    OnboardingProgressState value,
    $Res Function(OnboardingProgressState) then,
  ) = _$OnboardingProgressStateCopyWithImpl<$Res, OnboardingProgressState>;
  @useResult
  $Res call({
    int currentPage,
    Agreement? currentAgreement,
    bool isLoadingAgreements,
    bool isSendingConsent,
    bool showOnlyBandwidthSharingPolicy,
  });
}

/// @nodoc
class _$OnboardingProgressStateCopyWithImpl<
  $Res,
  $Val extends OnboardingProgressState
>
    implements $OnboardingProgressStateCopyWith<$Res> {
  _$OnboardingProgressStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OnboardingProgressState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentPage = null,
    Object? currentAgreement = freezed,
    Object? isLoadingAgreements = null,
    Object? isSendingConsent = null,
    Object? showOnlyBandwidthSharingPolicy = null,
  }) {
    return _then(
      _value.copyWith(
            currentPage: null == currentPage
                ? _value.currentPage
                : currentPage // ignore: cast_nullable_to_non_nullable
                      as int,
            currentAgreement: freezed == currentAgreement
                ? _value.currentAgreement
                : currentAgreement // ignore: cast_nullable_to_non_nullable
                      as Agreement?,
            isLoadingAgreements: null == isLoadingAgreements
                ? _value.isLoadingAgreements
                : isLoadingAgreements // ignore: cast_nullable_to_non_nullable
                      as bool,
            isSendingConsent: null == isSendingConsent
                ? _value.isSendingConsent
                : isSendingConsent // ignore: cast_nullable_to_non_nullable
                      as bool,
            showOnlyBandwidthSharingPolicy:
                null == showOnlyBandwidthSharingPolicy
                ? _value.showOnlyBandwidthSharingPolicy
                : showOnlyBandwidthSharingPolicy // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OnboardingProgressStateImplCopyWith<$Res>
    implements $OnboardingProgressStateCopyWith<$Res> {
  factory _$$OnboardingProgressStateImplCopyWith(
    _$OnboardingProgressStateImpl value,
    $Res Function(_$OnboardingProgressStateImpl) then,
  ) = __$$OnboardingProgressStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int currentPage,
    Agreement? currentAgreement,
    bool isLoadingAgreements,
    bool isSendingConsent,
    bool showOnlyBandwidthSharingPolicy,
  });
}

/// @nodoc
class __$$OnboardingProgressStateImplCopyWithImpl<$Res>
    extends
        _$OnboardingProgressStateCopyWithImpl<
          $Res,
          _$OnboardingProgressStateImpl
        >
    implements _$$OnboardingProgressStateImplCopyWith<$Res> {
  __$$OnboardingProgressStateImplCopyWithImpl(
    _$OnboardingProgressStateImpl _value,
    $Res Function(_$OnboardingProgressStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OnboardingProgressState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentPage = null,
    Object? currentAgreement = freezed,
    Object? isLoadingAgreements = null,
    Object? isSendingConsent = null,
    Object? showOnlyBandwidthSharingPolicy = null,
  }) {
    return _then(
      _$OnboardingProgressStateImpl(
        currentPage: null == currentPage
            ? _value.currentPage
            : currentPage // ignore: cast_nullable_to_non_nullable
                  as int,
        currentAgreement: freezed == currentAgreement
            ? _value.currentAgreement
            : currentAgreement // ignore: cast_nullable_to_non_nullable
                  as Agreement?,
        isLoadingAgreements: null == isLoadingAgreements
            ? _value.isLoadingAgreements
            : isLoadingAgreements // ignore: cast_nullable_to_non_nullable
                  as bool,
        isSendingConsent: null == isSendingConsent
            ? _value.isSendingConsent
            : isSendingConsent // ignore: cast_nullable_to_non_nullable
                  as bool,
        showOnlyBandwidthSharingPolicy: null == showOnlyBandwidthSharingPolicy
            ? _value.showOnlyBandwidthSharingPolicy
            : showOnlyBandwidthSharingPolicy // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$OnboardingProgressStateImpl implements _OnboardingProgressState {
  const _$OnboardingProgressStateImpl({
    required this.currentPage,
    this.currentAgreement,
    this.isLoadingAgreements = false,
    this.isSendingConsent = false,
    this.showOnlyBandwidthSharingPolicy = false,
  });

  @override
  final int currentPage;
  @override
  final Agreement? currentAgreement;
  @override
  @JsonKey()
  final bool isLoadingAgreements;
  @override
  @JsonKey()
  final bool isSendingConsent;
  @override
  @JsonKey()
  final bool showOnlyBandwidthSharingPolicy;

  @override
  String toString() {
    return 'OnboardingProgressState(currentPage: $currentPage, currentAgreement: $currentAgreement, isLoadingAgreements: $isLoadingAgreements, isSendingConsent: $isSendingConsent, showOnlyBandwidthSharingPolicy: $showOnlyBandwidthSharingPolicy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnboardingProgressStateImpl &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.currentAgreement, currentAgreement) ||
                other.currentAgreement == currentAgreement) &&
            (identical(other.isLoadingAgreements, isLoadingAgreements) ||
                other.isLoadingAgreements == isLoadingAgreements) &&
            (identical(other.isSendingConsent, isSendingConsent) ||
                other.isSendingConsent == isSendingConsent) &&
            (identical(
                  other.showOnlyBandwidthSharingPolicy,
                  showOnlyBandwidthSharingPolicy,
                ) ||
                other.showOnlyBandwidthSharingPolicy ==
                    showOnlyBandwidthSharingPolicy));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    currentPage,
    currentAgreement,
    isLoadingAgreements,
    isSendingConsent,
    showOnlyBandwidthSharingPolicy,
  );

  /// Create a copy of OnboardingProgressState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OnboardingProgressStateImplCopyWith<_$OnboardingProgressStateImpl>
  get copyWith =>
      __$$OnboardingProgressStateImplCopyWithImpl<
        _$OnboardingProgressStateImpl
      >(this, _$identity);
}

abstract class _OnboardingProgressState implements OnboardingProgressState {
  const factory _OnboardingProgressState({
    required final int currentPage,
    final Agreement? currentAgreement,
    final bool isLoadingAgreements,
    final bool isSendingConsent,
    final bool showOnlyBandwidthSharingPolicy,
  }) = _$OnboardingProgressStateImpl;

  @override
  int get currentPage;
  @override
  Agreement? get currentAgreement;
  @override
  bool get isLoadingAgreements;
  @override
  bool get isSendingConsent;
  @override
  bool get showOnlyBandwidthSharingPolicy;

  /// Create a copy of OnboardingProgressState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OnboardingProgressStateImplCopyWith<_$OnboardingProgressStateImpl>
  get copyWith => throw _privateConstructorUsedError;
}
