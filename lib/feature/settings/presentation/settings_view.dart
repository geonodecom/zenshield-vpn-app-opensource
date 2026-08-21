import 'dart:io';
import 'package:flutter/material.dart';
import 'package:zenshield/core/utils/platform_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:zenshield/di/injection_container.dart';
import 'package:zenshield/feature/auth/data/auth_user_use_case.dart';
import 'package:zenshield/feature/launch/domain/repositories/launch_on_startup_manager.dart';
import 'package:zenshield/feature/user_info/domain/useCase/user_info_use_case.dart';
import 'package:zenshield/core/services/platform_settings_service.dart';
import 'package:zenshield/feature/vpn_connection/domain/repositories/vpn_manager.dart';
import 'package:zenshield/gen/assets.gen.dart';
import 'package:zenshield/l10n/app_localizations.dart';
import 'package:zenshield/core/models/protocols.dart';
import 'package:zenshield/feature/about/presentation/widgets/about_and_legal_section.dart';
import 'package:zenshield/feature/app/presentation/app_bloc.dart';
import 'package:zenshield/feature/protocols/presentation/protocols_view.dart';
import 'package:zenshield/feature/settings/presentation/setting_side_effect.dart';
import 'package:zenshield/feature/settings/presentation/settings_bloc.dart';
import 'package:zenshield/feature/auth/presentation/auth_view.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zenshield/config/theme/app_colors/app_colors.dart';
import 'package:zenshield/config/theme/app_text_styles/app_text_styles.dart';
import 'package:intl/intl.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  static const routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsBloc(
        secureStorage: getIt<FlutterSecureStorage>(),
        logger: getIt<Talker>(),
        launchOnStartupManager: getIt<AbstractLaunchOnStartupManager>(),
        userInfoUseCase: getIt<AbstractUserInfoUseCase>(),
        vpnManager: getIt<AbstractVpnManager>(),
        authUseCase: getIt<AbstractAuthUserUseCase>(),
        platformSettingsService: getIt<AbstractPlatformSettingsService>(),
      ),
      child: BlocSideEffectListener<SettingsBloc, SettingsSideEffect>(
        listener: (context, sideEffect) async {
          switch (sideEffect) {
            case NavigateToHome():
              Navigator.of(context).pop();
            case NavigateToProtocols():
              await ProtocolsView.show(context);
              break;
            case NavigateToAuth():
              if (context.mounted) {
                await Navigator.of(
                  context,
                ).pushReplacementNamed(AuthView.routeName);
              }
              break;
          }
        },
        child: const _SettingsContent(),
      ),
    );
  }
}

class _SettingsContent extends StatefulWidget {
  const _SettingsContent();

  @override
  State<_SettingsContent> createState() => _SettingsContentState();
}

