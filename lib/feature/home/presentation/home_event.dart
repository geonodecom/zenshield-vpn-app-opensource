part of 'home_bloc.dart';

sealed class HomeEvent {
  const HomeEvent();

  List<Object?> get props => [];
}

class InitialEvent extends HomeEvent {
  InitialEvent({
    required this.connectionStatus,
  });

  final ConnectionStatus connectionStatus;

  @override
  List<Object?> get props => [connectionStatus];
}

class ServersTappedEvent extends HomeEvent {
  @override
  List<Object?> get props => [];
}

class SettingsTappedEvent extends HomeEvent {
  @override
  List<Object?> get props => [];
}

class AboutTappedEvent extends HomeEvent {
  @override
  List<Object?> get props => [];
}

class UpdateTimer extends HomeEvent {
  UpdateTimer({required this.time});
  final String time;

  @override
  List<Object?> get props => [time];
}

class UpdateVpnStateEvent extends HomeEvent {
  UpdateVpnStateEvent({required this.connectionStatus, this.isServerSwitch = false});
  final ConnectionStatus connectionStatus;
  final bool isServerSwitch;

  @override
  List<Object> get props => [connectionStatus, isServerSwitch];
}

