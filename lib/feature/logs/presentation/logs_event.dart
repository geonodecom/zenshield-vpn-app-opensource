part of 'logs_bloc.dart';

sealed class LogsEvent {
  const LogsEvent();

  List<Object> get props => [];
}

class InitialLoadEvent extends LogsEvent {
  const InitialLoadEvent();

  @override
  List<Object> get props => [];
}

class CurlLogUpdatedEvent extends LogsEvent {
  const CurlLogUpdatedEvent(this.curlLog);

  final String curlLog;

  @override
  List<Object> get props => [curlLog];
}
