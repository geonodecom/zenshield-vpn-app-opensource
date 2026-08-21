sealed class AuthSideEffect {}

class AuthNavigateToHome extends AuthSideEffect {}

class AuthNavigateToSignUp extends AuthSideEffect {}

class AuthNavigateToResetPassword extends AuthSideEffect {}

class AuthNavigateToNewPassword extends AuthSideEffect {}

class AuthNavigateBack extends AuthSideEffect {}

class AuthShowInvalidEmailDialog extends AuthSideEffect {}

class ShowInvalidPasswordDialog extends AuthSideEffect {}

class AuthNavigateToDeeplinkVerification extends AuthSideEffect {
  AuthNavigateToDeeplinkVerification();
}

class ShowLoginErrorDialog extends AuthSideEffect {
  ShowLoginErrorDialog();
}

class ShowRegistrationErrorDialog extends AuthSideEffect {
  ShowRegistrationErrorDialog();
}

class ShowWrongCredentialsDialog extends AuthSideEffect {
  ShowWrongCredentialsDialog();
}

class ShowEmailEmploymentErrorDialog extends AuthSideEffect {
  ShowEmailEmploymentErrorDialog();
}

class ShowEmailNotConfirmedOrRegisteredErrorDialog extends AuthSideEffect {
  ShowEmailNotConfirmedOrRegisteredErrorDialog();
}

class AuthNavigateToCheckInbox extends AuthSideEffect {
  AuthNavigateToCheckInbox({required this.email});
  final String email;
}

class ShowDeepLinkSessionDataMissingError extends AuthSideEffect {
  ShowDeepLinkSessionDataMissingError();
}

class ShowDeepLinkUnknownActionError extends AuthSideEffect {
  ShowDeepLinkUnknownActionError();
}

class ShowDeepLinkMissingCodeParameterError extends AuthSideEffect {
  ShowDeepLinkMissingCodeParameterError();
}

class ShowDeepLinkVerificationError extends AuthSideEffect {
  ShowDeepLinkVerificationError();
}

class ShowDeepLinkWrongActionError extends AuthSideEffect {
  ShowDeepLinkWrongActionError();
}
