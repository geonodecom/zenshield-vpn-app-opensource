import 'package:freezed_annotation/freezed_annotation.dart';
part 'logs_state.freezed.dart';

@freezed
class LogsState with _$LogsState {
  const factory LogsState({
    @Default(false) bool isLoading,
  }) = _LogsState;

  factory LogsState.initial() => const LogsState(
        isLoading: false,
      );
}

