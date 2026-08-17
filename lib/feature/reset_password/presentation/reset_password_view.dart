import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenshield/di/injection_container.dart';
import 'package:zenshield/feature/auth/data/auth_user_use_case.dart';
import 'package:zenshield/gen/assets.gen.dart';
import 'package:zenshield/l10n/app_localizations.dart';
import 'package:zenshield/core/widgets/black_circular_progress_indicator.dart';
import 'package:zenshield/feature/check_inbox/presentation/check_inbox_view.dart';
import 'package:zenshield/feature/check_inbox/presentation/check_inbox_args.dart';
import 'package:zenshield/feature/reset_password/presentation/reset_password_bloc.dart';
import 'package:zenshield/feature/reset_password/presentation/reset_password_event.dart';
import 'package:zenshield/feature/reset_password/presentation/reset_password_side_effect.dart';
import 'package:zenshield/feature/reset_password/presentation/state/reset_password_state.dart';
import 'package:zenshield/core/widgets/error_dialog.dart';
import 'package:zenshield/config/theme/app_colors/app_colors.dart';
import 'package:zenshield/config/theme/app_text_styles/app_text_styles.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:talker_flutter/talker_flutter.dart';

class ResetPasswordView extends StatelessWidget {
  const ResetPasswordView({super.key});

  static const routeName = '/reset_password';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ResetPasswordBloc(
        authUseCase: getIt<AbstractAuthUserUseCase>(),
        logger: getIt<Talker>(),
      ),
      child: BlocSideEffectListener<ResetPasswordBloc, ResetPasswordSideEffect>(
        listener: (context, sideEffect) async {
          FocusScope.of(context).unfocus();
          switch (sideEffect) {
            case ResetPasswordSuccessSideEffect():
              if (context.mounted) {
                await Navigator.of(context).pushNamed(
                  CheckInboxView.routeName,
                  arguments: {
                    'email': sideEffect.email,
                    'verificationType': VerificationType.forgotPassword,
                  },
                );
              }
              break;
            case ResetPasswordErrorSideEffect():
              await _showResetPasswordErrorDialog(context);
              break;
            case ResetPasswordEmailNotRegisteredError():
              await _showEmailNotRegisteredErrorDialog(context);
              break;
          }
        },
        child: const _ResetPasswordContent(),
      ),
    );
  }

  Future<void> _showEmailNotRegisteredErrorDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    await MessageDialog.show(
      context,
      title: l10n?.resetPasswordEmailNotRegisteredTitle ?? 'Email Not Found',
      message:
          l10n?.resetPasswordEmailNotRegisteredText ??
          'The email address you entered is not registered or not confirmed. Please check your email and try again.',
    );
  }

  Future<void> _showResetPasswordErrorDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    await MessageDialog.show(
      context,
      title: l10n?.resetPasswordErrorTitle ?? 'Error',
      message:
          l10n?.resetPasswordErrorText ??
          'An error occurred. Please try again.',
    );
  }
}

class _ResetPasswordContent extends StatefulWidget {
  const _ResetPasswordContent();

  @override
  State<_ResetPasswordContent> createState() => _ResetPasswordContentState();
}

class _ResetPasswordContentState extends State<_ResetPasswordContent> {
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<ResetPasswordBloc>();
    final state = bloc.state;
    final showValidationErrors = state.showValidationErrors;
    final appColors = AppColors();
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final bottomPadding = keyboardHeight > 0 ? 0.0 : 30.0;

