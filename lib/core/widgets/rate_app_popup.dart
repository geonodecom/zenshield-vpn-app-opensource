import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zenshield/config/constants/urls.dart';
import 'package:zenshield/core/managers/analytics_events.dart';
import 'package:zenshield/core/managers/analytics_manager.dart';
import 'package:zenshield/di/injection_container.dart';
import 'package:zenshield/gen/assets.gen.dart';
import 'package:zenshield/l10n/app_localizations.dart';
import 'package:zenshield/config/theme/app_colors/app_colors.dart';
import 'package:zenshield/config/theme/app_text_styles/app_text_styles.dart';

class RateAppPopup extends StatefulWidget {
  const RateAppPopup({
    required this.onContinueTap,
    super.key,
  });

  final VoidCallback? onContinueTap;

  @override
  State<RateAppPopup> createState() => _RateAppPopupState();

  static Future<T?> show<T>(
    BuildContext context, {
    required VoidCallback? onContinueTap,
  }) {
    final appColors = AppColors();
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: appColors.black.withValues(alpha: 0.6),
      builder: (context) => RateAppPopup(
        onContinueTap: onContinueTap,
      ),
    );
  }
}

class _RateAppPopupState extends State<RateAppPopup> {
  late TapGestureRecognizer _feedbackLinkRecognizer;
  int _selectedRating = 0;

  @override
  void initState() {
    super.initState();
    _feedbackLinkRecognizer = TapGestureRecognizer();
    _feedbackLinkRecognizer.onTap = _onFeedbackLinkTap;
  }

  @override
  void dispose() {
    _feedbackLinkRecognizer.dispose();
    super.dispose();
  }

  Future<void> _onFeedbackLinkTap() async {
    Navigator.of(context).pop();
    await launchUrl(Uri.parse('mailto:${Urls.supportEmail}'));
  }

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors();
    final appTextStyles = AppTextStyles();
    final l10n = AppLocalizations.of(context);
    final analyticsManager = getIt<AbstractAnalyticsManager>();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 350,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: appColors.white,
            borderRadius: BorderRadius.circular(32),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 64,
                      height: 6,
                      decoration: BoxDecoration(
                        color: appColors.grayBackground,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n?.rateAppPopupTitle ??
                          'Feeling safer with Zenshield?',
                      textAlign: TextAlign.center,
                      style: appTextStyles.helveticaNeueBold20(
                        color: appColors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n?.rateAppPopupSubtitle ??
                          'Your review helps others stay safe online.',
                      textAlign: TextAlign.center,
                      style: appTextStyles.interRegular16(
                        color: appColors.black,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        final starIndex = index + 1;
                        final isActive = _selectedRating >= starIndex;
                        final double size = 44;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedRating = starIndex;
                            });

                            analyticsManager.sendEvent(
                              AnalyticsEventNames.app_rated,
                              {'rating': starIndex.toString()},
                            );
                            if (starIndex == 5) {
                              widget.onContinueTap?.call();
                            }
                            Navigator.of(context).pop();
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 7),
                            child: isActive
                                ? Assets.images.activeStar
                                    .image(width: size, height: size)
                                : Assets.images.inactiveStar
                                    .image(width: size, height: size),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 40),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: appTextStyles.interRegular14(
                          color: appColors.black,
                        ),
                        children: [
                          TextSpan(
                            text: l10n?.rateAppPopupFeedbackPrefix ??
                                'Got feedback? ',
                          ),
                          TextSpan(
                            text: l10n?.rateAppPopupFeedbackLink ?? 'Tap here',
                            recognizer: _feedbackLinkRecognizer,
                            style: appTextStyles
                                .interRegular14(
                                  color: appColors.black,
                                )
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                          ),
                          TextSpan(
                            text: l10n?.rateAppPopupFeedbackSuffix ??
                                ' to tell us directly.',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
