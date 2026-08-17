import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zenshield/feature/settings/data/model/languages.dart';
import 'package:zenshield/core/models/protocols.dart';
import 'package:zenshield/core/models/theme.dart';

part 'settings_state.freezed.dart';

@freezed
class SettingsState with _$SettingsState {
  const factory SettingsState({
    required String userId,
    required Languages language,
    required ThemeType theme,
    required Protocols protocol,
    required bool autoConnect,
    required bool launchOnStartup,
    required bool launchOnStartupFailed,
    required bool isIgnoringBatteryOptimizations,
    DateTime? securedSince,
  }) = _SettingsState;

  factory SettingsState.initial() {
    return const SettingsState(
      userId: '',
      language: Languages.english,
      theme: ThemeType.auto,
      protocol: Protocols.auto,
      autoConnect: false,
      launchOnStartup: false,
      launchOnStartupFailed: false,
      isIgnoringBatteryOptimizations: true,
      securedSince: null,
    );
  }
}
