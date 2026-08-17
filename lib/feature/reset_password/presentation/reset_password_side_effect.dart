abstract class ResetPasswordSideEffect {}

class ResetPasswordSuccessSideEffect extends ResetPasswordSideEffect {
  ResetPasswordSuccessSideEffect(this.email);
  final String email;
}

class ResetPasswordErrorSideEffect extends ResetPasswordSideEffect {
  ResetPasswordErrorSideEffect(this.message);
  final String message;
}

class ResetPasswordEmailNotRegisteredError extends ResetPasswordSideEffect {
  ResetPasswordEmailNotRegisteredError();
}
