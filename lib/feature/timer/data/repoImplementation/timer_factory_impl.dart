import 'package:injectable/injectable.dart';
import 'package:zenshield/feature/timer/domain/repositories/abstract_timer_control.dart';
import 'package:zenshield/feature/timer/domain/repositories/timer_factory.dart';

// ignore: unused-code
@LazySingleton(as: AbstractTimerFactory)
class TimerFactory implements AbstractTimerFactory {
  TimerFactory({
    required this.timer,
  });

  final AbstractTimerControl timer;

  @override
  AbstractTimerControl getTimer({required bool isPaid}) {
    return timer;
  }
}
