import 'package:flutter/material.dart';
import 'package:zenshield/gen/assets.gen.dart';
import 'package:zenshield/l10n/app_localizations.dart';
import 'package:zenshield/config/theme/app_colors/app_colors.dart';
import 'package:zenshield/config/theme/app_text_styles/app_text_styles.dart';

class AuthPasswordField extends StatelessWidget {
  const AuthPasswordField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.hintText,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final String hintText;
  final VoidCallback? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors();
    final appTextStyles = AppTextStyles();
    final l10n = AppLocalizations.of(context);

    return ListenableBuilder(
      listenable: Listenable.merge([focusNode, controller]),
      builder: (context, _) {
        final hasFocus = focusNode.hasFocus;
        final hasText = controller.text.isNotEmpty;
        final iconColor = (hasFocus || hasText)
            ? colors.black
            : colors.grayLight2;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n?.passwordLabel ?? 'Password',
              style: appTextStyles.interRegular12(
                color: colors.grayDark.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 11),
            Container(
              height: 52,
              decoration: BoxDecoration(
                color: colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: hasFocus ? colors.black : Colors.transparent,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: hasFocus ? 0.10 : 0.05,
                    ),
                    blurRadius: 200,
                    blurStyle: BlurStyle.normal,
                    offset: const Offset(0, 170),
                    spreadRadius: -100,
                  ),
                ],
              ),
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                onChanged: onChanged,
                onSubmitted: (_) => onSubmitted?.call(),
                textInputAction: TextInputAction.done,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: appTextStyles.latoRegular16(
                    color: colors.grayLight2,
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(17),
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          iconColor,
                          BlendMode.srcIn,
                        ),
                        child: Assets.images.password.image(
                          width: 24,
                          height: 24,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
