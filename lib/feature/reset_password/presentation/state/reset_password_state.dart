import 'package:freezed_annotation/freezed_annotation.dart';

part 'reset_password_state.freezed.dart';

@freezed
class ResetPasswordState with _$ResetPasswordState {
  const factory ResetPasswordState({
    @Default('') String email,
    @Default(false) bool isEmailValid,
    @Default(false) bool isButtonEnabled,
    @Default(false) bool isLoading,
    @Default(false) bool showValidationErrors,
  }) = _ResetPasswordState;

  factory ResetPasswordState.initial() {
    return const ResetPasswordState();
  }
}
