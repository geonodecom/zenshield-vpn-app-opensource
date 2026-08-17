enum VerificationType {
  registration,
  forgotPassword,
}

class CheckInboxArgs {
  CheckInboxArgs({
    required this.email,
    required this.verificationType,
  });

  final String email;
  final VerificationType verificationType;

  static CheckInboxArgs? fromDynamic(dynamic arguments) {
    if (arguments is Map<String, dynamic>) {
      return CheckInboxArgs(
        email: arguments['email'] as String,
        verificationType: arguments['verificationType'] as VerificationType,
      );
    }

    if (arguments is String) {
      return CheckInboxArgs(
        email: arguments,
        verificationType: VerificationType.registration,
      );
    }
    return null;
  }
}
