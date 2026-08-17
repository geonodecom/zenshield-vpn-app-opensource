import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:injectable/injectable.dart';
import 'package:zenshield/core/event_bus_events/on_timer_tick.dart';
import 'package:zenshield/core/preferences.dart';
import 'package:zenshield/feature/timer/domain/repositories/abstract_timer_control.dart';
import 'package:talker_flutter/talker_flutter.dart';

// ignore: unused-code
@LazySingleton(as: AbstractTimerControl)
class TimerControl implements AbstractTimerControl {
  TimerControl({
    required this.eventBus,
    required this.preferences,
    required this.logger,
  });

  final EventBus eventBus;
  final Preferences preferences;
  final Talker logger;

  static const int _tickDuration = 1;
  Timer? _timer;

  @override
  Future<String?> get currentValue async {
    return _timeDiff();
  }

  @override
  Future<void> start() async {
    logger.info('Try to start timer');
    if (_timer != null) {
      logger.info('Timer is already running.');
      return;
    }

    final currentStartTime = await preferences.timerStartTime;

    if (currentStartTime == null) {
      final currentTimeMillis = DateTime.now().millisecondsSinceEpoch;
      await preferences.setTimerStartTime(currentTimeMillis);
      logger.info('Timer started at $currentTimeMillis.');
    } else {
      logger.info('Resuming timer from stored start time: $currentStartTime.');
    }

    _timer?.cancel();
    _timer =
        Timer.periodic(const Duration(seconds: _tickDuration), (timer) async {
      final currentDiff = await _timeDiff();
      if (currentDiff != null) {
        eventBus.fire(OnTimerTick(time: currentDiff));
      }
    });

    logger.info('Timer started.');
  }

  @override
  Future<void> stop() async {
    logger.info('Try to stop timer');
    if (_timer == null) {
      logger.info('Timer is already stopped.');
      return;
    }

    await preferences.removeTimerStartTime();
    _timer?.cancel();
    _timer = null;

    logger.info('Timer stopped and start time removed.');
  }

  Future<String?> _timeDiff() async {
    final startTime = await preferences.timerStartTime;
    if (startTime != null) {
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      final difference = (currentTime - startTime) ~/ 1000;
      final time = _secondsToTime(difference);
      return time;
    }

    return null;
  }

  String _secondsToTime(int seconds) {
    var remainingSeconds = seconds;

    final hours = remainingSeconds ~/ 3600;
    remainingSeconds %= 3600;
    final minutes = remainingSeconds ~/ 60;
    final secondsStr = (remainingSeconds % 60).toString().padLeft(2, '0');

    final hoursStr = hours.toString().padLeft(2, '0');
    final minutesStr = minutes.toString().padLeft(2, '0');

    return '$hoursStr:$minutesStr:$secondsStr';
  }
}
