import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:zenshield/core/widgets/transitions/fade_page_route_builder.dart';
import 'package:zenshield/feature/home/presentation/home_view.dart';
import 'package:zenshield/feature/splash/presentation/splash_view.dart';
import 'package:zenshield/feature/settings/presentation/settings_view.dart';
import 'package:zenshield/feature/auth/presentation/auth_view.dart';
import 'package:zenshield/feature/check_inbox/presentation/check_inbox_view.dart';
import 'package:zenshield/feature/check_inbox/presentation/check_inbox_args.dart';
import 'package:zenshield/feature/about/presentation/about_view.dart';
import 'package:zenshield/feature/logs/presentation/logs_view.dart';
import 'package:zenshield/feature/new_password/presentation/new_password_view.dart';
import 'package:zenshield/feature/new_password/presentation/new_password_success_view.dart';
import 'package:zenshield/feature/reset_password/presentation/reset_password_view.dart';

class AppRouter {
  static Route<dynamic> _createPlatformRoute({
    required Widget page,
    required RouteSettings settings,
  }) {
    return Platform.isIOS
        ? CupertinoPageRoute(builder: (_) => page, settings: settings)
        : FadePageRouteBuilder(page: page, settings: settings);
  }

  Route<dynamic>? generateRoute(RouteSettings settings) {
    final routeName = settings.name;

    switch (routeName) {
      case SplashView.routeName:
        return FadePageRouteBuilder(
          page: const SplashView(),
          settings: settings,
        );
      case HomeView.routeName:
        return FadePageRouteBuilder(page: HomeView(), settings: settings);
      case SettingsView.routeName:
        return _createPlatformRoute(
          page: const SettingsView(),
          settings: settings,
        );
      case AuthView.routeName:
        return _createPlatformRoute(page: const AuthView(), settings: settings);
      case CheckInboxView.routeName:
        final args = CheckInboxArgs.fromDynamic(settings.arguments);
        return _createPlatformRoute(
          page: CheckInboxView(
            email: args!.email,
            verificationType: args.verificationType,
          ),
          settings: settings,
        );
      case AboutView.routeName:
        return _createPlatformRoute(
          page: const AboutView(),
          settings: settings,
        );
      case ResetPasswordView.routeName:
        return _createPlatformRoute(
          page: const ResetPasswordView(),
          settings: settings,
        );
      case NewPasswordView.routeName:
        return _createPlatformRoute(
          page: const NewPasswordView(),
          settings: settings,
        );
      case ChangePasswordSuccessView.routeName:
        return _createPlatformRoute(
          page: const ChangePasswordSuccessView(),
          settings: settings,
        );
      case LogsView.routeName:
        return _createPlatformRoute(page: const LogsView(), settings: settings);
      default:
        return null;
    }
  }
}
