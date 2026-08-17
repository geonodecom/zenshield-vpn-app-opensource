import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenshield/core/managers/geonode_curl_log_manager.dart';
import 'package:zenshield/feature/logs/presentation/state/logs_state.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'logs_event.dart';

class LogsBloc extends Bloc<LogsEvent, LogsState> {
  LogsBloc({
    required Talker logger,
    required GeonodeCurlLogManager geonodeCurlLogManager,
  })  : _logger = logger,
        _geonodeCurlLogManager = geonodeCurlLogManager,
        super(LogsState.initial()) {
    on<InitialLoadEvent>(_onInitialLoad);
    on<CurlLogUpdatedEvent>(_onCurlLogUpdated);
    _subscription = _geonodeCurlLogManager.curlLogStream.listen(
      (curlLog) {
        add(CurlLogUpdatedEvent(curlLog));
      },
      onError: (error) {
        _logger.error('Error in curl log stream', error);
      },
    );
  }

  final Talker _logger;
  final GeonodeCurlLogManager _geonodeCurlLogManager;
  StreamSubscription<String>? _subscription;

  Future<void> _onInitialLoad(
    InitialLoadEvent event,
    Emitter<LogsState> emit,
  ) async {
    emit(state.copyWith(isLoading: false));
  }

  void _onCurlLogUpdated(
    CurlLogUpdatedEvent event,
    Emitter<LogsState> emit,
  ) {
    emit(state.copyWith(curlLog: event.curlLog));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
