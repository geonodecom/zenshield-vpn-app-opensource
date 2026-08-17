import 'dart:async';

import 'package:zenshield/core/managers/analytics_events.dart';
import 'package:zenshield/core/managers/analytics_manager.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

mixin LaunchUrl<Event, State, SideEffect>
    on SideEffectBloc<Event, State, SideEffect> {
  Future<void> launchExternalUrl(Uri url) async {
    try {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    } on Exception catch (e, stackTrace) {
      addError(e, stackTrace);
    }
  }
}

mixin AnalyticsEventSender {
  AbstractAnalyticsManager get analyticsManager;

  void sendAnalyticsEvent(
    AnalyticsEventNames eventName, [
    Map<String, String>? parameters,
  ]) {
    unawaited(analyticsManager.sendEvent(eventName, parameters));
  }
}
