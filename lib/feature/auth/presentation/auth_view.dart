import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenshield/di/injection_container.dart';
import 'package:zenshield/feature/auth/data/auth_user_use_case.dart';
import 'package:zenshield/l10n/app_localizations.dart';
import 'package:zenshield/feature/auth/presentation/auth_bloc.dart';
import 'package:zenshield/feature/auth/presentation/auth_side_effect.dart';
import 'package:zenshield/feature/auth/presentation/sign_up_view.dart';
import 'package:zenshield/feature/auth/presentation/widgets/auth_email_field.dart';
import 'package:zenshield/feature/auth/presentation/widgets/auth_header.dart';
import 'package:zenshield/feature/auth/presentation/widgets/auth_password_field.dart';
import 'package:zenshield/feature/auth/presentation/widgets/auth_primary_button.dart';
import 'package:zenshield/feature/auth/presentation/widgets/auth_social_login_row.dart';
import 'package:zenshield/feature/check_inbox/presentation/check_inbox_args.dart';
import 'package:zenshield/feature/check_inbox/presentation/check_inbox_view.dart';
import 'package:zenshield/feature/home/presentation/home_view.dart';
import 'package:zenshield/feature/reset_password/presentation/reset_password_view.dart';
import 'package:zenshield/feature/new_password/presentation/new_password_view.dart';
import 'package:zenshield/core/widgets/error_dialog.dart';
import 'package:zenshield/config/theme/app_colors/app_colors.dart';
import 'package:zenshield/config/theme/app_text_styles/app_text_styles.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:talker_flutter/talker_flutter.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  static const String routeName = '/login';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(
        logger: getIt<Talker>(),
        authUseCase: getIt<AbstractAuthUserUseCase>(),
        eventBus: getIt<EventBus>(),
      ),
      child: BlocSideEffectListener<AuthBloc, AuthSideEffect>(
        listener: (context, sideEffect) async {
          FocusScope.of(context).unfocus();
          final l10n = AppLocalizations.of(context);
          if (sideEffect is AuthNavigateToHome) {
            if (context.mounted) {
              await Navigator.of(
                context,
              ).pushReplacementNamed(HomeView.routeName);
            }
          } else if (sideEffect is AuthNavigateToSignUp) {
            final authBloc = context.read<AuthBloc>();
            if (context.mounted) {
              await Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => BlocProvider.value(
                    value: authBloc,
                    child: const SignUpView(),
                  ),
                ),
              );
            }
          } else if (sideEffect is AuthNavigateBack) {
            if (context.mounted) {
              Navigator.of(context).maybePop();
            }
          } else if (sideEffect is ShowLoginErrorDialog) {
            await _showLoginErrorDialog(context);
          } else if (sideEffect is ShowWrongCredentialsDialog) {
            await _showWrongCredentialsDialog(context);
          } else if (sideEffect is AuthShowInvalidEmailDialog) {
            await _showInvalidEmailDialog(context);
          } else if (sideEffect is ShowInvalidPasswordDialog) {
            await _showInvalidPasswordDialog(context);
          } else if (sideEffect is ShowEmailEmploymentErrorDialog) {
            await _showEmailEmploymentErrorDialog(context);
          } else if (sideEffect is ShowRegistrationErrorDialog) {
            await _showSigupErrorDialog(context);
          } else if (sideEffect
              is ShowEmailNotConfirmedOrRegisteredErrorDialog) {
            await _showEmailNotConfirmedOrRegisteredErrorDialog(context);
          } else if (sideEffect is AuthNavigateToCheckInbox) {
            await Navigator.of(context).pushNamed(
              CheckInboxView.routeName,
              arguments: {
                'email': sideEffect.email,
                'verificationType': VerificationType.registration,
              },
            );
          } else if (sideEffect is AuthNavigateToResetPassword) {
            if (context.mounted) {
              await Navigator.of(
                context,
              ).pushNamed(ResetPasswordView.routeName);
            }
          } else if (sideEffect is AuthNavigateToNewPassword) {
            if (context.mounted) {
              await Navigator.of(
                context,
              ).pushReplacementNamed(NewPasswordView.routeName);
            }
          } else if (sideEffect is ShowDeepLinkSessionDataMissingError) {
            await _showDeepLinkErrorDialog(
              context,
              l10n?.checkInboxErrorSessionDataMissing ??
                  'Session data is missing. Please register again.',
            );
          } else if (sideEffect is ShowDeepLinkUnknownActionError) {
            await _showDeepLinkErrorDialog(
              context,
              l10n?.checkInboxErrorUnknownAction ??
                  'Unknown action in deep link',
            );
          } else if (sideEffect is ShowDeepLinkMissingCodeParameterError) {
            await _showDeepLinkErrorDialog(
              context,
              l10n?.checkInboxErrorMissingCodeParameter ??
                  'Missing code parameter in deep link',
            );
          } else if (sideEffect is ShowDeepLinkVerificationError) {
            await _showDeepLinkErrorDialog(
              context,
              l10n?.checkInboxErrorVerificationFailed ??
                  'Verification failed. Please try again.',
            );
          } else if (sideEffect is ShowDeepLinkWrongActionError) {
            await _showDeepLinkErrorDialog(
              context,
              l10n?.deepLinkErrorWrongAction ?? 'Wrong action in deep link',
            );
          }
        },
        child: const _LoginContent(),
      ),
    );
  }

  Future<void> _showDeepLinkErrorDialog(
    BuildContext context,
    String message,
  ) async {
    final l10n = AppLocalizations.of(context);
    await MessageDialog.show(
      context,
      title: l10n?.deepLinkErrorTitle ?? 'Verification Error',
      message: message,
    );
  }

  Future<void> _showLoginErrorDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    await MessageDialog.show(
      context,
      title: l10n?.loginFailedTitle ?? 'Login Failed',
      message:
          l10n?.loginErrorText ??
          'Unable to sign in. Please check your internet connection and try again.',
    );
  }

  Future<void> _showSigupErrorDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    await MessageDialog.show(
      context,
      title: l10n?.signUpFailedTitle ?? 'Sign up Failed',
      message:
          l10n?.signUpErrorText ??
          'Unable to sign up. Please check your internet connection and try again.',
    );
  }

  Future<void> _showWrongCredentialsDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    await MessageDialog.show(
      context,
      title: l10n?.authenticationFailedTitle ?? 'Authentication Failed',
      message:
          l10n?.wrongCredentialsText ??
          'The email or password you entered is incorrect. Please try again.',
    );
  }

  Future<void> _showInvalidEmailDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    await MessageDialog.show(
      context,
      title: l10n?.invalidEmailTitle ?? 'Invalid Email',
      message: l10n?.invalidEmailText ?? 'Please enter a valid email address.',
    );
  }

  Future<void> _showInvalidPasswordDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    await MessageDialog.show(
      context,
      title: l10n?.invalidPasswordTitle ?? 'Invalid Password',
      message:
          l10n?.invalidPasswordText ??
          'Password must meet the following requirements:\n\n• At least 8 characters long\n• Only Latin characters (A-Z, a-z, 0-9, and special characters)',
    );
  }

  Future<void> _showEmailEmploymentErrorDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    await MessageDialog.show(
      context,
      title: l10n?.emailEmploymentErrorTitle ?? 'Email Employment Error',
      message:
          l10n?.emailEmploymentErrorText ??
          'The email you entered is already in use. Please try again.',
    );
  }

  Future<void> _showEmailNotConfirmedOrRegisteredErrorDialog(
    BuildContext context,
  ) async {
    final l10n = AppLocalizations.of(context);
    await MessageDialog.show(
      context,
      title:
          l10n?.emailNotConfirmedOrRegisteredErrorTitle ??
          'Email Not Confirmed or Registered',
      message:
          l10n?.emailNotConfirmedOrRegisteredErrorText ??
          'The email is not confirmed or registered. Please check your email or sign up.',
    );
  }
}

