import 'package:zenshield/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:zenshield/di/injection_container.dart';
import 'package:zenshield/gen/assets.gen.dart';
import 'package:zenshield/feature/auth/presentation/auth_view.dart';
import 'package:zenshield/feature/home/presentation/home_view.dart';
import 'package:zenshield/config/theme/app_colors/app_colors.dart';
import 'package:zenshield/feature/auth/data/auth_user_use_case.dart';
import 'package:zenshield/feature/splash/presentation/splash_bloc.dart';
import 'package:zenshield/feature/splash/presentation/splash_side_effect.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:talker_flutter/talker_flutter.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  static const routeName = '/splash';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashBloc(
        authUserUseCase: getIt<AbstractAuthUserUseCase>(),
        logger: getIt<Talker>(),
      ),
      child: BlocSideEffectListener<SplashBloc, SplashSideEffect>(
        listener: (context, sideEffect) async {
          switch (sideEffect) {
            case NavigateToHome():
              await Navigator.of(
                context,
              ).pushReplacementNamed(HomeView.routeName);
            case NavigateToAuth():
              await Navigator.of(
                context,
              ).pushReplacementNamed(AuthView.routeName);
            case ShowErrorDialog():
              _showErrorDialog(context);
          }
        },
        child: _SplashContent(),
      ),
    );
  }

  Future<void> _showErrorDialog(BuildContext context) async {
    final localizations = AppLocalizations.of(context);
    if (localizations == null) return;

    final result = await FlutterPlatformAlert.showCustomAlert(
      windowTitle: localizations.splash_error_title,
      text: localizations.splash_error_text,
      positiveButtonTitle: localizations.contact_support,
      negativeButtonTitle: localizations.cancel,
    );

    if (context.mounted && result == CustomButton.positiveButton) {
      context.read<SplashBloc>().add(const ContactSupportTappedEvent());
    }
  }
}

class _SplashContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appColors = AppColors();
    return Scaffold(
      backgroundColor: appColors.background,
      body: Center(child: Assets.images.appLogo.image(width: 64, height: 64)),
    );
  }
}
