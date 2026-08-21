import 'package:flutter/material.dart';
import 'package:zenshield/config/theme/app_colors/app_colors.dart';
import 'package:zenshield/config/theme/app_text_styles/app_text_styles.dart';
import 'package:zenshield/core/widgets/web_view.dart';
import 'package:zenshield/gen/assets.gen.dart';

/// Full-page viewer for legal/policy documents, used instead of a bottom
/// sheet so EULA and Privacy Policy both open the same way: a normal in-app
/// page with a back button.
class LegalDocumentView extends StatelessWidget {
  const LegalDocumentView({
    super.key,
    required this.title,
    required this.url,
  });

  final String title;
  final Uri url;

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors();
    final appTextStyles = AppTextStyles();

    return Scaffold(
      backgroundColor: appColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 4,
                right: 16,
                top: 8,
                bottom: 8,
              ),
              child: SizedBox(
                height: 48,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Assets.images.chevronLeft.image(
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 44),
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: appTextStyles
                            .interSemiBold16(color: appColors.black)
                            .copyWith(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: WebView(url: url),
            ),
          ],
        ),
      ),
    );
  }
}