    return Scaffold(
      backgroundColor: appColors.background,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: true,
        child: Listener(
          onPointerDown: (_) {
            FocusScope.of(context).unfocus();
          },
          child: Column(
            children: [
              const _Header(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 39),
                              _DescriptionSection(),
                              const SizedBox(height: 40),
                              _buildEmailField(state),
                            ],
                          ),
                        ),
                      ),
                      if (showValidationErrors)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: const _ErrorMessage(),
                        ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: bottomPadding),
                          child: _SubmitButton(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField(ResetPasswordState state) {
    final l10n = AppLocalizations.of(context);
    final hasFocus = _emailFocusNode.hasFocus;
    final hasText = _emailController.text.isNotEmpty;
    final hasError = state.showValidationErrors;

    final colors = AppColors();
    final borderColor = _getBorderColor(
      hasFocus: hasFocus,
      hasError: hasError,
      colors: colors,
    );
    final iconColor = _getIconColor(
      hasFocus: hasFocus,
      hasText: hasText,
      hasError: hasError,
      colors: colors,
    );

    return _EmailField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      label: l10n?.emailAddressLabel ?? 'Gmail',
      hint: l10n?.emailHint ?? 'Enter your Gmail',
      borderColor: borderColor,
      iconColor: iconColor,
      onChanged: (value) {
        context.read<ResetPasswordBloc>().add(EmailChanged(value));
      },
    );
  }

  static Color _getBorderColor({
    required bool hasFocus,
    required bool hasError,
    required AppColors colors,
  }) {
    if (hasError) {
      return colors.red;
    } else if (hasFocus) {
      return colors.black;
    }
    return Colors.transparent;
  }

  static Color _getIconColor({
    required bool hasFocus,
    required bool hasText,
    required bool hasError,
    required AppColors colors,
  }) {
    if (hasError) {
      return colors.red;
    } else if (hasFocus || hasText) {
      return colors.black;
    }
    return colors.grayLight2;
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField({
    required this.controller,
    required this.focusNode,
    required this.label,
    required this.hint,
    required this.borderColor,
    required this.iconColor,
    required this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String label;
  final String hint;
  final Color borderColor;
  final Color iconColor;
  final ValueChanged<String> onChanged;

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
          height: 52,
          decoration: BoxDecoration(
            color: colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: 1.5),
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
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: appTextStyles.latoRegular16(color: colors.grayLight2),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(17),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                    child: Assets.images.email.image(
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
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
    final bloc = context.watch<ResetPasswordBloc>();
    final state = bloc.state;
    final isButtonEnabled = state.isButtonEnabled;
    final isLoading = state.isLoading;

    final colors = AppColors();
    final appTextStyles = AppTextStyles();
    final l10n = AppLocalizations.of(context);

    final buttonColor = isButtonEnabled ? colors.black : colors.white;
    final textColor = isButtonEnabled ? colors.white : colors.grayVeryLight;

    return Center(
      child: Container(
        width: 325,
        height: 57,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(29),
          boxShadow: isButtonEnabled
              ? [
                  BoxShadow(
                    color: colors.black.withValues(alpha: 0.25),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: ElevatedButton(
          onPressed: isButtonEnabled && !isLoading
              ? () {
                  context.read<ResetPasswordBloc>().add(
                    ResetPasswordRequested(),
                  );
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            foregroundColor: textColor,
            side: isButtonEnabled
                ? null
                : BorderSide(color: colors.grayVeryLight, width: 1),
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
                  l10n?.buttonContinue ?? 'Continue',
                  style: appTextStyles.nunitoSansBold18(color: textColor),
                ),
        ),
      ),
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage();

  @override
  Widget build(BuildContext context) {
    final colors = AppColors();
    final appTextStyles = AppTextStyles();
    final l10n = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colors.redBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.redVeryLight),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline_rounded, size: 18, color: colors.red),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              l10n?.resetPasswordEmailDoesntExist ?? "E-Mail doesn't exist",
              style: appTextStyles
                  .latoBold16(color: colors.red)
                  .copyWith(fontSize: 14),
            ),
          ),
        ],
      ),
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
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: SizedBox(
        height: 48,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: appColors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Assets.images.chevronLeft.image(width: 22, height: 22),
                ),
              ),
            ),
            Text(
              l10n?.resetPasswordTitle ?? 'Reset Password',
              style: appTextStyles
                  .interSemiBold16(color: appColors.black)
                  .copyWith(fontSize: 18),
            ),
          ],
        ),
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
        Text(
          l10n?.resetPasswordDescription ??
              'Enter your e-mail and we will send you magic link for verification.',
          style: appTextStyles.interRegular14(color: appColors.black),
        ),
      ],
    );
  }
}
