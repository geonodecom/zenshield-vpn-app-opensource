part of 'auth_bloc.dart';

sealed class AuthEvent {
  const AuthEvent();

  List<Object?> get props => [];
}

class AuthLoginButtonPressed extends AuthEvent {
  const AuthLoginButtonPressed({required this.email, required this.password});
  final String email;
  final String password;
}

class AuthSignUpButtonPressed extends AuthEvent {
  const AuthSignUpButtonPressed({
    required this.email,
    required this.password,
    required this.confirmPassword,
  });
  final String email;
  final String password;
  final String confirmPassword;
}

class AuthEmailChanged extends AuthEvent {
  const AuthEmailChanged(this.email);
  final String email;
}

class AuthPasswordChanged extends AuthEvent {
  const AuthPasswordChanged(this.password);
  final String password;
}

class AuthConfirmPasswordChanged extends AuthEvent {
  const AuthConfirmPasswordChanged(this.confirmPassword);
  final String confirmPassword;
}

class AuthBackButtonPressed extends AuthEvent {
  const AuthBackButtonPressed();
}

class AuthNavigateToSignUpPressed extends AuthEvent {
  const AuthNavigateToSignUpPressed();
}

class AuthNavigateToResetPasswordPressed extends AuthEvent {
  const AuthNavigateToResetPasswordPressed();
}

class AuthTermsOfUseDesktopTapped extends AuthEvent {
  const AuthTermsOfUseDesktopTapped({required this.languageCode});
  final String languageCode;
}

class AuthPrivacyPolicyDesktopTapped extends AuthEvent {
  const AuthPrivacyPolicyDesktopTapped({required this.languageCode});
  final String languageCode;
}

class AuthGoogleSignInPressed extends AuthEvent {
  const AuthGoogleSignInPressed();
}

class AuthFacebookSignInPressed extends AuthEvent {
  const AuthFacebookSignInPressed();
}

class AuthAppleSignInPressed extends AuthEvent {
  const AuthAppleSignInPressed();
}

class AuthTermsAcceptedChanged extends AuthEvent {
  const AuthTermsAcceptedChanged(this.isAccepted);
  final bool isAccepted;
}

class AuthBandwidthSharingPolicyTapped extends AuthEvent {
  const AuthBandwidthSharingPolicyTapped({required this.languageCode});
  final String languageCode;
}

class AuthDeepLinkErrorEvent extends AuthEvent {
  const AuthDeepLinkErrorEvent({required this.error});
  final DeepLinkError error;

  @override
  List<Object?> get props => [error];
}

class AuthEmailVerificationCodeReceivedEvent extends AuthEvent {
  const AuthEmailVerificationCodeReceivedEvent({required this.code});
  final String code;

  @override
  List<Object?> get props => [code];
}

class AuthForgotPasswordCodeReceivedEvent extends AuthEvent {
  const AuthForgotPasswordCodeReceivedEvent({required this.code});
  final String code;

  @override
  List<Object?> get props => [code];
}
