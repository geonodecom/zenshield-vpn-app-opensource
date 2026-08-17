import 'package:flutter/material.dart';

sealed class HomeSideEffect {
  const HomeSideEffect();
}

class NavigateToServers extends HomeSideEffect {}

class NavigateToSettings extends HomeSideEffect {}

class NavigateToAbout extends HomeSideEffect {}

class NavigateToAppUpdate extends HomeSideEffect {
  const NavigateToAppUpdate();
}

class ShowUpdatePopup extends HomeSideEffect {
  const ShowUpdatePopup({
    required this.isDismissible,
    this.version,
  });

  final bool isDismissible;
  final String? version;
}

class RequestLocalReview extends HomeSideEffect {
  const RequestLocalReview({
    required this.onSuccess,
  });

  final VoidCallback onSuccess;
}
