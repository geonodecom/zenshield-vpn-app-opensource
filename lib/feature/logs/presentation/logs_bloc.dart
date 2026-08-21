import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenshield/feature/logs/presentation/state/logs_state.dart';

part 'logs_event.dart';

class LogsBloc extends Bloc<LogsEvent, LogsState> {
  LogsBloc() : super(LogsState.initial()) {
    on<InitialLoadEvent>(_onInitialLoad);
  }

  Future<void> _onInitialLoad(
    InitialLoadEvent event,
    Emitter<LogsState> emit,
  ) async {
    emit(state.copyWith(isLoading: false));
  }
}
