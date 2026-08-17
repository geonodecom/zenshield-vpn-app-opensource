import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    @Default('') String email,
    @Default('') String password,
    @Default('') String confirmPassword,
    @Default(false) bool isLoading,
    @Default(false) bool isSuccess,
    @Default(false) bool isPasswordValid,
    @Default(false) bool arePasswordsMatching,
    @Default(false) bool showValidationError,
    @Default(false) bool isButtonEnabled,
    @Default(false) bool isTermsAccepted,
    String? otpSessionId,
  }) = _AuthState;

  factory AuthState.initial() {
    return const AuthState(
      email: '',
      password: '',
      confirmPassword: '',
      isLoading: false,
      isSuccess: false,
      isPasswordValid: false,
      arePasswordsMatching: false,
      showValidationError: false,
      otpSessionId: null,
      isButtonEnabled: false,
      isTermsAccepted: false,
    );
  }
}