class _LoginContent extends StatefulWidget {
  const _LoginContent();

  @override
  State<_LoginContent> createState() => _LoginContentState();
}

class _LoginContentState extends State<_LoginContent> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final state = context.read<AuthBloc>().state;
    _emailController = TextEditingController(text: state.email);
    _passwordController = TextEditingController(text: state.password);
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
    context.read<AuthBloc>().add(AuthPasswordChanged(value));
  }

  void _onLoginPressed() {
    context.read<AuthBloc>().add(
      AuthLoginButtonPressed(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }

  void _navigateToSignUp() {
    context.read<AuthBloc>().add(const AuthNavigateToSignUpPressed());
  }

  void _navigateToResetPassword() {
    context.read<AuthBloc>().add(const AuthNavigateToResetPasswordPressed());
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

    final hasEmailAndPassword =
        state.email.isNotEmpty && state.password.isNotEmpty;
    final isEnabled = hasEmailAndPassword && !state.isLoading;

    return Listener(
      onPointerDown: (_) => _hideKeyboard(),
      child: Scaffold(
        backgroundColor: colors.background,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 26),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          AuthHeader(
                            isKeyboardVisible: isKeyboardVisible,
                            title: l10n?.authLoginTitle ?? 'Welcome back',
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
                                l10n?.passwordHintEnter ??
                                'Enter your password',
                            onSubmitted: isEnabled ? _onLoginPressed : null,
                          ),
                          const SizedBox(height: 9),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: _navigateToResetPassword,
                              child: Text(
                                l10n?.forgotPassword ?? 'Forgot Password?',
                                style: appTextStyles
                                    .interMedium14(color: colors.blue)
                                    .copyWith(
                                      decoration: TextDecoration.underline,
                                      decorationColor: colors.blue,
                                    ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          AuthPrimaryButton(
                            text: l10n?.buttonLogin ?? 'Login',
                            isEnabled: isEnabled,
                            isLoading: state.isLoading,
                            onPressed: _onLoginPressed,
                          ),
                          const SizedBox(height: 24),
                          GestureDetector(
                            onTap: _navigateToSignUp,
                            child: Text.rich(
                              TextSpan(
                                text:
                                    l10n?.authNoAccountPrompt ??
                                    "Don't have an account? ",
                                style: appTextStyles.interRegular13(
                                  color: colors.grayLight,
                                ),
                                children: [
                                  TextSpan(
                                    text: l10n?.buttonSignUp ?? 'Sign Up',
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
