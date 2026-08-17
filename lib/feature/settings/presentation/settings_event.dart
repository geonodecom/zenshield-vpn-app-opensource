part of 'settings_bloc.dart';

sealed class SettingsEvent {
  const SettingsEvent();

  List<Object?> get props => [];
}

class InitialLoadEvent extends SettingsEvent {
  const InitialLoadEvent();
}

class ProtocolTappedEvent extends SettingsEvent {
  const ProtocolTappedEvent();

  @override
  List<Object> get props => [];
}

class LogOutTappedEvent extends SettingsEvent {
  const LogOutTappedEvent();

  @override
  List<Object> get props => [];
}

class TelegramTappedEvent extends SettingsEvent {
  const TelegramTappedEvent();

  @override
  List<Object> get props => [];
}

class XTappedEvent extends SettingsEvent {
  const XTappedEvent();

  @override
  List<Object> get props => [];
}

class NavigateToHomeEvent extends SettingsEvent {
  const NavigateToHomeEvent();

  @override
  List<Object?> get props => [];
}

class LaunchOnStartupChangedEvent extends SettingsEvent {
  const LaunchOnStartupChangedEvent(this.value);

  final bool value;

  @override
  List<Object?> get props => [value];
}

class RequestIgnoreBatteryOptimizationEvent extends SettingsEvent {
  const RequestIgnoreBatteryOptimizationEvent();

  @override
  List<Object?> get props => [];
}

class BatteryOptimizationStatusChangedEvent extends SettingsEvent {
  const BatteryOptimizationStatusChangedEvent(this.value);

  final bool value;

  @override
  List<Object?> get props => [value];
}

class OpenBatteryOptimizationSettingsEvent extends SettingsEvent {
  const OpenBatteryOptimizationSettingsEvent();

  @override
  List<Object?> get props => [];
}

class RefreshBatteryOptimizationStatusEvent extends SettingsEvent {
  const RefreshBatteryOptimizationStatusEvent();

  @override
  List<Object?> get props => [];
}
