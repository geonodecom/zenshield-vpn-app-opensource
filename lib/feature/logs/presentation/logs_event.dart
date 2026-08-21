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
