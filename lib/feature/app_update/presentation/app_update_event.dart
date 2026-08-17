part of 'app_update_bloc.dart';

sealed class AppUpdateEvent {
  const AppUpdateEvent();

  List<Object> get props => [];
}

class InitialEvent extends AppUpdateEvent {
  const InitialEvent();

  @override
  List<Object> get props => [];
}

class CheckForUpdatesEvent extends AppUpdateEvent {
  const CheckForUpdatesEvent();

  @override
  List<Object> get props => [];
}

class StartUpdateEvent extends AppUpdateEvent {
  const StartUpdateEvent();

  @override
  List<Object> get props => [];
}

class UpdateAvailableEvent extends AppUpdateEvent {
  const UpdateAvailableEvent();

  @override
  List<Object> get props => [];
}

class AppResumedEvent extends AppUpdateEvent {
  const AppResumedEvent();

  @override
  List<Object> get props => [];
}

class RetryUpdateEvent extends AppUpdateEvent {
  const RetryUpdateEvent();

  @override
  List<Object> get props => [];
}

class DownloadProgressEvent extends AppUpdateEvent {
  const DownloadProgressEvent({required this.progress});

  final double progress;

  @override
  List<Object> get props => [progress];
}

class InstallProgressEvent extends AppUpdateEvent {
  const InstallProgressEvent({required this.progress});

  final double progress;

  @override
  List<Object> get props => [progress];
}

class UpdateErrorEvent extends AppUpdateEvent {
  const UpdateErrorEvent({required this.error});

  final String error;

  @override
  List<Object> get props => [error];
}

class UpdateCompletedEvent extends AppUpdateEvent {
  const UpdateCompletedEvent();

  @override
  List<Object> get props => [];
}

class DownloadFailedEvent extends AppUpdateEvent {
  const DownloadFailedEvent();

  @override
  List<Object> get props => [];
}

class SkipUpdateEvent extends AppUpdateEvent {
  const SkipUpdateEvent();

  @override
  List<Object> get props => [];
}
