import 'package:country_picker/country_picker.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenshield/core/utils/platform_utils.dart';
import 'package:zenshield/di/injection_container.dart';
import 'package:zenshield/feature/connection/data/model/connection_status/connection_status.dart';
import 'package:zenshield/feature/servers/data/model/vpn_configuration/vpn_configuration.dart';
import 'package:zenshield/feature/servers/domain/repositories/servers_repository.dart';
import 'package:zenshield/feature/vpn_connection/domain/repositories/vpn_manager.dart';
import 'package:zenshield/gen/assets.gen.dart';
import 'package:zenshield/core/widgets/black_circular_progress_indicator.dart';
import 'package:zenshield/core/widgets/items/home_server_item.dart';
import 'package:zenshield/core/widgets/containers/rotating_container.dart';
import 'package:zenshield/core/widgets/error_dialog.dart';
import 'package:zenshield/feature/about/presentation/about_view.dart';
import 'package:zenshield/feature/home/presentation/home_bloc.dart';
import 'package:zenshield/feature/home/presentation/home_side_effect.dart';
import 'package:zenshield/feature/servers/presentation/servers_view.dart';
import 'package:zenshield/feature/settings/presentation/settings_view.dart';
import 'package:zenshield/core/utils/string_utils.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zenshield/feature/app/presentation/app_bloc.dart' as app;
import 'package:zenshield/feature/app/presentation/app_side_effect.dart';
import 'package:zenshield/config/theme/app_colors/app_colors.dart';
import 'package:zenshield/config/theme/app_text_styles/app_text_styles.dart';
import 'package:zenshield/l10n/app_localizations.dart';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final Talker talker = getIt<Talker>();

  static const String routeName = '/home';

  @override
  Widget build(BuildContext context) {
    final appBloc = context.watch<app.AppBloc>();

    return BlocProvider(
      create: (context) => HomeBloc(
        vpnManager: getIt<AbstractVpnManager>(),
        eventBus: getIt<EventBus>(),
        logger: getIt<Talker>(),
        serverRepository: getIt<AbstractServersRepository>(),
      )..add(InitialEvent(connectionStatus: appBloc.state.connectionStatus)),
      child: BlocSideEffectListener<app.AppBloc, AppSideEffect>(
        listener: (context, sideEffect) async {
          if (sideEffect is ShowSystemExtensionErrorDialog) {
            if (!context.mounted) return;
            final l10n = AppLocalizations.of(context);
            final major = Platform.isMacOS
                ? (await DeviceInfoPlugin().macOsInfo).majorVersion
                : null;
            if (!context.mounted) return;
            final message = _messageForSystemExtensionSideEffect(
              context,
              sideEffect.errorType,
              sideEffect.message,
              major,
            );
            await MessageDialog.show(
              context,
              title:
                  l10n?.systemExtensionErrorTitle ??
                  'System Extension Required',
              message: message,
            );
          } else if (sideEffect is ShowVpnErrorDialog) {
            if (!context.mounted) return;
            await MessageDialog.show(
              context,
              title: sideEffect.title,
              message: sideEffect.message,
            );
          } else if (sideEffect is PromptBatteryOptimizations) {
            if (!context.mounted) return;
            final appColors = AppColors();
            final appTextStyles = AppTextStyles();
            final agreed = await MessageDialog.show<bool>(
              context,
              title: 'Disable auto turn off vpn',
              titleWidget: Row(
                children: [
                  Icon(Icons.battery_alert, color: appColors.red),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Disable auto turn off vpn',
                      style: appTextStyles.latoBold16(color: appColors.black),
                    ),
                  ),
                ],
              ),
              message:
                  'To prevent connection drop-outs in the background, please disable battery optimizations for Zenshield VPN.',
              positiveButtonText: 'Disable',
              negativeButtonText: 'Maybe Later',
            );
            if (agreed == true) {
              sideEffect.onAgreed();
            } else {
              sideEffect.onSkipped();
            }
          } else if (sideEffect is ShowAutoSelectEnabledToast) {
            if (!context.mounted) return;
            final l10n = AppLocalizations.of(context);
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(
                    l10n?.serversAutoSelectEnabled ?? 'Auto select enabled',
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
          }
        },
        child: BlocSideEffectListener<HomeBloc, HomeSideEffect>(
          listener: (context, sideEffect) async {
            switch (sideEffect) {
              case NavigateToSettings():
                await Navigator.of(context).pushNamed(SettingsView.routeName);
              case NavigateToServers():
                await ServersView.show(context);
              case NavigateToAbout():
                await Navigator.of(context).pushNamed(AboutView.routeName);
            }
          },
          child: _HomeContent(),
        ),
      ),
    );
  }

  String _messageForSystemExtensionSideEffect(
    BuildContext context,
    String? errorType,
    String fallbackMessage,
    int? macOSMajorVersion,
  ) {
    switch (errorType) {
      case 'systemExtensionRequiresUserApproval':
        return _systemExtensionMessage(
          context,
          fallbackMessage,
          macOSMajorVersion,
        );
      case 'systemExtensionUnknownError':
        return fallbackMessage;
      default:
        return fallbackMessage;
    }
  }

  String _systemExtensionMessage(
    BuildContext context,
    String fallback,
    int? macOSMajorVersion,
  ) {
    if (macOSMajorVersion == null) return fallback;
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return fallback;
    if (macOSMajorVersion >= 15) {
      return l10n.systemExtensionMessageSequoiaAndLater;
    }
    return l10n.systemExtensionMessageSonomaAndEarlier;
  }
}

