import 'package:freezed_annotation/freezed_annotation.dart';

part 'check_inbox_state.freezed.dart';

@freezed
class CheckInboxState with _$CheckInboxState {
  const factory CheckInboxState() = _CheckInboxState;

  factory CheckInboxState.initial() => const CheckInboxState();
}
