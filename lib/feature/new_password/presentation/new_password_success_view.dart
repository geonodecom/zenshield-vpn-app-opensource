import 'package:flutter/material.dart';
import 'package:zenshield/gen/assets.gen.dart';
import 'package:zenshield/l10n/app_localizations.dart';
import 'package:zenshield/feature/auth/presentation/auth_view.dart';
import 'package:zenshield/config/theme/app_colors/app_colors.dart';
import 'package:zenshield/config/theme/app_text_styles/app_text_styles.dart';

class ChangePasswordSuccessView extends StatelessWidget {
  const ChangePasswordSuccessView({super.key});

  static const routeName = '/change_password_success';

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors();
    final appTextStyles = AppTextStyles();
    final l10n = AppLocalizations.of(context);
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: appColors.white,
      body: SafeArea(
        bottom: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Assets.images.changedPassword.image(
                      width: 390,
                      height: 360,
                    ),
                    const SizedBox(height: 70),
                    Text(
                      l10n?.changePasswordSuccessTitle ?? 'All set!',
                      textAlign: TextAlign.center,
                      style: appTextStyles.helveticaNeueBold24(
                        color: appColors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        l10n?.changePasswordSuccessMessage ??
                            'Your password is now updated',
                        textAlign: TextAlign.center,
                        style: appTextStyles.interRegular14(
                          color: appColors.grayLight,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.09),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 57,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed(
                          AuthView.routeName,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appColors.black,
                        foregroundColor: appColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(29),
                        ),
                        elevation: 0,
                        splashFactory: NoSplash.splashFactory,
                      ),
                      child: Text(
                        l10n?.changePasswordSuccessButton ?? 'Got it',
                        style: appTextStyles.nunitoSansBold18(
                          color: appColors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
