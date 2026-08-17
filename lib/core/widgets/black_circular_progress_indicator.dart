import 'package:flutter/material.dart';
import 'package:zenshield/config/theme/app_colors/app_colors.dart';
class BlackCircularProgressIndicator extends StatelessWidget {
  const BlackCircularProgressIndicator({
    super.key,
    this.strokeWidth,
    this.size,
  });
  final double? strokeWidth;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors();
    final indicator = CircularProgressIndicator(
      strokeWidth: strokeWidth ?? 4.0,
      valueColor: AlwaysStoppedAnimation<Color>(appColors.black),
    );

    if (size != null) {
      return SizedBox(
        width: size,
        height: size,
        child: indicator,
      );
    }

    return indicator;
  }
}