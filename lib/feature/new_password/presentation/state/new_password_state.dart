import 'package:freezed_annotation/freezed_annotation.dart';

part 'new_password_state.freezed.dart';

@freezed
class NewPasswordState with _$NewPasswordState {
  const factory NewPasswordState({
    @Default('') String email,
    @Default('') String password,
    @Default('') String confirmPassword,
    @Default(false) bool isPasswordValid,
    @Default(false) bool doPasswordsMatch,
    @Default(false) bool isButtonEnabled,
    @Default(false) bool isLoading,
    @Default(false) bool showValidationErrors,
  }) = _NewPasswordState;

  factory NewPasswordState.initial() {
    return const NewPasswordState(
      email: '',
      password: '',
      confirmPassword: '',
      isPasswordValid: false,
      doPasswordsMatch: false,
      isButtonEnabled: false,
      isLoading: false,
      showValidationErrors: false,
    );
  }
}
