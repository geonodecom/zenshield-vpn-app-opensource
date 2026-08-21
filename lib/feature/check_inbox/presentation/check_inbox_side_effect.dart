sealed class CheckInboxSideEffect {
  const CheckInboxSideEffect();
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
