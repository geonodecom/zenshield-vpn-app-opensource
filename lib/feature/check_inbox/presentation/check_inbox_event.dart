part of 'check_inbox_bloc.dart';

sealed class CheckInboxEvent {
  const CheckInboxEvent();

  List<Object?> get props => [];
}

class EmailSignUpCodeReceivedEvent extends CheckInboxEvent {
  const EmailSignUpCodeReceivedEvent({required this.code});
  final String code;

  @override
  List<Object?> get props => [code];
}

class ForgotPasswordCodeReceivedEvent extends CheckInboxEvent {
  const ForgotPasswordCodeReceivedEvent({required this.code});
  final String code;

  @override
  List<Object?> get props => [code];
}

class OpenEmailAppEvent extends CheckInboxEvent {
  const OpenEmailAppEvent();
}

class DeepLinkErrorEvent extends CheckInboxEvent {
  const DeepLinkErrorEvent({required this.error});
  final DeepLinkError error;

  @override
  List<Object?> get props => [error];
}
