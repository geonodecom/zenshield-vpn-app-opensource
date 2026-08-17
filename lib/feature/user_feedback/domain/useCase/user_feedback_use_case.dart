abstract class AbstractUserFeedbackUseCase {
  Future<void> sendUserFeedback({
    required String name,
    required String email,
    required String message,
  });
}
