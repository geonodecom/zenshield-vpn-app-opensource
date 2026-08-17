import 'package:flutter/material.dart';
import 'package:zenshield/config/theme/app_colors/app_colors.dart';
import 'package:zenshield/config/theme/app_text_styles/app_text_styles.dart';
import 'package:zenshield/gen/assets.gen.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({
    super.key,
    required this.isKeyboardVisible,
    required this.title,
    this.subtitle,
  });

  final bool isKeyboardVisible;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors();
    final appTextStyles = AppTextStyles();

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        opacity: isKeyboardVisible ? 0.0 : 1.0,
        child: isKeyboardVisible
            ? const SizedBox(height: 20)
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 72),
                  Assets.images.authLogo.image(width: 180, height: 30),
                  const SizedBox(height: 24),
                  Text(
                    title,
                    style: appTextStyles
                        .interSemiBold16(color: colors.black)
                        .copyWith(fontSize: 22),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      subtitle!,
                      textAlign: TextAlign.center,
                      style: appTextStyles.interRegular13(
                        color: colors.grayLight,
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),
                ],
              ),
      ),
    );
  }
}
