import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zenshield/feature/agreements/data/model/agreement.dart';

part 'onboarding_progress_state.freezed.dart';

@freezed
class OnboardingProgressState with _$OnboardingProgressState {
  const factory OnboardingProgressState({
    required int currentPage,
    Agreement? currentAgreement,
    @Default(false) bool isLoadingAgreements,
    @Default(false) bool isSendingConsent,
    @Default(false) bool showOnlyBandwidthSharingPolicy,
  }) = _OnboardingProgressState;

  factory OnboardingProgressState.initial() {
    return const OnboardingProgressState(
      currentPage: 0,
      currentAgreement: null,
      isLoadingAgreements: false,
      isSendingConsent: false,
      showOnlyBandwidthSharingPolicy: false,
    );
  }
}
