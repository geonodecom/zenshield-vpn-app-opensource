sealed class NewPasswordSideEffect {
  const NewPasswordSideEffect();
}

class PasswordChangedSuccessSideEffect extends NewPasswordSideEffect {
  const PasswordChangedSuccessSideEffect();
}

class PasswordChangeErrorSideEffect extends NewPasswordSideEffect {
  const PasswordChangeErrorSideEffect();
}

class DeeplinkSessionExpiredSideEffect extends NewPasswordSideEffect {
  const DeeplinkSessionExpiredSideEffect();
}
