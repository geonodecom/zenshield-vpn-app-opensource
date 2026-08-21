part of 'about_bloc.dart';

sealed class AboutEvent {
  const AboutEvent();

  List<Object> get props => [];
}

class OpenPrivacyPolicyEvent extends AboutEvent {
  const OpenPrivacyPolicyEvent(this.languageCode);

  final String languageCode;

  @override
  List<Object> get props => [languageCode];
}

class OpenTermsOfServiceEvent extends AboutEvent {
  const OpenTermsOfServiceEvent(this.languageCode);

  final String languageCode;

  @override
  List<Object> get props => [languageCode];
}

class OpenSupportCenterEvent extends AboutEvent {
  const OpenSupportCenterEvent(this.languageCode);

  final String languageCode;

  @override
  List<Object> get props => [languageCode];
}

class OpenEulaEvent extends AboutEvent {
  const OpenEulaEvent(this.languageCode);

  final String languageCode;

  @override
  List<Object> get props => [languageCode];
}

class OpenEmailEvent extends AboutEvent {
  const OpenEmailEvent();

  @override
  List<Object> get props => [];
}

class InitialLoadEvent extends AboutEvent {
  const InitialLoadEvent();

  @override
  List<Object> get props => [];
}

class VersionTappedEvent extends AboutEvent {
  const VersionTappedEvent();

  @override
  List<Object> get props => [];
}
