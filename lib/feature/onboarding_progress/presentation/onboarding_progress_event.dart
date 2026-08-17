part of 'onboarding_progress_bloc.dart';

sealed class OnboardingProgressEvent {
  const OnboardingProgressEvent();

  List<Object?> get props => [];
}

class LoadAgreementsEvent extends OnboardingProgressEvent {
  const LoadAgreementsEvent();
}

class FinalNextButtonTappedEvent extends OnboardingProgressEvent {}

class ModalAgreeButtonTappedEvent extends OnboardingProgressEvent {}

/// User tapped "Not now" on the bandwidth-sharing consent prompt (either the
/// first-time onboarding flow or a later re-prompt).
class BandwidthSharingDeclinedEvent extends OnboardingProgressEvent {}

class OpenPrivacyPolicyEvent extends OnboardingProgressEvent {
  const OpenPrivacyPolicyEvent(this.languageCode);

  final String languageCode;

  @override
  List<Object> get props => [languageCode];
}

class OpenTermsOfServiceEvent extends OnboardingProgressEvent {
  const OpenTermsOfServiceEvent(this.languageCode);

  final String languageCode;

  @override
  List<Object> get props => [languageCode];
}

class OpenEulaEvent extends OnboardingProgressEvent {
  const OpenEulaEvent(this.languageCode);

  final String languageCode;

  @override
  List<Object> get props => [languageCode];
}

class OpenBandwidthSharingPolicyEvent extends OnboardingProgressEvent {
  const OpenBandwidthSharingPolicyEvent(this.languageCode);

  final String languageCode;

  @override
  List<Object> get props => [languageCode];
}

class LogoutTappedEvent extends OnboardingProgressEvent {
  const LogoutTappedEvent();
}
