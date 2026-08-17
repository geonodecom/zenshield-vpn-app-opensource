import 'package:in_app_review/in_app_review.dart';
import 'package:injectable/injectable.dart';
import 'package:zenshield/config/constants/common_constants.dart';
import 'package:zenshield/core/preferences.dart';
import 'package:zenshield/feature/rating/domain/useCase/rating_use_case.dart';

@Injectable(as: AbstractRatingUseCase)
class RatingUseCase implements AbstractRatingUseCase {
  RatingUseCase(this._preferences);

  final Preferences _preferences;
  final _inAppReview = InAppReview.instance;

  @override
  Future<bool> checkShowRatePopUpIfNeeded() async {
    final count = await _preferences.ratingCount;
    return count < 3;
  }

  @override
  Future<void> showReview() async {
    final count = await _preferences.ratingCount;
    await _preferences.setRatingCount(count + 1);

    if (await _inAppReview.isAvailable()) {
      await _inAppReview.requestReview();
    } else {
      await _inAppReview.openStoreListing(appStoreId: CommonConstants.appStoreId);
    }
  }
}
