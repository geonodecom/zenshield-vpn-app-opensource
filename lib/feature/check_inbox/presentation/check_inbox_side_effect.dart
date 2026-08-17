import 'package:zenshield/feature/agreements/data/model/agreements_response.dart';

sealed class CheckInboxSideEffect {
  const CheckInboxSideEffect();
}

class NavigateToOnboarding extends CheckInboxSideEffect {
  const NavigateToOnboarding({required this.agreementsResponse});
  final AgreementsResponse agreementsResponse;
}

class NavigateToNewPassword extends CheckInboxSideEffect {
  const NavigateToNewPassword();
}

class NavigateToHome extends CheckInboxSideEffect {
  const NavigateToHome();
}

class ShowSessionDataMissingError extends CheckInboxSideEffect {
  const ShowSessionDataMissingError();
}

class ShowUnknownActionError extends CheckInboxSideEffect {
  const ShowUnknownActionError();
}

class ShowMissingCodeParameterError extends CheckInboxSideEffect {
  const ShowMissingCodeParameterError();
}

class ShowVerificationError extends CheckInboxSideEffect {
  const ShowVerificationError();
}

class ShowWrongActionError extends CheckInboxSideEffect {
  const ShowWrongActionError();
}

class ShowEmailAppNotFound extends CheckInboxSideEffect {
  const ShowEmailAppNotFound();
}
