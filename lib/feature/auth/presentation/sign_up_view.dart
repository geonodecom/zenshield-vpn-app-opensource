import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenshield/config/theme/app_colors/app_colors.dart';
import 'package:zenshield/config/theme/app_text_styles/app_text_styles.dart';
import 'package:zenshield/core/utils/mixins.dart';
import 'package:zenshield/gen/assets.gen.dart';
import 'package:zenshield/core/managers/analytics_manager.dart';
import 'package:zenshield/di/injection_container.dart';
import 'package:zenshield/feature/auth/presentation/auth_bloc.dart';
import 'package:zenshield/feature/auth/presentation/widgets/auth_email_field.dart';
import 'package:zenshield/feature/auth/presentation/widgets/auth_header.dart';
import 'package:zenshield/feature/auth/presentation/widgets/auth_password_field.dart';
import 'package:zenshield/feature/auth/presentation/widgets/auth_primary_button.dart';
import 'package:zenshield/feature/auth/presentation/widgets/auth_social_login_row.dart';
import 'package:zenshield/feature/auth/presentation/widgets/auth_terms_checkbox.dart';
import 'package:zenshield/l10n/app_localizations.dart';

/// Sign-up page, pushed on top of [AuthView] (the login page) — reuses the
/// same [AuthBloc] instance via [BlocProvider.value] so validation/loading
/// state stays consistent across both pages.
class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SignUpContent();
  }
}

class _SignUpContent extends StatefulWidget {
  const _SignUpContent();

  @override
  State<_SignUpContent> createState() => _SignUpContentState();
}

class _SignUpContentState extends State<_SignUpContent>
    with AnalyticsEventSender {
  @override
  AbstractAnalyticsManager get analyticsManager =>
      getIt<AbstractAnalyticsManager>();

  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final authBloc = context.read<AuthBloc>();
    final state = authBloc.state;
    _emailController = TextEditingController(text: state.email);
    _passwordController = TextEditingController(text: state.password);
    // Mirror the current text into sign-up-specific validation (confirm
    // password + terms) since this page starts fresh each time it's opened.
    authBloc.add(AuthEmailChanged(state.email));
    authBloc.add(AuthPasswordChanged(state.password));
    authBloc.add(AuthConfirmPasswordChanged(state.password));
    authBloc.add(const AuthTermsAcceptedChanged(false));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _hideKeyboard() {
    FocusScope.of(context).unfocus();
  }

  void _onEmailChanged(String value) {
    context.read<AuthBloc>().add(AuthEmailChanged(value));
  }

  void _onPasswordChanged(String value) {
    final authBloc = context.read<AuthBloc>();
    authBloc.add(AuthPasswordChanged(value));
    authBloc.add(AuthConfirmPasswordChanged(value));
  }

  void _onSignUpPressed() {
    context.read<AuthBloc>().add(
      AuthSignUpButtonPressed(
        email: _emailController.text,
        password: _passwordController.text,
        confirmPassword: _passwordController.text,
      ),
    );
  }

  void _navigateBackToLogin() {
    context.read<AuthBloc>().add(const AuthBackButtonPressed());
  }

  void _onGoogleSignInPressed() {
    context.read<AuthBloc>().add(const AuthGoogleSignInPressed());
  }

  void _onFacebookSignInPressed() {
    context.read<AuthBloc>().add(const AuthFacebookSignInPressed());
  }

  void _onAppleSignInPressed() {
    context.read<AuthBloc>().add(const AuthAppleSignInPressed());
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors();
    final appTextStyles = AppTextStyles();
    final l10n = AppLocalizations.of(context);
    final bloc = context.watch<AuthBloc>();
    final state = bloc.state;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardVisible = keyboardHeight > 0;

    final isEnabled =
        state.isButtonEnabled && state.isTermsAccepted && !state.isLoading;

    return Listener(
      onPointerDown: (_) => _hideKeyboard(),
      child: Scaffold(
        backgroundColor: colors.background,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 0,
                              top: 8,
                              bottom: 8,
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: GestureDetector(
                                onTap: _navigateBackToLogin,
                                child: Container(
                                  width: 38,
                                  height: 38,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.06,
                                        ),
                                        blurRadius: 10,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Assets.images.chevronLeft.image(
                                    width: 22,
                                    height: 22,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          AuthHeader(
                            isKeyboardVisible: isKeyboardVisible,
                            title:
                                l10n?.authSignUpTitle ?? 'Create your account',
                          ),
                          AuthEmailField(
                            controller: _emailController,
                            focusNode: _emailFocusNode,
                            onChanged: _onEmailChanged,
                            onSubmitted: (_) {
                              _passwordFocusNode.requestFocus();
                            },
                          ),
                          const SizedBox(height: 17),
                          AuthPasswordField(
                            controller: _passwordController,
                            focusNode: _passwordFocusNode,
                            onChanged: _onPasswordChanged,
                            hintText:
                                l10n?.passwordHintCreate ??
                                'Create your password',
                            onSubmitted: isEnabled ? _onSignUpPressed : null,
                          ),
                          const SizedBox(height: 20),
                          AuthTermsCheckbox(
                            isAccepted: state.isTermsAccepted,
                            onToggle: () {
                              context.read<AuthBloc>().add(
                                AuthTermsAcceptedChanged(
                                  !state.isTermsAccepted,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          AuthPrimaryButton(
                            text: l10n?.buttonSignUp ?? 'Sign Up',
                            isEnabled: isEnabled,
                            isLoading: state.isLoading,
                            onPressed: _onSignUpPressed,
                          ),
                          const SizedBox(height: 24),
                          GestureDetector(
                            onTap: _navigateBackToLogin,
                            child: Text.rich(
                              TextSpan(
                                text:
                                    l10n?.authHaveAccountPrompt ??
                                    'Already have an account? ',
                                style: appTextStyles.interRegular13(
                                  color: colors.grayLight,
                                ),
                                children: [
                                  TextSpan(
                                    text: l10n?.buttonLogin ?? 'Login',
                                    style: appTextStyles
                                        .interSemiBold16(color: colors.black)
                                        .copyWith(fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.easeInOut,
                        opacity: isKeyboardVisible ? 0.0 : 1.0,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 30),
                          child: AuthSocialLoginRow(
                            onGoogleTap: _onGoogleSignInPressed,
                            onFacebookTap: _onFacebookSignInPressed,
                            onAppleTap: _onAppleSignInPressed,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
