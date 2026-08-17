import 'dart:io';

import 'package:flutter/services.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:injectable/injectable.dart';
import 'package:zenshield/core/channels/channels.dart';

abstract class AbstractPlatformReviewRequester {
  Future<void> requestReview();
}

@injectable
class AndroidReviewRequester implements AbstractPlatformReviewRequester {
  static final _reviewChannel = MethodChannel(Channels.reviewMethodsChannel);
  @override
  Future<void> requestReview() async {
    await _reviewChannel.invokeMethod('show_review');
  }
}

@injectable
class DefaultReviewRequester implements AbstractPlatformReviewRequester {
  static final _review = InAppReview.instance;

  @override
  Future<void> requestReview() async {
    return;
    //The app isn't distributed in stores; a review request isn't required.
    // ignore: dead_code
    final isInAppReviewAvailable = await _review.isAvailable();
    if (isInAppReviewAvailable && !Platform.isWindows) {
      await _review.requestReview();
    }
  }
}
