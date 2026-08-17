import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zenshield/config/constants/feature_flags.dart';
import 'package:zenshield/config/constants/urls.dart';
import 'dart:io';

import 'package:zenshield/core/preferences.dart';
import 'package:zenshield/core/utils/platform_utils.dart';
import 'package:zenshield/feature/app_version/domain/useCase/app_version_use_case.dart';
import 'package:zenshield/feature/agreements/domain/useCase/agreement_use_case.dart';
import 'package:zenshield/feature/auth/data/auth_user_use_case.dart';
import 'package:zenshield/feature/splash/presentation/splash_side_effect.dart';
import 'package:zenshield/feature/splash/presentation/state/splash_state.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'splash_event.dart';

class SplashBloc
    extends SideEffectBloc<SplashEvent, SplashState, SplashSideEffect> {
  SplashBloc({
    required AbstractAgreementUseCase agreementUseCase,
    required AbstractAppVersionUseCase appVersionUseCase,
    required AbstractAuthUserUseCase authUserUseCase,
    required Preferences preferences,
    required Talker logger,
  }) : _agreementUseCase = agreementUseCase,
       _appVersionUseCase = appVersionUseCase,
       _authUserUseCase = authUserUseCase,
       _preferences = preferences,
       _logger = logger,
       super(const SplashState.initial()) {
    on<InitialSplashEvent>(_onInitialEvent);
    on<ContactSupportTappedEvent>(_onContactSupportTapped);

    add(const InitialSplashEvent());
  }

  // Dependencies
  final AbstractAgreementUseCase _agreementUseCase;
  final AbstractAppVersionUseCase _appVersionUseCase;
  final AbstractAuthUserUseCase _authUserUseCase;
  final Preferences _preferences;
  final Talker _logger;

  Future<void> _onInitialEvent(
    InitialSplashEvent event,
    Emitter<SplashState> emit,
  ) async {
    try {
      if (!FeatureFlags.disableInAppUpdates &&
          (PlatformUtils.isDesktop || Platform.isAndroid)) {
        await Future.delayed(const Duration(milliseconds: 500));
        produceSideEffect(const NavigateToAppUpdate());
        return;
      }

      try {
        await _appVersionUseCase.sendAppVersion();
      } catch (e, st) {
        _logger.warning(
          'App version send failed during splash (non-blocking)',
          e,
          st,
        );
      }

      final isAuthorized = await _authUserUseCase.isAuthorized();

      if (!isAuthorized) {
        produceSideEffect(NavigateToAuth());
        return;
      }

      try {
        final agreementsResponse = await _agreementUseCase
            .getAgreementsResponse();

        if (agreementsResponse.agreement == null) {
          if (await _preferences.shouldPromptGeonodeKeySetup) {
            produceSideEffect(const NavigateToGeonodeKeySetup());
            return;
          }
          produceSideEffect(NavigateToHome());
          return;
        }

        if (!agreementsResponse.isFirstTime) {
          final lastDeclinedDate = await _preferences.zenSdkLastDeclinedDate;
          if (lastDeclinedDate == Preferences.todayDateString()) {
            // Already asked (and declined) today — don't ask again until
            // the next calendar day.
            produceSideEffect(NavigateToHome());
            return;
          }
        }

        produceSideEffect(
          NavigateToOnboarding(agreementsResponse: agreementsResponse),
        );
      } on DioException catch (e, st) {
        if (_isNetworkUnavailable(e)) {
          _logger.warning(
            'Agreements fetch failed due to network/DNS — continuing to home',
            e,
            st,
          );
          produceSideEffect(NavigateToHome());
          return;
        }
        rethrow;
      }
    } catch (e, st) {
      addError(e, st);
      _logger.error('Error in splash initialization', e, st);
      produceSideEffect(const ShowErrorDialog());
    }
  }

  bool _isNetworkUnavailable(DioException e) {
    return e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        (e.type == DioExceptionType.unknown &&
            e.error.toString().contains('Failed host lookup'));
  }

  Future<void> _onContactSupportTapped(
    ContactSupportTappedEvent event,
    Emitter<SplashState> emit,
  ) async {
    await launchUrl(Uri.parse('mailto:${Urls.supportEmail}'));
  }
}
