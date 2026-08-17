import 'package:flutter/material.dart';
import 'package:zenshield/config/theme/app_colors/app_colors.dart';
import 'package:zenshield/config/theme/app_text_styles/app_text_styles.dart';
import 'package:zenshield/core/widgets/black_circular_progress_indicator.dart';

class AuthPrimaryButton extends StatelessWidget {
  const AuthPrimaryButton({
    super.key,
    required this.text,
    required this.isEnabled,
    required this.isLoading,
    required this.onPressed,
  });

  final String text;
  final bool isEnabled;
  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors();
    final appTextStyles = AppTextStyles();

    final buttonColor = isEnabled ? colors.black : colors.white;
    final textColor = isEnabled ? colors.white : colors.grayVeryLight;

    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(29),
        boxShadow: isEnabled
            ? [
                BoxShadow(
                  color: colors.black.withValues(alpha: 0.25),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: ElevatedButton(
        onPressed: isEnabled && !isLoading ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: textColor,
          side: isEnabled
              ? null
              : BorderSide(color: colors.grayVeryLight, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(29),
          ),
          elevation: 0,
          disabledBackgroundColor: buttonColor,
          disabledForegroundColor: textColor,
          splashFactory: NoSplash.splashFactory,
        ),
        child: isLoading
            ? const BlackCircularProgressIndicator(size: 20, strokeWidth: 2)
            : Text(
                text,
                style: appTextStyles.nunitoSansBold18(color: textColor),
              ),
      ),
    );
  }
}
