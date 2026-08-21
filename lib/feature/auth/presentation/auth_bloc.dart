import 'dart:async';

import 'package:dio/dio.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenshield/config/constants/urls.dart';
import 'package:zenshield/core/event_bus_events/on_deep_link_error.dart';
import 'package:zenshield/core/event_bus_events/on_email_verification_code_received.dart';
import 'package:zenshield/core/event_bus_events/on_forgot_password_verification_code_received.dart';
import 'package:zenshield/core/utils/utils.dart';
import 'package:zenshield/core/utils/platform_utils.dart';
import 'package:zenshield/feature/auth/data/auth_user_use_case.dart';
import 'package:zenshield/feature/auth/data/model/auth_models.dart';
import 'package:zenshield/feature/deep_links/domain/deep_link_error.dart';
import 'package:zenshield/feature/auth/presentation/auth_side_effect.dart';
import 'package:zenshield/feature/auth/presentation/state/auth_state.dart';
import 'package:zenshield/core/utils/mixins.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:window_manager/window_manager.dart';

part 'auth_event.dart';

class AuthBloc extends SideEffectBloc<AuthEvent, AuthState, AuthSideEffect>
    with LaunchUrl<AuthEvent, AuthState, AuthSideEffect> {
  AuthBloc({
    required Talker logger,
    required AbstractAuthUserUseCase authUseCase,
    required EventBus eventBus,
  }) : _logger = logger,
       _authUseCase = authUseCase,
       _eventBus = eventBus,
       super(AuthState.initial()) {
    _logger.info('AuthBloc initialized');
    on<AuthLoginButtonPressed>(_onLoginButtonPressed);
    on<AuthSignUpButtonPressed>(_onSignUpButtonPressed);
    on<AuthEmailChanged>(_onEmailChanged);
    on<AuthPasswordChanged>(_onPasswordChanged);
    on<AuthConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<AuthBackButtonPressed>(_onBackButtonPressed);
    on<AuthNavigateToSignUpPressed>(_onNavigateToSignUpPressed);
    on<AuthNavigateToResetPasswordPressed>(_onNavigateToResetPasswordPressed);
    on<AuthTermsOfUseDesktopTapped>(_onTermsOfUseDesktopTapped);
    on<AuthPrivacyPolicyDesktopTapped>(_onPrivacyPolicyDesktopTapped);
    on<AuthGoogleSignInPressed>(_onGoogleSignInPressed);
    on<AuthFacebookSignInPressed>(_onFacebookSignInPressed);
    on<AuthAppleSignInPressed>(_onAppleSignInPressed);
    on<AuthTermsAcceptedChanged>(_onTermsAcceptedChanged);
    on<AuthDeepLinkErrorEvent>(_onDeepLinkError);
    on<AuthEmailVerificationCodeReceivedEvent>(
      _onEmailVerificationCodeReceived,
    );
    on<AuthForgotPasswordCodeReceivedEvent>(_onForgotPasswordCodeReceived);

    _deepLinkErrorSubscription = _eventBus.on<OnDeepLinkError>().listen((
      event,
    ) {
      add(AuthDeepLinkErrorEvent(error: event.error));
    });

    _emailVerificationCodeSubscription = _eventBus
        .on<OnEmailVerificationCodeReceived>()
        .listen((event) {
          add(AuthEmailVerificationCodeReceivedEvent(code: event.code));
        });

    _forgotPasswordCodeSubscription = _eventBus
        .on<OnForgotPasswordCodeReceived>()
        .listen((event) {
          add(AuthForgotPasswordCodeReceivedEvent(code: event.code));
        });
  }

  // Dependencies
  final Talker _logger;
  final AbstractAuthUserUseCase _authUseCase;
  final EventBus _eventBus;

  // Subscriptions
  StreamSubscription<OnDeepLinkError>? _deepLinkErrorSubscription;
  StreamSubscription<OnEmailVerificationCodeReceived>?
  _emailVerificationCodeSubscription;
  StreamSubscription<OnForgotPasswordCodeReceived>?
  _forgotPasswordCodeSubscription;

  @override
  Future<void> close() async {
    _unsubscribeFromDeepLinks();
    return super.close();
  }

  bool get passwordsMatch =>
      state.password == state.confirmPassword && state.password.isNotEmpty;

  bool _isButtonEnabled(
    String email,
    String password,
    String confirmPassword,
    bool isLoading,
  ) {
    return email.isNotEmpty &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty &&
        password == confirmPassword &&
        !isLoading;
  }

  bool _validateEmail(String email) {
    return Utils.isEmailValid(email);
  }

  bool _validatePassword({required String password, String? confirmPassword}) {
    if (!state.isPasswordValid) {
      _logger.warning('Password validation failed');
      return false;
    }

    if (confirmPassword != null && password != confirmPassword) {
      _logger.warning('Passwords do not match');
      return false;
    }

    return true;
  }

  Future<bool> _handleAuthOperation({
    required Future<void> Function() operation,
    required String errorMessage,
    required AuthSideEffect errorSideEffect,
    required Emitter<AuthState> emit,
  }) async {
    emit(state.copyWith(isLoading: true));

    try {
      await operation();
      _logger.info('Operation successful');

      emit(state.copyWith(isLoading: false, isSuccess: true));
      return true;
    } catch (e) {
      _logger.warning('Operation failed: $e');

      emit(state.copyWith(isLoading: false));
      if (!_isEmailEmploymentError(e)) {
        produceSideEffect(errorSideEffect);
      }
      return false;
    }
  }

  Future<void> _launchPolicyUrl({
    required String languageCode,
    required Uri Function({required String languageCode}) urlBuilder,
  }) async {
    _logger.info('URL launch with language code: $languageCode');
    final url = urlBuilder(languageCode: languageCode);
    await launchExternalUrl(url);
  }

  bool _isWrongCredentialsError(Object error) =>
      error is DioException &&
      error.response != null &&
      error.response!.statusCode == 500 &&
      error.response!.data != null &&
      error.response!.data.toString().contains("wrong password");

  bool _isEmailEmploymentError(Object error) =>
      error is DioException &&
      error.response != null &&
      error.response!.statusCode == 500 &&
      error.response!.data != null &&
      error.response!.data.toString().contains("email is employment");

  bool _isEmailNotConfirmedOrRegisteredError(Object error) {
    return error is DioException &&
        error.response != null &&
        error.response!.statusCode == 500 &&
        error.response!.data != null &&
        error.response!.data.toString().contains(
          "email is not confirmed or registered",
        );
  }

  Future<void> _onLoginButtonPressed(
    AuthLoginButtonPressed event,
    Emitter<AuthState> emit,
  ) async {
    _logger.info('AuthLoginButtonPressed: email=${event.email}');

    if (!_validateEmail(event.email)) {
      _logger.warning('Invalid email format: ${event.email}');
      produceSideEffect(AuthShowInvalidEmailDialog());
      return;
    }

    if (!Utils.isPasswordValid(event.password)) {
      _logger.warning('Invalid password format: ${event.password}');
      produceSideEffect(ShowInvalidPasswordDialog());
      return;
    }

    emit(state.copyWith(isLoading: true));

    try {
      await _authUseCase.login(event.email, event.password);

      _logger.info('Login successful');

      emit(state.copyWith(isLoading: false, isSuccess: true));

      produceSideEffect(AuthNavigateToHome());
    } catch (e) {
      _logger.warning('Login failed: $e');

      emit(state.copyWith(isLoading: false));

      if (_isWrongCredentialsError(e)) {
        _logger.info('Wrong credentials error');
        produceSideEffect(ShowWrongCredentialsDialog());
      } else if (_isEmailEmploymentError(e)) {
        _logger.info('Email employment error');
        produceSideEffect(ShowEmailEmploymentErrorDialog());
      } else if (_isEmailNotConfirmedOrRegisteredError(e)) {
        _logger.info('Email not confirmed or registered error');
        produceSideEffect(ShowEmailNotConfirmedOrRegisteredErrorDialog());
      } else {
        _logger.info('Login error');
        produceSideEffect(ShowLoginErrorDialog());
      }
    }
  }

  Future<void> _onSignUpButtonPressed(
    AuthSignUpButtonPressed event,
    Emitter<AuthState> emit,
  ) async {
    _logger.info('AuthSignUpButtonPressed: email=${event.email}');

    if (!_validateEmail(event.email)) {
      _logger.warning('Invalid email format: ${event.email}');
      produceSideEffect(AuthShowInvalidEmailDialog());
      return;
    }

    final isPasswordValid = _validatePassword(
      password: event.password,
      confirmPassword: event.confirmPassword,
    );
    if (!isPasswordValid) {
      emit(state.copyWith(showValidationError: true));

      if (!Utils.isPasswordValid(event.password)) {
        produceSideEffect(ShowInvalidPasswordDialog());
      }
      return;
    }

    final isSuccess = await _handleAuthOperation(
      operation: () async {
        try {
          await _authUseCase.registerWithPassword(
            event.email,
            AuthType.register,
            password: event.password,
          );

          await _authUseCase.saveDeeplinkSessionData(
            email: event.email,
            authType: AuthType.register,
            password: event.password,
          );
        } catch (e) {
          if (_isEmailEmploymentError(e)) {
            _logger.info('Email employment error');
            produceSideEffect(ShowEmailEmploymentErrorDialog());
          }
          rethrow;
        }
      },
      errorMessage: 'Error sending deeplink',
      errorSideEffect: ShowRegistrationErrorDialog(),
      emit: emit,
    );

    if (isSuccess) {
      emit(state.copyWith(isSuccess: false));
      _unsubscribeFromDeepLinks();

      produceSideEffect(AuthNavigateToCheckInbox(email: event.email));
    }
  }

  void _onEmailChanged(AuthEmailChanged event, Emitter<AuthState> emit) {
    _logger.info('Email changed: ${event.email}');
    emit(
      state.copyWith(
        email: event.email,
        showValidationError: false,
        isButtonEnabled: _isButtonEnabled(
          event.email,
          state.password,
          state.confirmPassword,
          state.isLoading,
        ),
      ),
    );
  }

  void _onPasswordChanged(AuthPasswordChanged event, Emitter<AuthState> emit) {
    _logger.info('Password changed');
    final password = event.password;
    final isPasswordValid = Utils.isPasswordValid(password);

    emit(
      state.copyWith(
        password: password,
        isPasswordValid: isPasswordValid,
        showValidationError: false,
        isButtonEnabled: _isButtonEnabled(
          state.email,
          password,
          state.confirmPassword,
          state.isLoading,
        ),
      ),
    );
  }

  void _onConfirmPasswordChanged(
    AuthConfirmPasswordChanged event,
    Emitter<AuthState> emit,
  ) {
    _logger.info('Confirm password changed');

    emit(
      state.copyWith(
        confirmPassword: event.confirmPassword,
        isButtonEnabled: _isButtonEnabled(
          state.email,
          state.password,
          event.confirmPassword,
          state.isLoading,
        ),
      ),
    );
  }

  void _onBackButtonPressed(
    AuthBackButtonPressed event,
    Emitter<AuthState> emit,
  ) {
    emit(AuthState.initial());
    produceSideEffect(AuthNavigateBack());
  }

  void _onNavigateToSignUpPressed(
    AuthNavigateToSignUpPressed event,
    Emitter<AuthState> emit,
  ) {
    _logger.info('Navigating to signup');
    produceSideEffect(AuthNavigateToSignUp());
  }

  void _onNavigateToResetPasswordPressed(
    AuthNavigateToResetPasswordPressed event,
    Emitter<AuthState> emit,
  ) {
    _unsubscribeFromDeepLinks();
    emit(AuthState.initial());
    produceSideEffect(AuthNavigateToResetPassword());
  }

  Future<void> _onTermsOfUseDesktopTapped(
    AuthTermsOfUseDesktopTapped event,
    Emitter<AuthState> emit,
  ) async {
    await _launchPolicyUrl(
      languageCode: event.languageCode,
      urlBuilder: Urls.endUserLicenseAgreement,
    );
  }

  Future<void> _onPrivacyPolicyDesktopTapped(
    AuthPrivacyPolicyDesktopTapped event,
    Emitter<AuthState> emit,
  ) async {
    await _launchPolicyUrl(
      languageCode: event.languageCode,
      urlBuilder: Urls.privacyPolicy,
    );
  }

  Future<void> _onGoogleSignInPressed(
    AuthGoogleSignInPressed event,
    Emitter<AuthState> emit,
  ) async {
    _logger.info('Google sign in pressed');

    try {
      await _authUseCase.authWithGoogle();

      _logger.info('Google sign in successful');

      if (PlatformUtils.isDesktop) {
        await windowManager.show();
        await windowManager.focus();
      }

      emit(state.copyWith(isSuccess: true));

      produceSideEffect(AuthNavigateToHome());
    } catch (e) {
      _logger.warning('Google sign in failed: $e');
      produceSideEffect(ShowLoginErrorDialog());
    }
  }

  Future<void> _onFacebookSignInPressed(
    AuthFacebookSignInPressed event,
    Emitter<AuthState> emit,
  ) async {
    _logger.info('Facebook sign in pressed');

    try {
      await _authUseCase.authWithFacebook();

      _logger.info('Facebook sign in successful');

      if (PlatformUtils.isDesktop) {
        await windowManager.show();
        await windowManager.focus();
      }

      emit(state.copyWith(isSuccess: true));

      produceSideEffect(AuthNavigateToHome());
    } catch (e) {
      _logger.warning('Facebook sign in failed: $e');

      produceSideEffect(ShowLoginErrorDialog());
    }
  }

  Future<void> _onAppleSignInPressed(
    AuthAppleSignInPressed event,
    Emitter<AuthState> emit,
  ) async {
    _logger.info('Apple sign in pressed');

    try {
      await _authUseCase.authWithApple();

      _logger.info('Apple sign in successful');

      emit(state.copyWith(isSuccess: true));

      produceSideEffect(AuthNavigateToHome());
    } catch (e) {
      _logger.warning('Apple sign in failed: $e');
      produceSideEffect(ShowLoginErrorDialog());
    }
  }

  void _onTermsAcceptedChanged(
    AuthTermsAcceptedChanged event,
    Emitter<AuthState> emit,
  ) {
    _logger.info('Terms accepted changed: ${event.isAccepted}');
    emit(state.copyWith(isTermsAccepted: event.isAccepted));
  }

  void _onDeepLinkError(AuthDeepLinkErrorEvent event, Emitter<AuthState> emit) {
    _logger.warning('Deep link error on auth screen: ${event.error}');
    switch (event.error) {
      case DeepLinkError.unknownAction:
        produceSideEffect(ShowDeepLinkUnknownActionError());
        break;
      case DeepLinkError.missingCodeParameter:
        produceSideEffect(ShowDeepLinkMissingCodeParameterError());
        break;
    }
  }

  void _unsubscribeFromDeepLinks() {
    _deepLinkErrorSubscription?.cancel();
    _emailVerificationCodeSubscription?.cancel();
    _forgotPasswordCodeSubscription?.cancel();
    _deepLinkErrorSubscription = null;
    _emailVerificationCodeSubscription = null;
    _forgotPasswordCodeSubscription = null;
    _logger.info('Unsubscribed from deep links');
  }

  Future<void> _onEmailVerificationCodeReceived(
    AuthEmailVerificationCodeReceivedEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      _logger.info(
        'Email verification code received via deep link: ${event.code}',
      );

      final session = _authUseCase.session;
      if (session.email == null || session.authType == null) {
        _logger.info('Session data is missing');
        produceSideEffect(ShowDeepLinkSessionDataMissingError());
        return;
      }

      if (session.authType != AuthType.register) {
        _logger.warning(
          'Wrong action: expected register, got ${session.authType}',
        );
        produceSideEffect(ShowDeepLinkWrongActionError());
        return;
      }

      await _authUseCase.verifyCode(
        session.email!,
        event.code,
        session.authType!,
      );

      _logger.info('Verification code verified');

      produceSideEffect(AuthNavigateToHome());
    } catch (e, stackTrace) {
      _logger.error('Failed to verify code', e, stackTrace);
      produceSideEffect(ShowDeepLinkVerificationError());
    }
  }

  Future<void> _onForgotPasswordCodeReceived(
    AuthForgotPasswordCodeReceivedEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      _logger.info(
        'Forgot password code received via deep link: ${event.code}',
      );

      final session = _authUseCase.session;
      if (session.email == null || session.authType == null) {
        _logger.info('Session data is missing');
        produceSideEffect(ShowDeepLinkSessionDataMissingError());
        return;
      }

      if (session.authType != AuthType.changePass) {
        _logger.warning(
          'Wrong action: expected changePass, got ${session.authType}',
        );
        produceSideEffect(ShowDeepLinkWrongActionError());
        return;
      }

      await _authUseCase.saveDeeplinkSessionData(
        email: session.email!,
        authType: AuthType.changePass,
        password: event.code,
      );
      _logger.info('Forgot password code saved');

      _unsubscribeFromDeepLinks();
      produceSideEffect(AuthNavigateToNewPassword());
    } catch (e, stackTrace) {
      _logger.error('Failed to save forgot password code', e, stackTrace);
      produceSideEffect(ShowDeepLinkVerificationError());
    }
  }
}
