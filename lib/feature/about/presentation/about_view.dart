import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenshield/config/constants/urls.dart';
import 'package:zenshield/core/utils/platform_utils.dart';
import 'package:zenshield/di/injection_container.dart';
import 'package:zenshield/gen/assets.gen.dart';
import 'package:zenshield/l10n/app_localizations.dart';
import 'package:zenshield/core/widgets/error_dialog.dart';
import 'package:zenshield/feature/about/presentation/about_bloc.dart';
import 'package:zenshield/feature/about/presentation/about_side_effect.dart';
import 'package:zenshield/feature/logs/presentation/logs_view.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:zenshield/config/theme/app_colors/app_colors.dart';
import 'package:zenshield/config/theme/app_text_styles/app_text_styles.dart';
import 'package:talker_flutter/talker_flutter.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  static const routeName = '/about';

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors();
    final l10n = AppLocalizations.of(context);

    return BlocProvider(
      create: (context) => AboutBloc(logger: getIt<Talker>()),
      child: BlocSideEffectListener<AboutBloc, AboutSideEffect>(
        listener: (context, sideEffect) async {
          if (sideEffect is NavigateToLogsSideEffect) {
            Navigator.of(context).pushNamed(LogsView.routeName);
          }
        },
        child: Scaffold(
          backgroundColor: appColors.white,
          body: SafeArea(
            child: Column(
              children: [
                _Header(topPadding: MediaQuery.of(context).padding.top),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _HeroSection(l10n: l10n),
                        const SizedBox(height: 24),
                        _AboutInfoSection(l10n: l10n),
                        const SizedBox(height: 12),
                        _TroubleshootingSection(l10n: l10n),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.topPadding});

  final double topPadding;

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors();
    final appTextStyles = AppTextStyles();
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: EdgeInsets.only(
        left: 4,
        right: 16,
        bottom: 8,
        top: PlatformUtils.isDesktop ? 20 : (16 - topPadding).clamp(0, 16),
      ),
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
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Assets.images.chevronLeft.image(width: 24, height: 24),
                ),
              ),
            ),
            Text(
              l10n?.aboutTitle ?? 'About Zenshield',
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

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.l10n});

  final AppLocalizations? l10n;

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors();
    final appTextStyles = AppTextStyles();
    final aboutBloc = context.watch<AboutBloc>();
    final appVersion = aboutBloc.state.appVersion;

    return Center(
      child: Column(
        children: [
          Container(
            width: 76,
            height: 76,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: appColors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Assets.images.appLogo.image(fit: BoxFit.contain),
          ),
          const SizedBox(height: 14),
          Text(
            'Zenshield VPN',
            style: appTextStyles
                .interSemiBold16(color: appColors.black)
                .copyWith(fontSize: 18),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            // Tap the version chip 5 times to reveal the debug logs screen.
            onTap: () {
              context.read<AboutBloc>().add(const VersionTappedEvent());
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: appColors.background,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                appVersion,
                style: appTextStyles.interRegular12(
                  color: appColors.grayLight,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.children});

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
      width: double.infinity,
      decoration: BoxDecoration(
        color: appColors.white,
        borderRadius: BorderRadius.circular(18),
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

class _InfoBlock extends StatelessWidget {
  const _InfoBlock({
    required this.icon,
    required this.title,
    required this.description,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String description;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors();
    final appTextStyles = AppTextStyles();

    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 16, top: 14, bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: appColors.grayBackground,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 15, color: appColors.black),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: appTextStyles
                      .interSemiBold16(color: appColors.black)
                      .copyWith(fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: appTextStyles
                .interRegular13(color: appColors.grayLight)
                .copyWith(height: 1.45),
          ),
          if (trailing != null) ...[const SizedBox(height: 12), trailing!],
        ],
      ),
    );
  }
}

class _AboutInfoSection extends StatelessWidget {
  const _AboutInfoSection({required this.l10n});

  final AppLocalizations? l10n;

  @override
  Widget build(BuildContext context) {
    return _Card(
      children: [
        _InfoBlock(
          icon: Icons.shield_outlined,
          title: l10n?.aboutWhatIsZenshield ?? 'What is Zenshield?',
          description:
              l10n?.aboutWhatIsZenshieldDescription ??
              'Zenshield is a modern, community-powered VPN that protects your data while helping others stay secure.',
        ),
      ],
    );
  }
}

class _TroubleshootingSection extends StatelessWidget {
  const _TroubleshootingSection({required this.l10n});

  final AppLocalizations? l10n;

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors();
    final appTextStyles = AppTextStyles();

    return _Card(
      children: [
        _InfoBlock(
          icon: Icons.support_agent_rounded,
          title:
              l10n?.aboutTroubleshootingTitle ?? 'Troubleshooting & Feedback',
          description:
              'Having an issue or found a bug? Reach out and we\'ll help.',
          trailing: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () async {
              Clipboard.setData(ClipboardData(text: Urls.supportEmail));
              await MessageDialog.show(
                context,
                title: l10n?.aboutEmailCopiedTitle ?? 'Copied',
                message:
                    l10n?.aboutEmailCopiedToClipboard ??
                    'Email address copied to clipboard',
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: appColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.email_outlined,
                    size: 16,
                    color: appColors.grayLight,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      Urls.supportEmail,
                      style: appTextStyles
                          .interSemiBold16(color: appColors.black)
                          .copyWith(fontSize: 13),
                    ),
                  ),
                  Icon(
                    Icons.copy_rounded,
                    size: 16,
                    color: appColors.grayLighter,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
