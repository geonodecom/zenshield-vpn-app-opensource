import 'dart:async';
import 'dart:io';

import 'package:event_bus/event_bus.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenshield/core/event_bus_events/on_deep_link_error.dart';
import 'package:zenshield/core/event_bus_events/on_email_verification_code_received.dart';
import 'package:zenshield/core/event_bus_events/on_forgot_password_verification_code_received.dart';
import 'package:zenshield/feature/auth/data/auth_user_use_case.dart';
import 'package:zenshield/feature/auth/data/model/auth_models.dart';
import 'package:zenshield/feature/deep_links/domain/deep_link_error.dart';
import 'package:zenshield/feature/check_inbox/presentation/check_inbox_args.dart';
import 'package:zenshield/feature/check_inbox/presentation/check_inbox_side_effect.dart';
import 'package:zenshield/feature/check_inbox/presentation/state/check_inbox_state.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'check_inbox_event.dart';

class CheckInboxBloc
    extends
        SideEffectBloc<CheckInboxEvent, CheckInboxState, CheckInboxSideEffect> {
  CheckInboxBloc({
    required EventBus eventBus,
    required AbstractAuthUserUseCase authUseCase,
    required Talker logger,
    required String email,
    required VerificationType verificationType,
  }) : _eventBus = eventBus,
       _authUseCase = authUseCase,
       _logger = logger,
       _email = email,
       _verificationType = verificationType,
       super(CheckInboxState.initial()) {
    on<EmailSignUpCodeReceivedEvent>(_onEmailVerificationCodeReceived);
    on<DeepLinkErrorEvent>(_onDeepLinkError);
    on<ForgotPasswordCodeReceivedEvent>(_onForgotPasswordCodeReceived);
    on<OpenEmailAppEvent>(_onOpenEmailApp);

    _verificationCodeSubscription = _eventBus
        .on<OnEmailVerificationCodeReceived>()
        .listen((event) {
          add(EmailSignUpCodeReceivedEvent(code: event.code));
        });

    _forgotPasswordCodeSubscription = _eventBus
        .on<OnForgotPasswordCodeReceived>()
        .listen((event) {
          add(ForgotPasswordCodeReceivedEvent(code: event.code));
        });

    _deepLinkErrorSubscription = _eventBus.on<OnDeepLinkError>().listen((
      event,
    ) {
      add(DeepLinkErrorEvent(error: event.error));
    });
  }

  final EventBus _eventBus;
  final AbstractAuthUserUseCase _authUseCase;
  final Talker _logger;
  final String _email;
  final VerificationType _verificationType;

  StreamSubscription<OnEmailVerificationCodeReceived>?
  _verificationCodeSubscription;
  StreamSubscription<OnDeepLinkError>? _deepLinkErrorSubscription;

  StreamSubscription<OnForgotPasswordCodeReceived>?
  _forgotPasswordCodeSubscription;

  void unsubscribeFromDeepLinks() {
    _verificationCodeSubscription?.cancel();
    _deepLinkErrorSubscription?.cancel();
    _forgotPasswordCodeSubscription?.cancel();
    _verificationCodeSubscription = null;
    _deepLinkErrorSubscription = null;
    _forgotPasswordCodeSubscription = null;
    _logger.info('Unsubscribed from deep links');
  }

  @override
  Future<void> close() async {
    unsubscribeFromDeepLinks();
    return super.close();
  }

  Future<void> _onEmailVerificationCodeReceived(
    EmailSignUpCodeReceivedEvent event,
    Emitter<CheckInboxState> emit,
  ) async {
    try {
      if (_verificationType == VerificationType.registration) {
        _logger.info('Verification code received via deep link: ${event.code}');

        final session = _authUseCase.session;
        if (session.email == null || session.authType == null) {
          _logger.info('Session data is missing');
          produceSideEffect(const ShowSessionDataMissingError());
          return;
        }

        await _authUseCase.verifyCode(_email, event.code, session.authType!);

        _logger.info('Verification code verified');

        produceSideEffect(NavigateToHome());
      } else {
        produceSideEffect(const ShowWrongActionError());
      }
    } catch (e, stackTrace) {
      _logger.error('Failed to verify code', e, stackTrace);
      produceSideEffect(const ShowVerificationError());
    }
  }

  Future<void> _onForgotPasswordCodeReceived(
    ForgotPasswordCodeReceivedEvent event,
    Emitter<CheckInboxState> emit,
  ) async {
    try {
      if (_verificationType == VerificationType.forgotPassword) {
        _logger.info(
          'Forgot password code received via deep link: ${event.code}',
        );
        await _authUseCase.saveDeeplinkSessionData(
          email: _email,
          authType: AuthType.changePass,
          password: event.code,
        );
        _logger.info('Forgot password code saved');

        produceSideEffect(NavigateToNewPassword());
        return;
      }

      produceSideEffect(const ShowWrongActionError());
    } on Exception catch (e, stackTrace) {
      _logger.error('Failed to verify code', e, stackTrace);
      produceSideEffect(const ShowVerificationError());
    }
  }

  Future<void> _onOpenEmailApp(
    OpenEmailAppEvent event,
    Emitter<CheckInboxState> emit,
  ) async {
    try {
      if (Platform.isAndroid) {
        await _openMailOnAndroid();
        return;
      }
      if (Platform.isWindows) {
        await _openMailOnWindows();
        return;
      }
      if (Platform.isIOS) {
        await _openMailOnIOS();
        return;
      }
      if (Platform.isMacOS) {
        await _openMailOnMacOS();
        return;
      }
      produceSideEffect(const ShowEmailAppNotFound());
    } catch (e, stackTrace) {
      _logger.error('Failed to open email app', e, stackTrace);
      produceSideEffect(const ShowEmailAppNotFound());
    }
  }

  Future<void> _openMailOnAndroid() async {
    const intent = AndroidIntent(
      action: 'android.intent.action.MAIN',
      category: 'android.intent.category.APP_EMAIL',
    );
    await intent.launch();
  }

  Future<void> _openMailOnIOS() async {
    final mailUri = Uri.parse('message://');
    if (await canLaunchUrl(mailUri)) {
      await launchUrl(mailUri);
      return;
    }
    final gmailUri = Uri.parse('googlegmail://');
    if (await canLaunchUrl(gmailUri)) {
      await launchUrl(gmailUri);
      return;
    }
    produceSideEffect(const ShowEmailAppNotFound());
  }

  Future<void> _openMailOnMacOS() async {
    final mailtoUri = Uri(scheme: 'mailto');
    if (await canLaunchUrl(mailtoUri)) {
      await launchUrl(mailtoUri, mode: LaunchMode.externalApplication);
      return;
    }
    produceSideEffect(const ShowEmailAppNotFound());
  }

  Future<void> _openMailOnWindows() async {
    final outlookMailUri = Uri.parse('outlookmail:');
    if (await canLaunchUrl(outlookMailUri)) {
      await launchUrl(outlookMailUri);
      return;
    }
    final mailtoUri = Uri(scheme: 'mailto');
    if (await canLaunchUrl(mailtoUri)) {
      await launchUrl(mailtoUri, mode: LaunchMode.externalApplication);
    }
  }

  void _onDeepLinkError(
    DeepLinkErrorEvent event,
    Emitter<CheckInboxState> emit,
  ) {
    _logger.warning('Deep link error on check inbox screen: ${event.error}');
    switch (event.error) {
      case DeepLinkError.unknownAction:
        produceSideEffect(const ShowUnknownActionError());
        break;
      case DeepLinkError.missingCodeParameter:
        produceSideEffect(const ShowMissingCodeParameterError());
        break;
    }
  }
}
