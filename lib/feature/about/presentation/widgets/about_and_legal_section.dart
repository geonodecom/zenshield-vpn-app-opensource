import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zenshield/config/constants/urls.dart';
import 'package:zenshield/config/theme/app_colors/app_colors.dart';
import 'package:zenshield/config/theme/app_text_styles/app_text_styles.dart';
import 'package:zenshield/core/managers/analytics_manager.dart';
import 'package:zenshield/core/utils/platform_utils.dart';
import 'package:zenshield/di/injection_container.dart';
import 'package:zenshield/feature/about/presentation/about_bloc.dart';
import 'package:zenshield/feature/about/presentation/about_side_effect.dart';
import 'package:zenshield/feature/about/presentation/about_view.dart';
import 'package:zenshield/feature/about/presentation/legal_document_view.dart';
import 'package:zenshield/feature/agreements/domain/useCase/agreement_use_case.dart';
import 'package:zenshield/l10n/app_localizations.dart';

/// "About & Legal" card shown on the Profile (settings) page: an About row
/// that opens [AboutView], plus the legal document links that used to live
/// inside the About page itself.
class AboutAndLegalSection extends StatelessWidget {
  const AboutAndLegalSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AboutBloc(
        logger: getIt<Talker>(),
        analyticsManager: getIt<AbstractAnalyticsManager>(),
        agreementUseCase: getIt<AbstractAgreementUseCase>(),
      ),
      child: BlocSideEffectListener<AboutBloc, AboutSideEffect>(
        listener: (context, sideEffect) async {
          if (sideEffect is ShowBandwidthSharingPolicyPage) {
            final l10n = AppLocalizations.of(context);
            await Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => LegalDocumentView(
                  title:
                      l10n?.aboutBandwidthSharingPolicy ??
                      'Bandwidth Sharing Policy',
                  htmlContent: sideEffect.htmlContent,
                  url: sideEffect.fallbackUrl,
                ),
              ),
            );
          }
        },
        child: const _SectionContent(),
      ),
    );
  }
}

class _SectionContent extends StatelessWidget {
  const _SectionContent();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final aboutBloc = context.watch<AboutBloc>();
    final isLoadingAgreement = aboutBloc.state.isLoadingAgreement;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel(
          text: l10n?.aboutLegalAndSupportTitle ?? 'Legal & Support Links',
        ),
        const SizedBox(height: 12),
        _Card(
          children: [
            _LinkRow(
              icon: Icons.info_outline_rounded,
              title: l10n?.aboutTitle ?? 'About Zenshield',
              onTap: () {
                Navigator.of(context).pushNamed(AboutView.routeName);
              },
            ),
            _LinkRow(
              icon: Icons.description_outlined,
              title:
                  l10n?.aboutEndUserLicenseAgreement ??
                  'End User License Agreement',
              onTap: () {
                final languageCode = Localizations.localeOf(
                  context,
                ).languageCode;
                if (PlatformUtils.isDesktop) {
                  aboutBloc.add(OpenEulaEvent(languageCode));
                } else {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => LegalDocumentView(
                        title:
                            l10n?.aboutEndUserLicenseAgreement ??
                            'End User License Agreement',
                        url: Urls.endUserLicenseAgreement(
                          languageCode: languageCode,
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
            _LinkRow(
              icon: Icons.privacy_tip_outlined,
              title: l10n?.aboutPrivacyPolicy ?? 'Privacy Policy',
              onTap: () {
                final languageCode = Localizations.localeOf(
                  context,
                ).languageCode;
                if (PlatformUtils.isDesktop) {
                  aboutBloc.add(OpenPrivacyPolicyEvent(languageCode));
                } else {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => LegalDocumentView(
                        title: l10n?.aboutPrivacyPolicy ?? 'Privacy Policy',
                        url: Urls.privacyPolicy(languageCode: languageCode),
                      ),
                    ),
                  );
                }
              },
            ),
            if (!Platform.isIOS)
              _LinkRow(
                icon: Icons.policy_outlined,
                title:
                    l10n?.aboutBandwidthSharingPolicy ??
                    'Bandwidth Sharing Policy',
                isLoading: isLoadingAgreement,
                onTap: () {
                  final languageCode = Localizations.localeOf(
                    context,
                  ).languageCode;
                  aboutBloc.add(OpenBandwidthSharingPolicyEvent(languageCode));
                },
              ),
          ],
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

class _LinkRow extends StatelessWidget {
  const _LinkRow({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isLoading = false,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors();
    final appTextStyles = AppTextStyles();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: isLoading ? null : onTap,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 10,
          right: 16,
          top: 14,
          bottom: 14,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: appColors.grayBackground,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 19, color: appColors.black),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: appTextStyles
                    .interSemiBold16(color: appColors.black)
                    .copyWith(fontSize: 15),
              ),
            ),
            const SizedBox(width: 8),
            if (isLoading)
              SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: appColors.grayLighter,
                ),
              )
            else
              Icon(
                Icons.chevron_right_rounded,
                size: 22,
                color: appColors.grayLighter,
              ),
          ],
        ),
      ),
    );
  }
}
