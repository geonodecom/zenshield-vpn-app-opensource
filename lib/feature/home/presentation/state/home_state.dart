import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    required String timerValue,
    @Default(false) bool showUpdateBanner,
    String? updateVersion,
    @Default(false) bool isUpdatePopupShowing,
  }) = _HomeState;

  factory HomeState.initial() => const HomeState(
        timerValue: '00:00:00',
        showUpdateBanner: false,
        updateVersion: null,
        isUpdatePopupShowing: false,
      );
}
