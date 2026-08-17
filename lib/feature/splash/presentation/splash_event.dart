part of 'splash_bloc.dart';

sealed class SplashEvent {
  const SplashEvent();

  List<Object> get props => [];
}

class InitialSplashEvent extends SplashEvent {
  const InitialSplashEvent();

  @override
  List<Object> get props => [];
}

class ContactSupportTappedEvent extends SplashEvent {
  const ContactSupportTappedEvent();

  @override
  List<Object> get props => [];
}