class _SettingsContentState extends State<_SettingsContent>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Android has no API for revoking battery-optimization exemption from
    // within the app, so turning the toggle off sends the user to system
    // settings. Re-check the real OS state whenever we come back to the app
    // so the switch reflects whatever the user actually changed there.
    if (state == AppLifecycleState.resumed) {
      context.read<SettingsBloc>().add(
        const RefreshBatteryOptimizationStatusEvent(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors();

    return Scaffold(
      backgroundColor: appColors.white,
      body: SafeArea(
        child: Column(
          children: [
            _HeaderSettings(topPadding: MediaQuery.of(context).padding.top),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileSection(context),
                    const SizedBox(height: 24),
                    _buildMainSection(context),
                    const SizedBox(height: 28),
                    const AboutAndLegalSection(),
                    const SizedBox(height: 28),
                    _buildSocialSection(context),
                  ],
                ),
              ),
            ),
            _LogOutButton(),
            SizedBox(
              height:
                  25 +
                  (MediaQuery.of(context).padding.bottom == 0 ? 17.0 : 0.0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final appColors = AppColors();
    final appTextStyles = AppTextStyles();
    final settingsBloc = context.watch<SettingsBloc>();
    final settingsState = settingsBloc.state;

    final userId = settingsState.userId;
    final securedSince = settingsState.securedSince;
    final securedSinceDate = securedSince != null
        ? DateFormat('MMM d, yyyy').format(securedSince)
        : '';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        color: appColors.background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: appColors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipOval(
              child: Assets.images.userIcon.image(
                width: 72,
                height: 72,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            userId.isNotEmpty ? userId : '',
            textAlign: TextAlign.center,
            style: appTextStyles
                .interSemiBold16(color: appColors.black)
                .copyWith(fontSize: 17),
          ),
          if (securedSinceDate.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: appColors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.verified_rounded,
                    size: 14,
                    color: appColors.green,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    l10n?.settingsSecuredSince(securedSinceDate) ??
                        'Secured since $securedSinceDate',
                    style: appTextStyles.interRegular12(
                      color: appColors.grayLight,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMainSection(BuildContext context) {
    final settingsBloc = context.watch<SettingsBloc>();
    final settingsState = settingsBloc.state;
    final appBloc = context.watch<AppBloc>();
    final appState = appBloc.state;
    final l10n = AppLocalizations.of(context);
    final appColors = AppColors();

    final launchOnStartup = settingsState.launchOnStartup;
    final launchOnStartupFailed = settingsState.launchOnStartupFailed;
    final Protocols currentProtocol = appState.protocol;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel(text: l10n?.settingsMain ?? 'Main'),
        const SizedBox(height: 12),
        _SettingsCard(
          children: [
            _SettingItem(
              icon: Icons.vpn_key_rounded,
              title:
                  l10n?.settingsVPNProtocolSelection ??
                  'VPN Protocol Selection',
              description: currentProtocol == Protocols.auto
                  ? l10n?.settingsVPNProtocolAutomatic ?? 'Automatic'
                  : currentProtocol.displayName,
              trailing: Assets.images.settingsChevronRight.image(
                width: 24,
                height: 24,
              ),
              onTap: () {
                settingsBloc.add(const ProtocolTappedEvent());
              },
            ),
            if (PlatformUtils.isDesktop)
              _SettingItemWithSwitch(
                icon: Icons.power_settings_new_rounded,
                title: l10n?.settingsLaunchOnStartup ?? 'Launch on startup',
                description: launchOnStartupFailed
                    ? (l10n?.settingsLaunchOnStartupFailed ??
                          'Failed to activate, please try again')
                    : (l10n?.settingsLaunchOnStartupDescription ?? ''),
                value: launchOnStartup,
                onToggle: (value) {
                  settingsBloc.add(LaunchOnStartupChangedEvent(value));
                },
                activeColor: appColors.black,
                isError: launchOnStartupFailed,
              ),
            if (Platform.isAndroid)
              _SettingItemWithSwitch(
                icon: Icons.battery_charging_full_rounded,
                title: 'Ignore Battery Optimizations',
                description: settingsState.isIgnoringBatteryOptimizations
                    ? 'App is exempt from battery saving restrictions. Tap to manage in system settings'
                    : 'Exempt app to prevent connection drop-outs',
                value: settingsState.isIgnoringBatteryOptimizations,
                onToggle: (value) {
                  if (value) {
                    settingsBloc.add(
                      const RequestIgnoreBatteryOptimizationEvent(),
                    );
                  } else {
                    // Android doesn't let an app revoke its own battery
                    // optimization exemption, so hand off to system settings.
                    settingsBloc.add(
                      const OpenBatteryOptimizationSettingsEvent(),
                    );
                  }
                },
                activeColor: appColors.black,
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialSection(BuildContext context) {
    final appColors = AppColors();
    final settingsBloc = context.read<SettingsBloc>();
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel(
          text: l10n?.settingsSocialMedia ?? 'Zensheild on social media',
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: appColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 200,
                blurStyle: BlurStyle.normal,
                offset: const Offset(0, 170),
                spreadRadius: -100,
              ),
            ],
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  settingsBloc.add(const XTappedEvent());
                },
                child: Assets.images.xIcon.image(width: 32, height: 32),
              ),
              const SizedBox(width: 24),
              GestureDetector(
                onTap: () {
                  settingsBloc.add(const TelegramTappedEvent());
                },
                child: Assets.images.telegram.image(
                  fit: BoxFit.fill,
                  width: 32,
                  height: 32,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors();
    final appTextStyles = AppTextStyles();

    return Text(
      text.toUpperCase(),
      style: appTextStyles
          .interRegular12(color: appColors.grayLighter)
          .copyWith(letterSpacing: 0.6, fontWeight: FontWeight.w600),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors();
    final items = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      items.add(children[i]);
      if (i != children.length - 1) {
        items.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(
              height: 1,
              thickness: 1,
              color: appColors.grayUltraLight,
            ),
          ),
        );
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: appColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 200,
            blurStyle: BlurStyle.normal,
            offset: const Offset(0, 170),
            spreadRadius: -100,
          ),
        ],
      ),
      child: Column(children: items),
    );
  }
}

class _SettingIcon extends StatelessWidget {
  const _SettingIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors();

    return Container(
      width: 44,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: appColors.grayBackground,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 22, color: appColors.black),
    );
  }
}

class _LogOutButton extends StatelessWidget {
  const _LogOutButton();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final appColors = AppColors();
    final appTextStyles = AppTextStyles();
    final settingsBloc = context.read<SettingsBloc>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () {
          settingsBloc.add(const LogOutTappedEvent());
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: appColors.redBackground,
            borderRadius: BorderRadius.circular(29),
            border: Border.all(color: appColors.redVeryLight),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout_rounded, size: 18, color: appColors.red),
              const SizedBox(width: 8),
              Text(
                l10n?.settingsLogOut ?? 'Log out',
                textAlign: TextAlign.center,
                style: appTextStyles
                    .nunitoSansBold18(color: appColors.red)
                    .copyWith(fontSize: 17),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingItemWithSwitch extends StatelessWidget {
  const _SettingItemWithSwitch({
    required this.icon,
    required this.title,
    required this.description,
    required this.value,
    required this.onToggle,
    required this.activeColor,
    this.isError = false,
  });

  final IconData icon;
  final String title;
  final String description;
  final bool value;
  final ValueChanged<bool> onToggle;
  final Color activeColor;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors();
    final appTextStyles = AppTextStyles();
    final descriptionColor = isError
        ? appColors.redLight
        : appColors.grayLighter;

    return Padding(
      padding: const EdgeInsets.only(
        left: 10,
        right: 16,
        top: 14,
        bottom: 14,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _SettingIcon(icon: icon),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: appTextStyles
                      .interSemiBold16(color: appColors.black)
                      .copyWith(fontSize: 15),
                ),
                if (description.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: appTextStyles.latoRegular10(
                      color: descriptionColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          FlutterSwitch(
            value: value,
            onToggle: onToggle,
            activeColor: activeColor,
            inactiveColor: isError
                ? appColors.redToggleError
                : appColors.grayBackground,
            width: 50,
            height: 26,
            toggleSize: 22,
            padding: 3,
          ),
        ],
      ),
    );
  }
}

class _SettingItem extends StatelessWidget {
  const _SettingItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.trailing,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final Widget trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors();
    final appTextStyles = AppTextStyles();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 10,
          right: 16,
          top: 14,
          bottom: 14,
        ),
        child: Row(
          children: [
            _SettingIcon(icon: icon),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: appTextStyles
                        .interSemiBold16(color: appColors.black)
                        .copyWith(fontSize: 15),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: appTextStyles.latoRegular10(
                      color: appColors.grayLighter,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            trailing,
          ],
        ),
      ),
    );
  }
}

class _HeaderSettings extends StatelessWidget {
  const _HeaderSettings({required this.topPadding});

  final double topPadding;

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors();
    final appTextStyles = AppTextStyles();
    final settingsBloc = context.read<SettingsBloc>();

    return Padding(
      padding: EdgeInsets.only(
        left: 4,
        right: 16,
        bottom: 8,
        top: (16 - topPadding).clamp(0, 16),
      ),
      child: SizedBox(
        height: 48,
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                settingsBloc.add(const NavigateToHomeEvent());
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Assets.images.chevronLeft.image(
                  width: 24,
                  height: 24,
                ),
              ),
            ),
            const SizedBox(width: 4),
            Text(
              'Menu',
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
