import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zenshield/feature/app_update/presentation/app_update_bloc.dart';
import 'package:zenshield/feature/home/presentation/home_bloc.dart';

class CustomTalkerBlocObserver extends TalkerBlocObserver {
  CustomTalkerBlocObserver({
    required Talker super.talker,
    super.settings,
  }) : _customTalker = talker;

  final Talker _customTalker;
  final Map<BlocBase, Object?> _lastEvents = {};
  final Map<BlocBase, Object?> _lastStates = {};

  bool _isUpdateTimerEvent(Object? event) {
    return event != null && event.runtimeType.toString() == 'UpdateTimer';
  }

  @override
  void onEvent(BlocBase bloc, Object? event) {
    if (bloc is HomeBloc && _isUpdateTimerEvent(event)) {
      return;
    }

    _lastEvents[bloc] = event;

    if (bloc is Bloc) {
      super.onEvent(bloc, event);
    }

    if (bloc is AppUpdateBloc) {
      _customTalker.info('=== AppUpdateBloc Event ===');
      _customTalker.info('Event: ${event.runtimeType}');
      _customTalker.info('Event data: $event');
      _customTalker.info('Current state: ${bloc.state}');
      _logAppUpdateBlocContext(bloc);
    }
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    if (bloc is HomeBloc && _isUpdateTimerEvent(_lastEvents[bloc])) {
      _lastStates[bloc] = change.nextState;
      return;
    }

    _lastStates[bloc] = change.nextState;
    super.onChange(bloc, change);

    if (bloc is AppUpdateBloc) {
      _customTalker.info('=== AppUpdateBloc State Change ===');
      _customTalker.info('Previous state: ${change.currentState}');
      _customTalker.info('Next state: ${change.nextState}');
      _logAppUpdateBlocContext(bloc);
    }
  }

  @override
  void onTransition(BlocBase bloc, Transition transition) {
    if (bloc is HomeBloc && _isUpdateTimerEvent(transition.event)) {
      return;
    }

    if (bloc is Bloc) {
      super.onTransition(bloc, transition);
    }

    if (bloc is AppUpdateBloc) {
      _customTalker.info('=== AppUpdateBloc Transition ===');
      _customTalker.info('Event: ${transition.event}');
      _customTalker.info('Current state: ${transition.currentState}');
      _customTalker.info('Next state: ${transition.nextState}');
    }
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    _customTalker.error('=== Bloc Error ===');
    _customTalker.error('Bloc type: ${bloc.runtimeType}');
    _customTalker.error('Bloc state: ${bloc.state}');
    _customTalker.error('Last event: ${_lastEvents[bloc]}');
    _customTalker.error('Error type: ${error.runtimeType}');
    _customTalker.error('Error: $error');

    if (bloc is AppUpdateBloc) {
      _logAppUpdateBlocDiagnostics(bloc, error, stackTrace);
    }

    super.onError(bloc, error, stackTrace);
  }

  void _logAppUpdateBlocContext(AppUpdateBloc bloc) {
    try {
      final diagnostics = bloc.getDiagnostics();
      _customTalker.info('Desktop updater context:');
      diagnostics.forEach((key, value) {
        _customTalker.info('  - $key: $value');
      });
      _customTalker.info('Bloc isClosed: ${bloc.isClosed}');
    } catch (e) {
      _customTalker.warning('Failed to log AppUpdateBloc context: $e');
    }
  }

  void _logAppUpdateBlocDiagnostics(
    AppUpdateBloc bloc,
    Object error,
    StackTrace stackTrace,
  ) {
    _customTalker.error('=== AppUpdateBloc Detailed Diagnostics ===');

    try {
      final diagnostics = bloc.getDiagnostics();
      _customTalker.error('Diagnostics:');
      diagnostics.forEach((key, value) {
        _customTalker.error('  - $key: $value');
      });
    } catch (e) {
      _customTalker.error('Failed to get diagnostics: $e');
    }

    _customTalker.error('Last event: ${_lastEvents[bloc]}');
    _customTalker.error('Last state before error: ${_lastStates[bloc]}');
    _customTalker.error('Error type: ${error.runtimeType}');
    _customTalker.error('Error message: ${error.toString()}');
    _customTalker.error('Stack trace: $stackTrace');
  }
}
