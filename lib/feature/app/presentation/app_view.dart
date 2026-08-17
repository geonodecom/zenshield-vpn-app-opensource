import 'package:country_picker/country_picker.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenshield/core/managers/analytics_events.dart';
import 'package:zenshield/core/managers/analytics_manager.dart';
import 'package:zenshield/core/managers/geonode_sdk_manager.dart';
import 'package:zenshield/feature/auth/data/auth_user_use_case.dart';
import 'package:zenshield/core/preferences.dart';
import 'package:zenshield/core/utils/platform_utils.dart';
import 'package:zenshield/di/injection_container.dart';
import 'package:zenshield/feature/connection/data/model/connection_status/connection_status.dart';
import 'package:zenshield/feature/deep_links/data/repoImplementation/deep_link_handler.dart';
import 'package:zenshield/feature/deep_links/data/dataSources/deep_link_service.dart';
import 'package:zenshield/feature/vpn_connection/domain/repositories/vpn_manager.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:window_manager/window_manager.dart';
import 'package:zenshield/l10n/app_localizations.dart';
import 'package:zenshield/core/widgets/error_dialog.dart';
import 'package:zenshield/core/services/platform_settings_service.dart';
import 'package:zenshield/feature/app/presentation/app_bloc.dart';
import 'package:zenshield/feature/app/presentation/state/app_state.dart';
import 'package:zenshield/feature/splash/presentation/splash_view.dart';
import 'package:zenshield/core/route/app_router.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// Forces the glow overscroll indicator on Android instead of the default
/// stretch indicator, which can trigger a re-entrant `setState()` during
/// layout when a scrollable sits under a `LayoutBuilder` (see
/// https://github.com/flutter/flutter/issues/106547).
class _AppScrollBehavior extends MaterialScrollBehavior {
  const _AppScrollBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    switch (getPlatform(context)) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        return GlowingOverscrollIndicator(
          axisDirection: details.direction,
          color: Theme.of(context).colorScheme.secondary,
          child: child,
        );
      case TargetPlatform.iOS:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        return child;
    }
  }
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WindowListener, WidgetsBindingObserver {
  bool _isDialogShowing = false;
  final _vpnManager = getIt<AbstractVpnManager>();
  final AppRouter appRouter = getIt<AppRouter>();
  final _deepLinkService = getIt<DeepLinkService>();
  final _deepLinkHandler = getIt<DeepLinkHandler>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeDeepLinks();
    if (PlatformUtils.isDesktop) {
      _initializeWindowManager();
      windowManager
        ..addListener(this)
        ..setPreventClose(true);
    }
  }

  Future<void> _initializeDeepLinks() async {
    await _deepLinkService.initialize(
      onLink: (uri) {
        _deepLinkHandler.handleDeepLink(uri);
      },
    );
  }

  Future<void> _initializeWindowManager() async {
    await windowManager.ensureInitialized();
    const windowOptions = WindowOptions(
      center: true,
      titleBarStyle: TitleBarStyle.normal,
      title: 'Zenshield VPN',
    );
    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
      await windowManager.setResizable(false);
      await windowManager.setFullScreen(false);
      await windowManager.setMaximizable(false);
    });
  }

  @override
  Future<void> onWindowClose() async {
    if (_vpnManager.status is! Connected && _vpnManager.status is! Connecting) {
      await windowManager.destroy();
      return;
    }

    if (_isDialogShowing) {
      return;
    }

    _isDialogShowing = true;
    final shouldClose = await _showExitDialog();
    _isDialogShowing = false;

    if (shouldClose) {
      await _vpnManager.disableVpn();
      await windowManager.destroy();
    }
  }

  Future<bool> _showExitDialog() async {
    final dialogContext = navigatorKey.currentContext;
    if (dialogContext == null) return false;

    final localizations = AppLocalizations.of(dialogContext);
    if (localizations == null) return false;

    final result = await MessageDialog.show<bool>(
      dialogContext,
      title: localizations.close_dialog_title,
      message: localizations.close_dialog_message,
      positiveButtonText: localizations.cancel,
      negativeButtonText: localizations.close_dialog_positive_button,
      onPositivePressed: () {
        Navigator.of(dialogContext).pop(false);
      },
      onNegativePressed: () {
        Navigator.of(dialogContext).pop(true);
      },
    );

    return result ?? false;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (PlatformUtils.isDesktop) {
      windowManager.removeListener(this);
    }

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      getIt<AbstractAnalyticsManager>().sendEvent(
        AnalyticsEventNames.app_opened,
        {'launch_type': 'resume'},
      );
      getIt<AbstractGeonodeSdkManager>().onAppResumed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc(
        vpnManager: getIt<AbstractVpnManager>(),
        eventBus: getIt<EventBus>(),
        preferences: getIt<Preferences>(),
        logger: getIt<Talker>(),
        analyticsManager: getIt<AbstractAnalyticsManager>(),
        platformSettingsService: getIt<AbstractPlatformSettingsService>(),
        geonodeSdkManager: getIt<AbstractGeonodeSdkManager>(),
        authUserUseCase: getIt<AbstractAuthUserUseCase>(),
      ),
      child: BlocBuilder<AppBloc, AppState>(
        builder: (context, appState) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            scrollBehavior: const _AppScrollBehavior(),
            onGenerateTitle: (context) =>
                AppLocalizations.of(context)?.appTitle ?? 'Zenshield',
            home: const SplashView(),
            navigatorKey: navigatorKey,
            onGenerateRoute: appRouter.generateRoute,
            localizationsDelegates: [
              ...AppLocalizations.localizationsDelegates,
              CountryLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('en'),
            localeResolutionCallback: (locale, supportedLocales) {
              if (locale != null) {
                for (var supportedLocale in supportedLocales) {
                  if (supportedLocale.languageCode == locale.languageCode) {
                    return supportedLocale;
                  }
                }
              }
              return supportedLocales.first;
            },
            builder: (context, child) {
              return ResponsiveBreakpoints.builder(
                child: MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaler: MediaQuery.of(
                      context,
                    ).textScaler.clamp(maxScaleFactor: 1, minScaleFactor: 1),
                  ),
                  child: child ?? const SizedBox.shrink(),
                ),
                breakpoints: [
                  const Breakpoint(start: 0, end: 375, name: MOBILE),
                  const Breakpoint(start: 376, end: 411, name: PHONE),
                  const Breakpoint(start: 412, end: 450, name: 'MEDIUM_PHONE'),
                  const Breakpoint(start: 451, end: 800, name: TABLET),
                  const Breakpoint(
                    start: 801,
                    end: double.infinity,
                    name: DESKTOP,
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
