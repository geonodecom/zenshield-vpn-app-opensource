import 'package:flutter/material.dart';
import 'package:zenshield/config/theme/app_colors/app_colors.dart';
import 'package:zenshield/config/theme/app_text_styles/app_text_styles.dart';

class SelectableListItem extends StatelessWidget {
  const SelectableListItem({
    super.key,
    this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
    required this.isShowChevron,
    this.titleColor,
  });

  final Widget? icon;
  final String title;
  final bool isSelected;
  final VoidCallback? onTap;
  final Color? titleColor;
  final bool isShowChevron;

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors();
    final appTextStyles = AppTextStyles();

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        constraints: const BoxConstraints(minHeight: 60),
        padding: const EdgeInsets.only(
          left: 12,
          right: 16,
          top: 10,
          bottom: 10,
        ),
        decoration: BoxDecoration(
          color: isSelected ? appColors.grayVeryLight : appColors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected
                ? appColors.grayVeryLight
                : appColors.grayUltraLight,
          ),
        ),
        child: Row(
          children: [
            if (icon != null) ...[icon!, const SizedBox(width: 12)],
            Expanded(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: appTextStyles
                    .interRegular14(color: titleColor ?? appColors.black)
                    .copyWith(
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
              ),
            ),
            const SizedBox(width: 8),
            if (isSelected)
              Icon(Icons.check_circle_rounded, size: 22, color: appColors.black)
            else if (isShowChevron)
              Icon(
                Icons.chevron_right_rounded,
                size: 22,
                color: appColors.grayLighter,
              )
            else
              const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
