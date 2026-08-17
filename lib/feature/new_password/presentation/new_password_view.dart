import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenshield/core/utils/utils.dart';
import 'package:zenshield/di/injection_container.dart';
import 'package:zenshield/feature/auth/data/auth_user_use_case.dart';
import 'package:zenshield/gen/assets.gen.dart';
import 'package:zenshield/l10n/app_localizations.dart';
import 'package:zenshield/core/widgets/black_circular_progress_indicator.dart';
import 'package:zenshield/feature/new_password/presentation/new_password_success_view.dart';
import 'package:zenshield/feature/new_password/presentation/new_password_bloc.dart';
import 'package:zenshield/feature/new_password/presentation/new_password_event.dart';
import 'package:zenshield/feature/new_password/presentation/new_password_side_effect.dart';
import 'package:zenshield/feature/new_password/presentation/state/new_password_state.dart';
import 'package:zenshield/config/theme/app_colors/app_colors.dart';
import 'package:zenshield/config/theme/app_text_styles/app_text_styles.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:talker_flutter/talker_flutter.dart';

class NewPasswordView extends StatelessWidget {
  const NewPasswordView({super.key});

  static const routeName = '/new_password';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NewPasswordBloc(
        authUseCase: getIt<AbstractAuthUserUseCase>(),
        logger: getIt<Talker>(),
      )..add(InitNewPassword()),
      child: BlocSideEffectListener<NewPasswordBloc, NewPasswordSideEffect>(
        listener: (context, sideEffect) async {
          FocusScope.of(context).unfocus();
          switch (sideEffect) {
            case PasswordChangedSuccessSideEffect():
              Navigator.of(context).pushReplacementNamed(
                ChangePasswordSuccessView.routeName,
              );
            case PasswordChangeErrorSideEffect():
              //TODO: change after server api is implemented
              break;

            case DeeplinkSessionExpiredSideEffect():
              //TODO: Handle deeplink session expired
              break;
          }
        },
        child: const _NewPasswordContent(),
      ),
    );
  }
}

class _NewPasswordContent extends StatefulWidget {
  const _NewPasswordContent();

  @override
  State<_NewPasswordContent> createState() => _NewPasswordContentState();
}

