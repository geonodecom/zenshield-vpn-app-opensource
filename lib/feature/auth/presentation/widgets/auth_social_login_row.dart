import 'dart:io';

import 'package:flutter/material.dart';
import 'package:zenshield/gen/assets.gen.dart';
import 'package:zenshield/l10n/app_localizations.dart';
import 'package:zenshield/config/theme/app_colors/app_colors.dart';
import 'package:zenshield/config/theme/app_text_styles/app_text_styles.dart';

class AuthSocialLoginRow extends StatelessWidget {
  const AuthSocialLoginRow({
    super.key,
    required this.onGoogleTap,
    required this.onFacebookTap,
    required this.onAppleTap,
  });

  final VoidCallback onGoogleTap;
  final VoidCallback onFacebookTap;
  final VoidCallback onAppleTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors();
    final appTextStyles = AppTextStyles();
    final l10n = AppLocalizations.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Divider(color: colors.grayUltraLight, thickness: 1),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Text(
                l10n?.orContinueWith ?? 'Or continue with:',
                style: appTextStyles.interRegular12(
                  color: colors.grayDark.withValues(alpha: 0.8),
                ),
              ),
            ),
            Expanded(
              child: Divider(color: colors.grayUltraLight, thickness: 1),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Facebook and Google icons already include their own circular
            // badge/branding, so they sit on a plain white backing.
            _SocialButton(
              backgroundColor: colors.white,
              icon: Assets.images.facebook,
              iconSize: 34,
              onTap: onFacebookTap,
            ),
            const SizedBox(width: 16),
            _SocialButton(
              backgroundColor: colors.white,
              icon: Assets.images.google,
              iconSize: 34,
              onTap: onGoogleTap,
            ),
            if (Platform.isIOS) ...[
              const SizedBox(width: 16),
              _SocialButton(
                backgroundColor: colors.black,
                icon: Assets.images.apple,
                iconSize: 22,
                onTap: onAppleTap,
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.backgroundColor,
    required this.icon,
    required this.iconSize,
    required this.onTap,
  });

  final Color backgroundColor;
  final AssetGenImage icon;
  final double iconSize;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: icon.image(width: iconSize, height: iconSize),
        ),
      ),
    );
  }
}
