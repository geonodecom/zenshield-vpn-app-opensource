sealed class ResetPasswordEvent {}

class EmailChanged extends ResetPasswordEvent {
  EmailChanged(this.email);
  final String email;
}

class ResetPasswordRequested extends ResetPasswordEvent {}
