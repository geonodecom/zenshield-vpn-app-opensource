sealed class NewPasswordEvent {}

class InitNewPassword extends NewPasswordEvent {}

class PasswordChanged extends NewPasswordEvent {
  PasswordChanged(this.password);
  final String password;
}

class ConfirmPasswordChanged extends NewPasswordEvent {
  ConfirmPasswordChanged(this.confirmPassword);
  final String confirmPassword;
}

class ChangePasswordRequested extends NewPasswordEvent {}
