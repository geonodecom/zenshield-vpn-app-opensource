import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zenshield/core/managers/analytics_manager.dart';
import 'package:zenshield/di/injection_container.dart';
import 'package:zenshield/feature/agreements/domain/useCase/agreement_use_case.dart';
import 'package:zenshield/feature/auth/data/auth_user_use_case.dart';
import 'package:zenshield/gen/assets.gen.dart';
import 'package:zenshield/l10n/app_localizations.dart';
import 'package:zenshield/feature/check_inbox/presentation/check_inbox_args.dart';
import 'package:zenshield/feature/check_inbox/presentation/check_inbox_bloc.dart';
import 'package:zenshield/feature/check_inbox/presentation/check_inbox_side_effect.dart';
import 'package:zenshield/feature/auth/presentation/auth_view.dart';
import 'package:zenshield/feature/home/presentation/home_view.dart';
import 'package:zenshield/feature/new_password/presentation/new_password_view.dart';
import 'package:zenshield/feature/onboarding_progress/presentation/onboarding_progress_view.dart';
import 'package:zenshield/core/widgets/error_dialog.dart';
import 'package:zenshield/config/theme/app_colors/app_colors.dart';
import 'package:zenshield/config/theme/app_text_styles/app_text_styles.dart';

class CheckInboxView extends StatelessWidget {
  const CheckInboxView({
    required this.email,
    required this.verificationType,
    super.key,
  });

  final String email;
  final VerificationType verificationType;

  static const routeName = '/check_inbox';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CheckInboxBloc(
        eventBus: getIt<EventBus>(),
        authUseCase: getIt<AbstractAuthUserUseCase>(),
        logger: getIt<Talker>(),
        analyticsManager: getIt<AbstractAnalyticsManager>(),
        email: email,
        verificationType: verificationType,
        agreementUseCase: getIt<AbstractAgreementUseCase>(),
      ),
      child: BlocSideEffectListener<CheckInboxBloc, CheckInboxSideEffect>(
        listener: (context, sideEffect) async {
          final l10n = AppLocalizations.of(context);
          switch (sideEffect) {
            case NavigateToHome():
              if (context.mounted) {
                await Navigator.of(
                  context,
                ).pushReplacementNamed(HomeView.routeName);
              }
            case NavigateToOnboarding():
              if (context.mounted) {
                await Navigator.of(
                  context,
                ).pushReplacementNamed(
                  OnboardingProgressView.routeName,
                  arguments: sideEffect.agreementsResponse,
                );
              }
            case NavigateToNewPassword():
              if (context.mounted) {
                await Navigator.of(
                  context,
                ).pushReplacementNamed(NewPasswordView.routeName);
              }
            case ShowSessionDataMissingError():
              _showDeepLinkErrorDialog(
                context,
                l10n?.checkInboxErrorSessionDataMissing ??
                    'Session data is missing. Please register again.',
              );
            case ShowUnknownActionError():
              _showDeepLinkErrorDialog(
                context,
                l10n?.checkInboxErrorUnknownAction ??
                    'Unknown action in deep link',
              );
            case ShowMissingCodeParameterError():
              _showDeepLinkErrorDialog(
                context,
                l10n?.checkInboxErrorMissingCodeParameter ??
                    'Missing code parameter in deep link',
              );
            case ShowVerificationError():
              _showDeepLinkErrorDialog(
                context,
                l10n?.checkInboxErrorVerificationFailed ??
                    'Verification failed. Please try again.',
              );
            case ShowWrongActionError():
              _showDeepLinkErrorDialog(
                context,
                l10n?.deepLinkErrorWrongAction ?? 'Wrong action in deep link',
              );
            case ShowEmailAppNotFound():
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      l10n?.checkInboxErrorUnableToOpenEmailApp ??
                          'Unable to open email app',
                    ),
                  ),
                );
              }
          }
        },
        child: _CheckInboxContent(
          email: email,
          verificationType: verificationType,
        ),
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
}

class _CheckInboxContent extends StatelessWidget {
  const _CheckInboxContent({
    required this.email,
    required this.verificationType,
  });

  final String email;
  final VerificationType verificationType;

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors();
    final appTextStyles = AppTextStyles();
    final l10n = AppLocalizations.of(context);

    final bottomPadding = MediaQuery.of(context).padding.bottom == 0
        ? 17.0
        : 0.0;
    final safeBottom = MediaQuery.of(context).padding.bottom;
    final bottomGap = (40.0 - safeBottom).clamp(0.0, 40.0);

    return Scaffold(
      backgroundColor: appColors.white,
      body: SafeArea(
        bottom: true,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: bottomPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 46),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(),
                          Assets.images.checkInbox.image(height: 242),

                          const SizedBox(height: 120),
                          Text(
                            l10n?.checkInboxTitle ?? 'Check your inbox',
                            textAlign: TextAlign.center,
                            style: appTextStyles
                                .helveticaNeueBold24(color: appColors.black)
                                .copyWith(fontSize: 22),
                          ),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              l10n?.checkInboxMessage(email) ??
                                  'We\'ve sent a confirmation link to $email',
                              textAlign: TextAlign.center,
                              style: appTextStyles
                                  .interRegular14(color: appColors.grayLight)
                                  .copyWith(fontSize: 13),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              l10n?.checkInboxSubtext ??
                                  'Please verify your email to continue using Zenshield.',
                              textAlign: TextAlign.center,
                              style: appTextStyles
                                  .interRegular14(color: appColors.grayLight)
                                  .copyWith(fontSize: 13),
                            ),
                          ),
                          const Spacer(flex: 2),
                          const SizedBox(height: 0),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: () => context.read<CheckInboxBloc>().add(const OpenEmailAppEvent()),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: appColors.black,
                              foregroundColor: appColors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(29),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              l10n?.buttonOpenEmailApp ?? 'Open email app',
                              style: appTextStyles
                                  .nunitoSansBold18(color: appColors.white)
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),

                        SizedBox(height: bottomGap),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 10,
              top: 20,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(
                    context,
                  ).pushReplacementNamed(AuthView.routeName);
                },
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Assets.images.chevronLeft.image(width: 24, height: 24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
