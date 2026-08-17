import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenshield/config/constants/urls.dart';
import 'package:zenshield/config/theme/app_colors/app_colors.dart';
import 'package:zenshield/config/theme/app_text_styles/app_text_styles.dart';
import 'package:zenshield/core/utils/platform_utils.dart';
import 'package:zenshield/feature/about/presentation/legal_document_view.dart';
import 'package:zenshield/feature/auth/presentation/auth_bloc.dart';
import 'package:zenshield/l10n/app_localizations.dart';

class AuthTermsCheckbox extends StatelessWidget {
  const AuthTermsCheckbox({
    super.key,
    required this.isAccepted,
    required this.onToggle,
  });

  final bool isAccepted;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors();
    final appTextStyles = AppTextStyles();
    final l10n = AppLocalizations.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onToggle,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: isAccepted ? colors.black : colors.white,
              border: Border.all(
                color: isAccepted ? colors.black : colors.grayLight,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(7),
            ),
            child: isAccepted
                ? const Icon(Icons.check_rounded, size: 15, color: Colors.white)
                : null,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: onToggle,
            child: _buildTermsText(
              context,
              Platform.isIOS
                  ? (l10n?.termsAgreementIos ??
                        'I agree to the End User License Agreement (EULA), Privacy Policy.')
                  : (l10n?.termsAgreement ??
                        'I agree to the Terms and Privacy Policy'),
              appTextStyles,
              colors,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTermsText(
    BuildContext context,
    String text,
    AppTextStyles appTextStyles,
    AppColors colors,
  ) {
    final baseStyle = appTextStyles
        .interRegular12(color: colors.grayLight)
        .copyWith(fontSize: 11);
    final terms = [
      'End User License Agreement (EULA)',
      'Privacy Policy',
      'Bandwidth Sharing Policy',
    ];
    final spans = <TextSpan>[];
    int lastIndex = 0;
    bool foundAny = false;

    for (final term in terms) {
      final index = text.indexOf(term, lastIndex);
      if (index != -1) {
        foundAny = true;

        if (index > lastIndex) {
          spans.add(
            TextSpan(text: text.substring(lastIndex, index), style: baseStyle),
          );
        }

        final linkStyle = baseStyle.copyWith(
          decoration: TextDecoration.underline,
        );

        final l10n = AppLocalizations.of(context);

        TapGestureRecognizer? recognizer;
        if (term == 'End User License Agreement (EULA)') {
          recognizer = TapGestureRecognizer()
            ..onTap = () {
              final languageCode = Localizations.localeOf(context).languageCode;
              if (PlatformUtils.isDesktop) {
                context.read<AuthBloc>().add(
                  AuthTermsOfUseDesktopTapped(languageCode: languageCode),
                );
              } else {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => LegalDocumentView(
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
            };
        } else if (term == 'Privacy Policy') {
          recognizer = TapGestureRecognizer()
            ..onTap = () {
              final languageCode = Localizations.localeOf(context).languageCode;
              if (PlatformUtils.isDesktop) {
                context.read<AuthBloc>().add(
                  AuthPrivacyPolicyDesktopTapped(languageCode: languageCode),
                );
              } else {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => LegalDocumentView(
                      title: l10n?.aboutPrivacyPolicy ?? 'Privacy Policy',
                      url: Urls.privacyPolicy(languageCode: languageCode),
                    ),
                  ),
                );
              }
            };
        } else if (term == 'Bandwidth Sharing Policy') {
          recognizer = TapGestureRecognizer()
            ..onTap = () {
              final languageCode = Localizations.localeOf(context).languageCode;
              if (PlatformUtils.isDesktop) {
                context.read<AuthBloc>().add(
                  AuthBandwidthSharingPolicyTapped(languageCode: languageCode),
                );
              } else {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => LegalDocumentView(
                      title:
                          l10n?.aboutBandwidthSharingPolicy ??
                          'Bandwidth Sharing Policy',
                      url: Urls.bandwidthSharingPolicy(
                        languageCode: languageCode,
                      ),
                    ),
                  ),
                );
              }
            };
        }

        spans.add(
          TextSpan(text: term, style: linkStyle, recognizer: recognizer),
        );
        lastIndex = index + term.length;
      }
    }

    if (lastIndex < text.length) {
      spans.add(TextSpan(text: text.substring(lastIndex), style: baseStyle));
    }

    if (!foundAny || spans.isEmpty) {
      return Text(text, style: baseStyle);
    }

    return Text.rich(TextSpan(children: spans));
  }
}
