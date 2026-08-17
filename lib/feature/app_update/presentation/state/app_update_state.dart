import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_update_state.freezed.dart';

@freezed
class AppUpdateState with _$AppUpdateState {
  const factory AppUpdateState.checking() = _Checking;

  const factory AppUpdateState.confirm({
    required bool isMandatory,
    String? version,
  }) = _Confirm;

  const factory AppUpdateState.downloading({
    required double progress, // 0.0 to 1.0
  }) = _Downloading;

  const factory AppUpdateState.installing({
    required double progress, // 0.0 to 1.0
  }) = _Installing;

  const factory AppUpdateState.restarting() = _Restarting;

  const factory AppUpdateState.error({
    @Default(false) bool isMandatory,
    @Default(false) bool isInstallFailure,
  }) = _Error;
}
