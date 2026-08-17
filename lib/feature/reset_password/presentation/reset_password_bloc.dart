import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenshield/core/utils/utils.dart';
import 'package:zenshield/feature/auth/data/auth_user_use_case.dart';
import 'package:zenshield/feature/reset_password/presentation/reset_password_event.dart';
import 'package:zenshield/feature/reset_password/presentation/reset_password_side_effect.dart';
import 'package:zenshield/feature/reset_password/presentation/state/reset_password_state.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:talker_flutter/talker_flutter.dart';

class ResetPasswordBloc extends SideEffectBloc<ResetPasswordEvent,
    ResetPasswordState, ResetPasswordSideEffect> {
  ResetPasswordBloc({
    required AbstractAuthUserUseCase authUseCase,
    required Talker logger,
  })  : _authUseCase = authUseCase,
        _logger = logger,
        super(ResetPasswordState.initial()) {
    on<EmailChanged>(_onEmailChanged);
    on<ResetPasswordRequested>(_onResetPasswordRequested);
  }

  final AbstractAuthUserUseCase _authUseCase;
  final Talker _logger;

  void _onEmailChanged(EmailChanged event, Emitter<ResetPasswordState> emit) {
    final email = event.email;
    final isValidEmail = Utils.isEmailValid(email);

    emit(
      state.copyWith(
        email: email,
        isEmailValid: isValidEmail,
        isButtonEnabled: email.isNotEmpty,
        showValidationErrors: false,
      ),
    );
  }

  Future<void> _onResetPasswordRequested(
    ResetPasswordRequested event,
    Emitter<ResetPasswordState> emit,
  ) async {
    if (!state.isEmailValid) {
      emit(state.copyWith(
        showValidationErrors: true,
        isEmailValid: false,
        isButtonEnabled: false,
      ));
      return;
    }

    emit(state.copyWith(isLoading: true));

    try {
      _logger.info('Reset password requested for email: ${state.email}');

      await _authUseCase.forgotPassword(state.email);

      emit(state.copyWith(isLoading: false));
      produceSideEffect(ResetPasswordSuccessSideEffect(state.email));
    } catch (e) {
      _logger.warning('Failed to request password reset: $e');
      emit(state.copyWith(isLoading: false));

      if (_isEmailNotConfirmedOrRegisteredError(e)) {
        _logger.info('Email not confirmed or registered error');
        produceSideEffect(ResetPasswordEmailNotRegisteredError());
      } else {
        produceSideEffect(ResetPasswordErrorSideEffect(e.toString()));
      }
    }
  }

  bool _isEmailNotConfirmedOrRegisteredError(Object error) {
    return error is DioException &&
        error.response != null &&
        error.response!.statusCode == 500 &&
        error.response!.data != null &&
        error.response!.data
            .toString()
            .contains("email is not confirmed or registered");
  }
}
