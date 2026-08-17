import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class DeepLinkService {
  DeepLinkService() : _appLinks = AppLinks();

  final AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  Future<void> initialize({
    required void Function(Uri) onLink,
  }) async {
    final initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) {
      onLink(initialUri);
    }

    _linkSubscription = _appLinks.uriLinkStream.listen(
      onLink,
      onError: (Object err) {
        debugPrint('Deep link error: $err');
      },
    );
  }

  void dispose() {
    _linkSubscription?.cancel();
  }
}
