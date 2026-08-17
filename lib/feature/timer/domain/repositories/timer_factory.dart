import 'package:zenshield/feature/timer/domain/repositories/abstract_timer_control.dart';

abstract class AbstractTimerFactory {
  AbstractTimerControl getTimer({required bool isPaid});
}
