import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zenshield/core/widgets/update_required_popup_new.dart';
import 'package:zenshield/di/injection_container.dart';
import 'package:zenshield/feature/agreements/domain/useCase/agreement_use_case.dart';
import 'package:zenshield/feature/auth/data/auth_user_use_case.dart';
import 'package:zenshield/feature/desktop_updater/domain/useCase/desktop_updater_use_case.dart';
import 'package:zenshield/feature/vpn_connection/domain/repositories/vpn_manager.dart';
import 'package:zenshield/gen/assets.gen.dart';
import 'package:zenshield/l10n/app_localizations.dart';
import 'package:zenshield/feature/app_update/presentation/app_update_bloc.dart';
import 'package:zenshield/feature/app_update/presentation/app_update_side_effect.dart';
import 'package:zenshield/feature/app_update/presentation/state/app_update_state.dart';
import 'package:zenshield/feature/auth/presentation/auth_view.dart';
import 'package:zenshield/feature/home/presentation/home_view.dart';
import 'package:zenshield/feature/onboarding_progress/presentation/onboarding_progress_view.dart';
import 'package:zenshield/feature/splash/presentation/splash_view.dart';
import 'package:zenshield/config/theme/app_colors/app_colors.dart';
import 'package:zenshield/config/theme/app_text_styles/app_text_styles.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

class AppUpdateView extends StatelessWidget {
  const AppUpdateView({
    this.startEvent,
    super.key,
  });

  final AppUpdateEvent? startEvent;

  static const routeName = '/app-update';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppUpdateBloc(
        startEvent: startEvent,
        authUseCase: getIt<AbstractAuthUserUseCase>(),
        desktopUpdaterUseCase: getIt<AbstractDesktopUpdaterUseCase>(),
        vpnManager: getIt<AbstractVpnManager>(),
        agreementUseCase: getIt<AbstractAgreementUseCase>(),
        logger: getIt<Talker>(),
      ),
      child: BlocSideEffectListener<AppUpdateBloc, AppUpdateSideEffect>(
        listener: (context, sideEffect) async {
          switch (sideEffect) {
            case NavigateToSplash():
              await Navigator.of(context)
                  .pushReplacementNamed(SplashView.routeName);
            case NavigateToHome():
              await Navigator.of(context)
                  .pushReplacementNamed(HomeView.routeName);
            case NavigateToAuth():
              await Navigator.of(context)
                  .pushReplacementNamed(AuthView.routeName);
            case NavigateToOnboarding():
              await Navigator.of(context)
                  .pushReplacementNamed(OnboardingProgressView.routeName);
          }
        },
        child: _AppUpdateContent(),
      ),
    );
  }
}

class _AppUpdateContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appColors = AppColors();

    return Scaffold(
      backgroundColor: appColors.white,
      body: BlocConsumer<AppUpdateBloc, AppUpdateState>(
        listener: (context, state) {
          state.whenOrNull(
            confirm: (isMandatory, version) {
              UpdateRequiredPopupNew.show(
                context,
                isDismissible: !isMandatory,
                version: version,
              );
            },
          );
        },
        builder: (context, state) {
          final progress = state.when(
            checking: () => null,
            confirm: (_, __) => null,
            downloading: (progress) => progress,
            installing: (progress) => progress,
            restarting: () => null,
            error: (_, __) => null,
          );
          final showButtons = state.when(
            checking: () => false,
            confirm: (_, __) => false,
            downloading: (_) => false,
            installing: (_) => false,
            restarting: () => false,
            error: (_, __) => true,
          );

          final blockBypass = state.maybeWhen(
            error: (isMandatory, isInstallFailure) =>
                isMandatory && !isInstallFailure,
            orElse: () => false,
          );

          return Center(
            child: _UpdateStateContent(
              state: state,
              progress: progress,
              showButtons: showButtons,
              blockBypass: blockBypass,
            ),
          );
        },
      ),
    );
  }
}