class _NewPasswordContentState extends State<_NewPasswordContent> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final FocusNode _newPasswordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _newPasswordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors();
    final bloc = context.watch<NewPasswordBloc>();
    final state = bloc.state;

    var showValidationErrors = state.showValidationErrors;
    final doPasswordsMatch = state.doPasswordsMatch;

    return Listener(
      onPointerDown: (_) {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: appColors.background,
        body: SafeArea(
          child: Column(
            children: [
              const _Header(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      _DescriptionSection(),
                      const SizedBox(height: 43),
                      _buildNewPassword(state),
                      const SizedBox(height: 16),
                      _buildConfirmPassword(state),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
              if ((!doPasswordsMatch && showValidationErrors) ||
                  (state.password.isNotEmpty &&
                      Utils.hasInvalidPasswordCharacters(state.password)) ||
                  (state.confirmPassword.isNotEmpty &&
                      Utils.hasInvalidPasswordCharacters(state.confirmPassword)))
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _ValidationMessages(
                    showPasswordsDontMatch:
                        !doPasswordsMatch && showValidationErrors,
                    showInvalidCharsHint:
                        (state.password.isNotEmpty &&
                            Utils.hasInvalidPasswordCharacters(state.password)) ||
                        (state.confirmPassword.isNotEmpty &&
                            Utils.hasInvalidPasswordCharacters(
                                state.confirmPassword)),
                  ),
                ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
                child: _SubmitButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNewPassword(NewPasswordState state) {
    final l10n = AppLocalizations.of(context);
    final doPasswordsMatch = state.doPasswordsMatch;
    final isPasswordValid = state.isPasswordValid;
    final isButtonEnabled = state.isButtonEnabled;
    final showValidationErrors = state.showValidationErrors;
    final newHasFocus = _newPasswordFocusNode.hasFocus;
    final newHasText = _newPasswordController.text.isNotEmpty;
    final confirmHasText = _confirmPasswordController.text.isNotEmpty;

    final hasInvalidChars = state.password.isNotEmpty &&
        Utils.hasInvalidPasswordCharacters(state.password);
    final colors = AppColors();
    final borderColor = _getBorderColor(
      hasFocus: newHasFocus,
      hasText: newHasText,
      hasError: hasInvalidChars ||
          (!doPasswordsMatch &&
              newHasText &&
              confirmHasText &&
              showValidationErrors),
      isValid:
          isPasswordValid && doPasswordsMatch && newHasText && confirmHasText,
      colors: colors,
    );
    final iconColor = _getIconColor(
      hasFocus: newHasFocus,
      hasText: newHasText,
      hasError: hasInvalidChars ||
          (!doPasswordsMatch &&
              newHasText &&
              confirmHasText &&
              showValidationErrors),
      isValid:
          isPasswordValid && doPasswordsMatch && newHasText && confirmHasText,
      colors: colors,
    );

    return _PasswordField(
      controller: _newPasswordController,
      focusNode: _newPasswordFocusNode,
      label: l10n?.changePasswordNewPasswordLabel ?? 'New Password',
      hint: l10n?.changePasswordNewPasswordHint ?? 'Create your new password',
      borderColor: borderColor,
      iconColor: iconColor,
      onChanged: (value) {
        context.read<NewPasswordBloc>().add(PasswordChanged(value));
      },
      onSubmitted: (_) {
        if (isButtonEnabled) {
          context.read<NewPasswordBloc>().add(ChangePasswordRequested());
        }
      },
      textInputAction: TextInputAction.next,
    );
  }

  Widget _buildConfirmPassword(NewPasswordState state) {
    final l10n = AppLocalizations.of(context);
    final doPasswordsMatch = state.doPasswordsMatch;
    final isPasswordValid = state.isPasswordValid;
    final isButtonEnabled = state.isButtonEnabled;
    final showValidationErrors = state.showValidationErrors;
    final hasFocus = _confirmPasswordFocusNode.hasFocus;
    final hasText = _confirmPasswordController.text.isNotEmpty;
    final otherHasText = _newPasswordController.text.isNotEmpty;

    final hasInvalidChars = state.confirmPassword.isNotEmpty &&
        Utils.hasInvalidPasswordCharacters(state.confirmPassword);
    final colors = AppColors();
    final borderColor = _getBorderColor(
      hasFocus: hasFocus,
      hasText: hasText,
      hasError: hasInvalidChars ||
          (!doPasswordsMatch &&
              hasText &&
              otherHasText &&
              showValidationErrors),
      isValid: isPasswordValid && doPasswordsMatch && hasText && otherHasText,
      colors: colors,
    );
    final iconColor = _getIconColor(
      hasFocus: hasFocus,
      hasText: hasText,
      hasError: hasInvalidChars ||
          (!doPasswordsMatch &&
              hasText &&
              otherHasText &&
              showValidationErrors),
      isValid: isPasswordValid && doPasswordsMatch && hasText && otherHasText,
      colors: colors,
    );

    return _PasswordField(
      controller: _confirmPasswordController,
      focusNode: _confirmPasswordFocusNode,
      label: l10n?.changePasswordConfirmPasswordLabel ?? 'Confirm New Password',
      hint: l10n?.changePasswordConfirmPasswordHint ??
          'Confirm your new password',
      borderColor: borderColor,
      iconColor: iconColor,
      onChanged: (value) {
        context.read<NewPasswordBloc>().add(ConfirmPasswordChanged(value));
      },
      onSubmitted: (_) {
        if (isButtonEnabled) {
          context.read<NewPasswordBloc>().add(ChangePasswordRequested());
        }
      },
      textInputAction: TextInputAction.done,
    );
  }

  static Color _getBorderColor({
    required bool hasFocus,
    required bool hasText,
    required bool hasError,
    required bool isValid,
    required AppColors colors,
  }) {
    if (hasFocus) {
      if (hasError) {
        return colors.red;
      } else if (isValid) {
        return colors.green;
      } else {
        return colors.black;
      }
    } else if (hasText) {
      if (hasError) {
        return colors.red;
      } else if (isValid) {
        return colors.green;
      } else {
        return Colors.transparent;
      }
    }
    return Colors.transparent;
  }

  static Color _getIconColor({
    required bool hasFocus,
    required bool hasText,
    required bool hasError,
    required bool isValid,
    required AppColors colors,
  }) {
    if (hasFocus) {
      if (hasError) {
        return colors.red;
      } else if (isValid) {
        return colors.black;
      } else {
        return colors.black;
      }
    } else if (hasText) {
      if (hasError) {
        return colors.red;
      } else if (isValid) {
        return colors.black;
      } else {
        return colors.grayLight2;
      }
    }
    return colors.grayLight2;
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.controller,
    required this.focusNode,
    required this.label,
    required this.hint,
    required this.borderColor,
    required this.iconColor,
    required this.onChanged,
    required this.onSubmitted,
    required this.textInputAction,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String label;
  final String hint;
  final Color borderColor;
  final Color iconColor;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final TextInputAction textInputAction;

  @override
  Widget build(BuildContext context) {
    final appTextStyles = AppTextStyles();
    final colors = AppColors();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: appTextStyles.interRegular12(
            color: colors.grayDark.withValues(alpha: 0.8),
          ),
        ),
        const SizedBox(height: 11),
        Container(
          height: 58,
          decoration: BoxDecoration(
            color: colors.white,
            borderRadius: BorderRadius.circular(29.5),
            border: Border.all(
              color: borderColor,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.07),
                blurRadius: 200,
                blurStyle: BlurStyle.normal,
                offset: const Offset(0, 170),
                spreadRadius: -100,
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            textInputAction: textInputAction,
            obscureText: true,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: appTextStyles.latoRegular16(
                color: colors.grayLight2,
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(17),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      iconColor,
                      BlendMode.srcIn,
                    ),
                    child: Assets.images.password.image(
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(29.5),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<NewPasswordBloc>();
    final state = bloc.state;
    final colors = AppColors();
    final appTextStyles = AppTextStyles();
    final l10n = AppLocalizations.of(context);
    final isButtonEnabled = state.isPasswordValid && state.isPasswordValid;
    final isLoading = state.isLoading;

    final shouldBeBlack =
        state.isPasswordValid && state.confirmPassword.isNotEmpty;
    final buttonColor = shouldBeBlack ? colors.black : colors.white;
    final textColor = shouldBeBlack ? colors.white : colors.grayVeryLight;

    return Center(
      child: SizedBox(
        width: 325,
        height: 57,
        child: ElevatedButton(
          onPressed: isButtonEnabled && !isLoading
              ? () {
                  context
                      .read<NewPasswordBloc>()
                      .add(ChangePasswordRequested());
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            foregroundColor: textColor,
            side: shouldBeBlack
                ? null
                : BorderSide(
                    color: colors.grayVeryLight,
                    width: 1,
                  ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(29),
            ),
            elevation: 0,
            disabledBackgroundColor: buttonColor,
            disabledForegroundColor: textColor,
            splashFactory: NoSplash.splashFactory,
          ),
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: BlackCircularProgressIndicator(strokeWidth: 2),
                )
              : Text(
                  l10n?.changePasswordButton ?? 'Continue',
                  style: appTextStyles.nunitoSansBold18(
                    color: textColor,
                  ),
                ),
        ),
      ),
    );
  }
}

class _ValidationMessages extends StatelessWidget {
  const _ValidationMessages({
    required this.showPasswordsDontMatch,
    required this.showInvalidCharsHint,
  });

  final bool showPasswordsDontMatch;
  final bool showInvalidCharsHint;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors();
    final appTextStyles = AppTextStyles();
    final l10n = AppLocalizations.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showPasswordsDontMatch)
          Center(
            child: Text(
              l10n?.changePasswordPasswordsDontMatch ??
                  "These passwords don't match",
              style: appTextStyles.latoBold16(
                color: colors.red,
              ),
            ),
          ),
        if (showPasswordsDontMatch && showInvalidCharsHint)
          const SizedBox(height: 8),
        if (showInvalidCharsHint)
          Center(
            child: Text(
              l10n?.authPasswordOnlyLatinHint ??
                  'Only Latin characters (A-Z, a-z, 0-9, and special characters)',
              style: appTextStyles.interRegular12(
                color: colors.red,
              ),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors();
    final appTextStyles = AppTextStyles();
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Assets.images.chevronLeft.image(
                width: 24,
                height: 24,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              l10n?.changePasswordTitle ?? 'Change Password',
              style: appTextStyles.interSemiBold16(
                color: appColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DescriptionSection extends StatelessWidget {
  const _DescriptionSection();

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors();
    final appTextStyles = AppTextStyles();
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        Text(
          l10n?.changePasswordDescription ??
              'Create your new password for Zenshiekd VPN and type new password twice.',
          style: appTextStyles.interRegular14(
            color: appColors.black,
          ),
        ),
      ],
    );
  }
}
