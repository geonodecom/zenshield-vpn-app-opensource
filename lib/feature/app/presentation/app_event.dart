part of 'app_bloc.dart';

abstract class AppEvent {
  const AppEvent();

  List<Object?> get props => [];
}

class InitialEvent extends AppEvent {}

class SelectProtocolEvent extends AppEvent {
  const SelectProtocolEvent(this.protocol);

  final Protocols protocol;
}

class CurrentServerUpdatedEvent extends AppEvent {
  const CurrentServerUpdatedEvent(this.server, {this.manual = false});

  final VpnConfiguration? server;

  /// True when the user explicitly picked this server from the server list.
  final bool manual;

  @override
  List<Object?> get props => [server];
}

class ActiveServerResolvedEvent extends AppEvent {
  const ActiveServerResolvedEvent(this.serverIp);

  final String serverIp;

  @override
  List<Object?> get props => [serverIp];
}

class TunnelHealthChangedEvent extends AppEvent {
  const TunnelHealthChangedEvent(this.healthy);

  final bool healthy;

  @override
  List<Object?> get props => [healthy];
}

class UpdateVpnStateEvent extends AppEvent {
  UpdateVpnStateEvent({required this.connectionStatus});
  final ConnectionStatus connectionStatus;

  @override
  List<Object> get props => [connectionStatus];
}

class TurnOnVpnTappedEvent extends AppEvent {
  const TurnOnVpnTappedEvent({this.skipBatteryOptimizationCheck = false});

  final bool skipBatteryOptimizationCheck;

  @override
  List<Object?> get props => [skipBatteryOptimizationCheck];
}

class TurnOffVpnTappedEvent extends AppEvent {
  const TurnOffVpnTappedEvent();
  @override
  List<Object?> get props => [];
}

class AutoSelectRequestedAppEvent extends AppEvent {
  const AutoSelectRequestedAppEvent();

  @override
  List<Object?> get props => [];
}

class ZenSdkChangedEvent extends AppEvent {
  const ZenSdkChangedEvent(this.value);

  final bool value;

  @override
  List<Object?> get props => [value];
}