class _UpdateStateContent extends StatelessWidget {
  const _UpdateStateContent({
    required this.state,
    required this.progress,
    required this.showButtons,
    required this.blockBypass,
  });

  final AppUpdateState state;
  final double? progress;
  final bool showButtons;
  final bool blockBypass;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 192),
        Assets.images.appLogo.image(
          width: 64,
          height: 64,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 24),
          child: SizedBox(
            width: 318,
            child: _StateText(state: state),
          ),
        ),
        SizedBox(
          height: progress != null ? 84 : 0,
          child: progress != null
              ? Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _ProgressBar(progress: progress!),
                      const SizedBox(height: 8),
                      _ProgressPercentText(progress: progress!),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
        SizedBox(
          height: progress != null ? 122 : 162 + 44,
          child: showButtons
              ? _ErrorButtons(blockBypass: blockBypass)
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _StateText extends StatelessWidget {
  const _StateText({required this.state});

  final AppUpdateState state;

  @override
  Widget build(BuildContext context) {
    final appTextStyles = AppTextStyles();
    final appColors = AppColors();
    final l10n = AppLocalizations.of(context);

    final String text = state.when(
      checking: () => l10n?.appUpdateChecking ?? 'Checking for updates…',
      confirm: (_, __) => l10n?.appUpdateChecking ?? 'Checking for updates…',
      downloading: (_) => l10n?.appUpdateDownloading ?? 'Downloading update',
      installing: (_) => l10n?.appUpdateInstalling ?? 'Installing',
      restarting: () => l10n?.appUpdateRestarting ?? 'Restarting Zenshield',
      error: (_, __) => l10n?.appUpdateError ?? "Couldn't update right now",
    );

    return Text(
      text,
      textAlign: TextAlign.center,
      style: appTextStyles.interRegular16(
        color: appColors.black,
      ),
    );
  }
}

class _ErrorButtons extends StatelessWidget {
  const _ErrorButtons({required this.blockBypass});

  final bool blockBypass;

  @override
  Widget build(BuildContext context) {
    final appTextStyles = AppTextStyles();
    final appColors = AppColors();
    final l10n = AppLocalizations.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16, top: 26),
          child: SizedBox(
            width: 318,
            height: 57,
            child: ElevatedButton(
              onPressed: () {
                context.read<AppUpdateBloc>().add(const RetryUpdateEvent());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: appColors.black,
                foregroundColor: appColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(29),
                ),
                elevation: 0,
                splashFactory: NoSplash.splashFactory,
              ),
              child: Text(
                l10n?.appUpdateRetry ?? 'Retry',
                style: appTextStyles
                    .nunitoSansBold18(
                      color: appColors.white,
                    )
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
        if (!blockBypass)
          Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: SizedBox(
              width: 160,
              height: 35,
              child: GestureDetector(
                onTap: () {
                  context.read<AppUpdateBloc>().add(const SkipUpdateEvent());
                },
                child: Text(
                  l10n?.appUpdateOpenAppAnyway ?? 'Open app anyway',
                  textAlign: TextAlign.center,
                  style: appTextStyles.interRegular14(
                    color: appColors.grayLight,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

const double _progressBarWidth = 220;

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors();

    return Container(
      width: _progressBarWidth,
      height: 20,
      decoration: BoxDecoration(
        color: appColors.grayBackground,
        borderRadius: BorderRadius.circular(66),
        border: Border.all(color: appColors.grayVeryLight),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: ((_progressBarWidth - 4) * progress).clamp(
                  16.0,
                  _progressBarWidth - 4,
                ),
                height: 16,
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: appColors.black,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressPercentText extends StatelessWidget {
  const _ProgressPercentText({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final appTextStyles = AppTextStyles();
    final appColors = AppColors();

    return Text(
      '${(progress.clamp(0.0, 1.0) * 100).round()}%',
      style: appTextStyles.interRegular14(
        color: appColors.grayLight,
      ),
    );
  }
}