class _HomeContent extends StatefulWidget {
  const _HomeContent();

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  @override
  Widget build(BuildContext context) {
    final appColors = AppColors();
    final appTextStyles = AppTextStyles();
    final homeBloc = context.watch<HomeBloc>();
    final homeState = homeBloc.state;
    final appBloc = context.watch<app.AppBloc>();
    final appState = appBloc.state;
    final l10n = AppLocalizations.of(context);

    final rawCityName = switch (appState.selectedServer) {
      final SystemVpnConfiguration config => config.city,
      final UserVpnConfiguration config => config.title,
      _ => 'City',
    };
    final cityName = StringUtils.capitalizeFirst(rawCityName);

    // Auto mode always shows the generic "Auto select" title — a country
    // there would look like a firm pick when it isn't one. The subtitle below
    // it tracks the post-connect health check (tunnelHealthy: null while
    // still probing, true once a good exit is confirmed, false if every
    // candidate failed) so the user sees *why* nothing concrete is shown yet,
    // instead of a country that may turn out to be dead moments later.
    final showAutoPlaceholder = !appState.serverSelectionPinned;
    final isConnected = appState.connectionStatus == const Connected();
    final isAutoSearching =
        showAutoPlaceholder && isConnected && appState.tunnelHealthy == null;
    final isAutoHealthy =
        showAutoPlaceholder && isConnected && appState.tunnelHealthy == true;
    final isAutoUnhealthy =
        showAutoPlaceholder && isConnected && appState.tunnelHealthy == false;

    final autoResolvedCountryCode = isAutoHealthy
        ? appState.selectedServer?.region.countryCode
        : null;
    final autoResolvedFlagUrl = isAutoHealthy
        ? appState.selectedServer?.region.flagImage
        : null;
    final autoResolvedCountryName = autoResolvedCountryCode != null
        ? (CountryLocalizations.of(context)?.countryName(
                countryCode: autoResolvedCountryCode.toUpperCase(),
              ) ??
              autoResolvedCountryCode)
        : null;
    final autoSubtitle = isAutoSearching
        ? (l10n?.serversAutoSelectFinding ?? 'Finding best server...')
        : isAutoUnhealthy
        ? (l10n?.serversAutoSelectUnavailable ?? 'Server unavailable')
        : (autoResolvedCountryName ??
              (l10n?.serversAutoSelectSubtitle ?? 'Best available server'));

    final ip = showAutoPlaceholder ? null : appState.selectedServer?.ip;
    final flagUrl = showAutoPlaceholder
        ? null
        : appState.selectedServer?.region.flagImage;
    final countryCode = showAutoPlaceholder
        ? null
        : appState.selectedServer?.region.countryCode;
    final spacingAfterServerItem = MediaQuery.of(context).padding.bottom == 0
        ? 45.0
        : 32.0;

    return Scaffold(
      backgroundColor: appColors.white,
      body: SafeArea(
        bottom: true,
        child: Stack(
          children: [
            const _Background(),
            // LayoutBuilder + SingleChildScrollView + ConstrainedBox(minHeight)
            // + IntrinsicHeight: normally the Column fills the full height
            // exactly as before (spaceBetween behaves identically), but if
            // less height is ever available than this content needs — e.g. a
            // frame or two while the keyboard is still animating closed after
            // returning from a screen with a text field focused — it becomes
            // scrollable instead of throwing a RenderFlex overflow.
            LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildHeader(homeBloc),
                            const SizedBox(height: 24),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                ConnectionStatusBadge(),
                                const SizedBox(height: 10),
                                Text(
                                  homeState.timerValue,
                                  style: appTextStyles
                                      .helveticaNeueRegular60(
                                        color: appColors.black,
                                      )
                                      .copyWith(
                                        letterSpacing: 1.5,
                                        fontFeatures: const [
                                          FontFeature.tabularFigures(),
                                        ],
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 45),
                              ],
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Transform.translate(
                                  offset: const Offset(0, -28),
                                  child: ConnectButton(
                                    onTap: () async {
                                      if (appState.connectionStatus ==
                                          const Disconnected()) {
                                        appBloc.add(
                                          const app.TurnOnVpnTappedEvent(),
                                        );
                                      } else if (appState.connectionStatus ==
                                          const Connected()) {
                                        final confirmed =
                                            await _showDisconnectConfirmDialog(
                                              context,
                                            );
                                        if (context.mounted &&
                                            confirmed == true) {
                                          appBloc.add(
                                            const app.TurnOffVpnTappedEvent(),
                                          );
                                        }
                                      }
                                    },
                                    onLongPress: () {},
                                  ),
                                ),
                                SizedBox(height: 60),
                                HomeServerItem(
                                  cityName: showAutoPlaceholder ? '' : cityName,
                                  countryCode: countryCode ?? '',
                                  countryName: showAutoPlaceholder
                                      ? (l10n?.serversAutoSelect ??
                                            'Auto select')
                                      : CountryLocalizations.of(
                                              context,
                                            )?.countryName(
                                              countryCode:
                                                  countryCode?.toUpperCase() ??
                                                  '',
                                            ) ??
                                            'earth',
                                  ip: ip ?? '',
                                  flagUrl: flagUrl ?? "",
                                  subtitle: showAutoPlaceholder
                                      ? autoSubtitle
                                      : null,
                                  subtitleFlagCountryCode:
                                      autoResolvedCountryCode,
                                  subtitleFlagUrl: autoResolvedFlagUrl,
                                  isSubtitleLoading: isAutoSearching,
                                  onTap: () {
                                    homeBloc.add(ServersTappedEvent());
                                  },
                                ),
                                SizedBox(height: spacingAfterServerItem),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _showDisconnectConfirmDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    return MessageDialog.show<bool>(
      context,
      title: l10n?.homeDisconnectConfirmTitle ?? 'Turn off VPN?',
      message:
          l10n?.homeDisconnectConfirmMessage ??
          "You'll lose protection and your traffic won't be secured until you reconnect.",
      negativeButtonText: l10n?.homeDisconnectConfirmKeepVpn ?? 'Keep VPN on',
      positiveButtonText: l10n?.homeDisconnectConfirmTurnOff ?? 'Turn off',
      onNegativePressed: () => Navigator.of(context).pop(false),
      onPositivePressed: () => Navigator.of(context).pop(true),
      isDestructiveAction: true,
    );
  }

  Column _buildHeader(HomeBloc homeBloc) {
    final appColors = AppColors();
    final baseTopOffset = PlatformUtils.isDesktop ? 10 : 35.0;
    final safeTop = MediaQuery.of(context).padding.top;
    final topPadding = (baseTopOffset - safeTop).clamp(0.0, double.infinity);
    return Column(
      children: [
        SizedBox(height: topPadding),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              children: [
                Padding(
                  // On desktop the OS title bar already separates the
                  // window content from the top edge, so the extra nudge
                  // that mobile needs (to clear the status bar row) would
                  // just push the icon further down.
                  padding: EdgeInsets.only(
                    top: PlatformUtils.isDesktop ? 0 : 10,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      homeBloc.add(SettingsTappedEvent());
                    },
                    behavior: HitTestBehavior.opaque,
                    child: _HeaderIconBadge(
                      appColors: appColors,
                      child: Icon(
                        Icons.menu_rounded,
                        size: 21,
                        color: appColors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _HeaderIconBadge extends StatelessWidget {
  const _HeaderIconBadge({required this.appColors, required this.child});

  final AppColors appColors;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: child,
    );
  }
}

class ConnectButton extends StatelessWidget {
  const ConnectButton({
    super.key,
    required this.onTap,
    required this.onLongPress,
  });

  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final appBloc = context.watch<app.AppBloc>();
    final appColors = AppColors();
    final appTextStyles = AppTextStyles();
    final connectionStatus = appBloc.state.connectionStatus;
    switch (connectionStatus) {
      case Connecting():
        return _buildConnectingStatusButton(appColors);
      case Disconnecting():
        return _buildDisconnectingStatusButton(appColors);
      case Connected():
        // Tunnel is technically up, but the health check found no real
        // traffic flowing — match ConnectionStatusBadge's warning state
        // instead of showing a plain green "all good" circle.
        if (appBloc.state.tunnelHealthy == false) {
          return _buildUnhealthyStatusButton(appTextStyles, appColors, context);
        }
        // Auto mode with the health check still running — mirror the "Auto
        // select" card's searching state instead of looking fully settled.
        if (!appBloc.state.serverSelectionPinned &&
            appBloc.state.tunnelHealthy == null) {
          return _buildSearchingStatusButton(appTextStyles, appColors, context);
        }
        return _buildConnectedStatusButton(appTextStyles, appColors, context);
      case Disconnected():
        return _buildDisconnectedStatus(appColors, appTextStyles, context);
    }
  }

  Widget _buildConnectingStatusButton(AppColors appColors) {
    return Container(
      width: 108,
      height: 108,
      decoration: BoxDecoration(
        color: appColors.grayBackground,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: SizedBox(
          width: 56.37,
          height: 56.37,
          child: RotatingContainer(
            child: Assets.images.loadingIcon.image(width: 56.37, height: 56.37),
          ),
        ),
      ),
    );
  }

  Widget _buildDisconnectingStatusButton(AppColors appColors) {
    return Container(
      width: 108,
      height: 108,
      decoration: BoxDecoration(
        color: appColors.grayBackground,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: SizedBox(
          width: 56.37,
          height: 56.37,
          child: BlackCircularProgressIndicator(strokeWidth: 3),
        ),
      ),
    );
  }

  Widget _buildConnectedStatusButton(
    AppTextStyles appTextStyles,
    AppColors appColors,
    BuildContext context,
  ) {
    final l10n = AppLocalizations.of(context);
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: appColors.green.withValues(alpha: 0.18),
            ),
          ),
          Container(
            width: 108,
            height: 108,
            decoration: BoxDecoration(
              color: appColors.green,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: appColors.green.withValues(alpha: 0.45),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Center(
              child: Text(
                l10n?.homePause ?? "Disconnect",
                style: appTextStyles
                    .helveticaNeueBold17(color: appColors.black)
                    .copyWith(fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchingStatusButton(
    AppTextStyles appTextStyles,
    AppColors appColors,
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: appColors.green.withValues(alpha: 0.18),
            ),
          ),
          Container(
            width: 108,
            height: 108,
            decoration: BoxDecoration(
              color: appColors.green,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: appColors.green.withValues(alpha: 0.45),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Center(
              child: SizedBox(
                width: 56.37,
                height: 56.37,
                child: RotatingContainer(
                  child: Assets.images.loadingIcon.image(
                    width: 56.37,
                    height: 56.37,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnhealthyStatusButton(
    AppTextStyles appTextStyles,
    AppColors appColors,
    BuildContext context,
  ) {
    final l10n = AppLocalizations.of(context);
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: appColors.warning.withValues(alpha: 0.18),
            ),
          ),
          Container(
            width: 108,
            height: 108,
            decoration: BoxDecoration(
              color: appColors.warning,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: appColors.warning.withValues(alpha: 0.45),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Center(
              child: Text(
                l10n?.homeConnectionIssue ?? "Connection issue",
                style: appTextStyles
                    .helveticaNeueBold17(color: appColors.black)
                    .copyWith(fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisconnectedStatus(
    AppColors appColors,
    AppTextStyles appTextStyles,
    BuildContext context,
  ) {
    final l10n = AppLocalizations.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: appColors.black.withValues(alpha: 0.06),
            ),
          ),
          Container(
            width: 108,
            height: 108,
            decoration: BoxDecoration(
              color: appColors.black,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: appColors.black.withValues(alpha: 0.28),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Center(
              child: Text(
                l10n?.homeConnect ?? 'Connect',
                style: appTextStyles
                    .helveticaNeueBold17(color: appColors.white)
                    .copyWith(fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ConnectionStatusBadge extends StatelessWidget {
  const ConnectionStatusBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors();
    final appTextStyles = AppTextStyles();
    final appBloc = context.watch<app.AppBloc>();
    final connectionStatus = appBloc.state.connectionStatus;

    final l10n = AppLocalizations.of(context);
    switch (connectionStatus) {
      case Connected():
        // Tunnel is up but the post-connect health check confirmed no real
        // traffic gets through (exit server down): warn instead of a plain
        // green badge, so the user isn't misled into thinking browsing works.
        if (appBloc.state.tunnelHealthy == false) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: appColors.warningBackground,
              border: Border.all(color: appColors.warning),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _StatusDot(color: appColors.warning),
                const SizedBox(width: 7),
                Text(
                  l10n?.homeConnectionFailed ??
                      'Not Connected — Connection failed',
                  style: appTextStyles.interMedium14(color: appColors.warning),
                ),
              ],
            ),
          );
        }
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: appColors.green,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _StatusDot(color: appColors.grayMedium),
              const SizedBox(width: 7),
              Text(
                l10n?.homeConnected ?? 'Connected',
                style: appTextStyles.interMedium14(color: appColors.grayMedium),
              ),
            ],
          ),
        );
      case Connecting():
        return _DashedBorderContainer(
          text: l10n?.homeConnecting ?? 'Connecting',
        );
      case Disconnecting():
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: appColors.white,
            border: Border.all(color: appColors.grayMedium2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _StatusDot(color: appColors.grayMedium),
              const SizedBox(width: 7),
              Text(
                l10n?.homeDisconnecting ?? "Disconnecting",
                style: appTextStyles.interMedium14(color: appColors.grayMedium),
              ),
            ],
          ),
        );
      case Disconnected():
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: appColors.black,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _StatusDot(color: appColors.white),
              const SizedBox(width: 7),
              Text(
                l10n?.homeNotConnected ?? 'Not Connected',
                style: appTextStyles
                    .interMedium14(color: appColors.white)
                    .copyWith(fontWeight: FontWeight.w400),
              ),
            ],
          ),
        );
    }
  }
}

class _StatusDot extends StatelessWidget {
  const _StatusDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _DashedBorderContainer extends StatelessWidget {
  const _DashedBorderContainer({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors();
    final appTextStyles = AppTextStyles();

    return CustomPaint(
      painter: DashedBorderPainter(
        color: appColors.grayMedium2,
        strokeWidth: 3,
        dashLength: 6,
        dashSpace: 6,
        radius: 16,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: appColors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          text,
          style: appTextStyles.interMedium14(color: appColors.grayMedium),
        ),
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashLength,
    required this.dashSpace,
    required this.radius,
  });

  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double dashSpace;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(radius),
        ),
      );

    final dashPath = _createDashPath(path, dashLength, dashSpace);
    canvas.drawPath(dashPath, paint);
  }

  Path _createDashPath(Path path, double dashLength, double dashSpace) {
    final dashPath = Path();
    final pathMetrics = path.computeMetrics();

    for (final pathMetric in pathMetrics) {
      var distance = 0.0;
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + dashLength),
          Offset.zero,
        );
        distance += dashLength + dashSpace;
      }
    }

    return dashPath;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Background extends StatelessWidget {
  const _Background();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Assets.images.backgroundImage.image(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Align(
            alignment: Alignment.topCenter,
            child: Assets.images.backgroundPatternDecorative.image(
              height: MediaQuery.of(context).size.height * 0.80,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }
}
