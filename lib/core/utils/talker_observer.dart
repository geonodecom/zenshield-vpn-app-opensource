import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';
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
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    if (bloc is HomeBloc && _isUpdateTimerEvent(_lastEvents[bloc])) {
      _lastStates[bloc] = change.nextState;
      return;
    }

    _lastStates[bloc] = change.nextState;
    super.onChange(bloc, change);
  }

  @override
  void onTransition(BlocBase bloc, Transition transition) {
    if (bloc is HomeBloc && _isUpdateTimerEvent(transition.event)) {
      return;
    }

    if (bloc is Bloc) {
      super.onTransition(bloc, transition);
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

    super.onError(bloc, error, stackTrace);
  }
}
