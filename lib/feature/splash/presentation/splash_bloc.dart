import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zenshield/config/constants/urls.dart';

import 'package:zenshield/feature/auth/data/auth_user_use_case.dart';
import 'package:zenshield/feature/splash/presentation/splash_side_effect.dart';
import 'package:zenshield/feature/splash/presentation/state/splash_state.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'splash_event.dart';

class SplashBloc
    extends SideEffectBloc<SplashEvent, SplashState, SplashSideEffect> {
  SplashBloc({
    required AbstractAuthUserUseCase authUserUseCase,
    required Talker logger,
  }) : _authUserUseCase = authUserUseCase,
       _logger = logger,
       super(const SplashState.initial()) {
    on<InitialSplashEvent>(_onInitialEvent);
    on<ContactSupportTappedEvent>(_onContactSupportTapped);

    add(const InitialSplashEvent());
  }

  // Dependencies
  final AbstractAuthUserUseCase _authUserUseCase;
  final Talker _logger;

  Future<void> _onInitialEvent(
    InitialSplashEvent event,
    Emitter<SplashState> emit,
  ) async {
    try {
      final isAuthorized = await _authUserUseCase.isAuthorized();

      if (!isAuthorized) {
        produceSideEffect(NavigateToAuth());
        return;
      }

      produceSideEffect(NavigateToHome());
    } catch (e, st) {
      addError(e, st);
      _logger.error('Error in splash initialization', e, st);
      produceSideEffect(const ShowErrorDialog());
    }
  }

  Future<void> _onContactSupportTapped(
    ContactSupportTappedEvent event,
    Emitter<SplashState> emit,
  ) async {
    await launchUrl(Uri.parse('mailto:${Urls.supportEmail}'));
  }
}
