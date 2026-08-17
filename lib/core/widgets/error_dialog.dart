import 'package:flutter/material.dart';
import 'package:zenshield/l10n/app_localizations.dart';
import 'package:zenshield/config/theme/app_colors/app_colors.dart';
import 'package:zenshield/config/theme/app_text_styles/app_text_styles.dart';

class MessageDialog extends StatelessWidget {
  const MessageDialog({
    super.key,
    required this.title,
    this.titleWidget,
    required this.message,
    this.positiveButtonText,
    this.negativeButtonText,
    this.onPositivePressed,
    this.onNegativePressed,
    this.boldTitle = false,
    this.isDestructiveAction = false,
  });

  final String title;
  final Widget? titleWidget;
  final String message;
  final String? positiveButtonText;
  final String? negativeButtonText;
  final VoidCallback? onPositivePressed;
  final VoidCallback? onNegativePressed;
  final bool boldTitle;

  /// When true, the [positiveButtonText] action is treated as the
  /// destructive/riskier choice (e.g. "Turn off VPN") and is shown as the
  /// de-emphasized button, while [negativeButtonText] becomes the
  /// prominent, filled button. Does not change which callback fires for
  /// which label — only which one is visually emphasized.
  final bool isDestructiveAction;

  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    Widget? titleWidget,
    required String message,
    String? positiveButtonText,
    String? negativeButtonText,
    VoidCallback? onPositivePressed,
    VoidCallback? onNegativePressed,
    bool boldTitle = false,
    bool isDestructiveAction = false,
  }) {
    return showDialog<T>(
      context: context,
      builder: (context) => MessageDialog(
        title: title,
        titleWidget: titleWidget,
        message: message,
        positiveButtonText: positiveButtonText,
        negativeButtonText: negativeButtonText,
        onPositivePressed: onPositivePressed,
        onNegativePressed: onNegativePressed,
        boldTitle: boldTitle,
        isDestructiveAction: isDestructiveAction,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors();
    final appTextStyles = AppTextStyles();
    final l10n = AppLocalizations.of(context);

    final hasTwoButtons =
        positiveButtonText != null && negativeButtonText != null;

    void handlePositive() {
      if (onPositivePressed != null) {
        onPositivePressed!();
      } else {
        Navigator.of(context).pop(true);
      }
    }

    void handleNegative() {
      if (onNegativePressed != null) {
        onNegativePressed!();
      } else {
        Navigator.of(context).pop(false);
      }
    }

    final primaryText = isDestructiveAction
        ? negativeButtonText
        : positiveButtonText;
    final primaryAction = isDestructiveAction ? handleNegative : handlePositive;
    final secondaryText = isDestructiveAction
        ? positiveButtonText
        : negativeButtonText;
    final secondaryAction = isDestructiveAction
        ? handlePositive
        : handleNegative;
    final secondaryTextColor = isDestructiveAction
        ? appColors.red
        : appColors.black;

    return Dialog(
      backgroundColor: appColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            titleWidget ??
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style:
                      (boldTitle
                              ? appTextStyles.latoBold16(color: appColors.black)
                              : appTextStyles.latoRegular16(
                                  color: appColors.black,
                                ))
                          .copyWith(fontSize: 18),
                ),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: appTextStyles
                  .interRegular14(color: appColors.grayLight)
                  .copyWith(height: 1.5),
            ),
            const SizedBox(height: 24),
            if (hasTwoButtons) ...[
              _DialogButton(
                text: primaryText!,
                filled: true,
                textColor: appColors.white,
                fillColor: appColors.black,
                onTap: primaryAction,
              ),
              const SizedBox(height: 10),
              _DialogButton(
                text: secondaryText!,
                filled: false,
                textColor: secondaryTextColor,
                onTap: secondaryAction,
              ),
            ] else
              _DialogButton(
                text: l10n?.ok ?? 'OK',
                filled: true,
                textColor: appColors.white,
                fillColor: appColors.black,
                onTap: () => Navigator.of(context).pop(),
              ),
          ],
        ),
      ),
    );
  }
}

class _DialogButton extends StatelessWidget {
  const _DialogButton({
    required this.text,
    required this.filled,
    required this.textColor,
    required this.onTap,
    this.fillColor,
  });

  final String text;
  final bool filled;
  final Color textColor;
  final Color? fillColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors();
    final appTextStyles = AppTextStyles();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: filled ? fillColor : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: filled ? null : Border.all(color: appColors.grayUltraLight),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: appTextStyles
              .nunitoSansBold18(color: textColor)
              .copyWith(fontSize: 16),
        ),
      ),
    );
  }
}
