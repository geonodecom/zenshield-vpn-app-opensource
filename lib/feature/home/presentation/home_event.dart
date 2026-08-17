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

class CloseUpdateBannerEvent extends HomeEvent {
  const CloseUpdateBannerEvent();

  @override
  List<Object?> get props => [];
}

class ShowUpdatedBannerEvent extends HomeEvent {
  ShowUpdatedBannerEvent({required this.version});

  final String version;

  @override
  List<Object?> get props => [version];
}

class StartUpdateEvent extends HomeEvent {
  const StartUpdateEvent();

  @override
  List<Object?> get props => [];
}

class CloseUpdatePopupEvent extends HomeEvent {
  const CloseUpdatePopupEvent();

  @override
  List<Object?> get props => [];
}

class SetUpdatePopupShowingEvent extends HomeEvent {
  const SetUpdatePopupShowingEvent({required this.isShowing});

  final bool isShowing;

  @override
  List<Object?> get props => [isShowing];
}
