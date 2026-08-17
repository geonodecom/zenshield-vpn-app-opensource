import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zenshield/core/utils/utils.dart';
import 'package:zenshield/feature/auth/data/auth_user_use_case.dart';
import 'package:zenshield/feature/new_password/presentation/new_password_event.dart';
import 'package:zenshield/feature/new_password/presentation/new_password_side_effect.dart';
import 'package:zenshield/feature/new_password/presentation/state/new_password_state.dart';

class NewPasswordBloc extends SideEffectBloc<NewPasswordEvent, NewPasswordState,
    NewPasswordSideEffect> {
  NewPasswordBloc({
    required AbstractAuthUserUseCase authUseCase,
    required Talker logger,
  })  : _authUseCase = authUseCase,
        _logger = logger,
        super(NewPasswordState.initial()) {
    on<InitNewPassword>(_onInitNewPassword);
    on<PasswordChanged>(_onPasswordChanged);
    on<ConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<ChangePasswordRequested>(_onChangePasswordRequested);
  }

  final AbstractAuthUserUseCase _authUseCase;
  final Talker _logger;

  bool _isButtonEnabled(
    String password,
    String confirmPassword,
    bool isLoading,
  ) {
    return password.isNotEmpty &&
        confirmPassword.isNotEmpty &&
        password == confirmPassword &&
        !isLoading;
  }

  bool _validatePassword({
    required String password,
    String? confirmPassword,
  }) {
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

  void _onInitNewPassword(
    InitNewPassword event,
    Emitter<NewPasswordState> emit,
  ) {
    _logger.info('Initializing new password screen');
    final authData = _authUseCase.session;

    if (authData.email == null) {
      _logger.warning('Email is null, cannot proceed with password change');
      produceSideEffect(const PasswordChangeErrorSideEffect());
      return;
    }

    _logger
        .info('New password screen initialized for email: ${authData.email}');
    emit(
      state.copyWith(
        email: authData.email ?? '',
        password: '',
        confirmPassword: '',
        isPasswordValid: false,
        doPasswordsMatch: false,
        isButtonEnabled: false,
        showValidationErrors: false,
      ),
    );
  }

  void _onPasswordChanged(
    PasswordChanged event,
    Emitter<NewPasswordState> emit,
  ) {
    final password = event.password;
    final isPasswordValid = Utils.isPasswordValid(password);
    final doPasswordsMatch = password == state.confirmPassword;

    emit(
      state.copyWith(
        password: password,
        isPasswordValid: isPasswordValid,
        doPasswordsMatch: doPasswordsMatch,
        showValidationErrors: false,
        isButtonEnabled: _isButtonEnabled(
          password,
          state.confirmPassword,
          state.isLoading,
        ),
      ),
    );
  }

  void _onConfirmPasswordChanged(
    ConfirmPasswordChanged event,
    Emitter<NewPasswordState> emit,
  ) {
    final confirmPassword = event.confirmPassword;
    final doPasswordsMatch = state.password == confirmPassword;

    emit(
      state.copyWith(
        confirmPassword: confirmPassword,
        doPasswordsMatch: doPasswordsMatch,
        showValidationErrors: false,
        isButtonEnabled: _isButtonEnabled(
          state.password,
          confirmPassword,
          state.isLoading,
        ),
      ),
    );
  }

  Future<void> _onChangePasswordRequested(
    ChangePasswordRequested event,
    Emitter<NewPasswordState> emit,
  ) async {
    _logger.info('User requested to set new password');

    if (!_validatePassword(
      password: state.password,
      confirmPassword: state.confirmPassword,
    )) {
      _logger.warning('Password validation failed during submission');
      emit(state.copyWith(showValidationErrors: true));
      return;
    }

    try {
      _logger.info('Attempting to set new password');
      emit(state.copyWith(isLoading: true, isButtonEnabled: false));
      final authData = _authUseCase.session;

      if (authData.email == null) {
        emit(state.copyWith(isLoading: false, isButtonEnabled: true));
        produceSideEffect(const PasswordChangeErrorSideEffect());
        return;
      }

      final email = authData.email ?? '';

      if (authData.resetToken == null) {
        _logger.error('Reset token is missing. Cannot reset password.');
        emit(state.copyWith(isLoading: false, isButtonEnabled: true));
        produceSideEffect(const PasswordChangeErrorSideEffect());
        return;
      }

      _logger.info('Resetting password for email: $email using token');
      await _authUseCase.resetPassword(
        email: email,
        password: state.password,
        token: authData.resetToken!,
      );

      _logger.info('Password successfully changed');
      emit(state.copyWith(isLoading: false, isButtonEnabled: true));

      await _authUseCase.clearSession();

      produceSideEffect(const PasswordChangedSuccessSideEffect());
    } catch (e) {
      _logger.error('Password change failed: $e');
      emit(state.copyWith(isLoading: false, isButtonEnabled: true));
      produceSideEffect(const PasswordChangeErrorSideEffect());
    }
  }
}
