abstract class AbstractRatingUseCase {
  Future<bool> checkShowRatePopUpIfNeeded();

  Future<void> showReview();
}
