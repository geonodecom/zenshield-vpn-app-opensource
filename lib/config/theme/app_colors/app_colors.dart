import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_colors.freezed.dart';

@freezed
class AppColors with _$AppColors {
  const factory AppColors({
    // Black & Dark colors
    @Default(Color(0xFF000000)) Color black,
    @Default(Color(0xFF020202)) Color black2,
    @Default(Color(0xFF120E0D)) Color dark,
    @Default(Color(0xFF1D1D1F)) Color darkGray,

    // Gray colors
    @Default(Color(0xFF323438)) Color grayDark,
    @Default(Color(0xFF333333)) Color gray,
    @Default(Color(0xFF344054)) Color grayMedium,
    @Default(Color(0xFF444444)) Color graySection,
    @Default(Color(0xFF475467)) Color grayMedium2,
    @Default(Color(0xFF667085)) Color grayLight,
    @Default(Color(0xFF98A2B3)) Color grayLighter,
    @Default(Color(0xFFA9A9A9)) Color grayLight2,
    @Default(Color(0xFFD0D5DD)) Color grayVeryLight,
    @Default(Color(0xFFE4E7ED)) Color grayUltraLight,
    @Default(Color(0xFFEAECF0)) Color grayBackground,

    // White & Background colors
    @Default(Color(0xFFF9FAFB)) Color background,
    @Default(Color(0xFFFFFFFF)) Color white,

    // Blue colors
    @Default(Color(0xFF101727)) Color blueDark,
    @Default(Color(0xFF1877F2)) Color blue,

    // Green colors
    @Default(Color(0xFF4BFFB3)) Color green,

    // Warning colors
    @Default(Color(0xFFF79009)) Color warning,
    @Default(Color(0xFFFFFAEB)) Color warningBackground,

    // Red colors
    @Default(Color(0xFFB42318)) Color redDark,
    @Default(Color(0xFFD92D20)) Color red,
    @Default(Color(0xFFF04438)) Color redLight,
    @Default(Color(0xFFFDA29B)) Color redToggleError,
    @Default(Color(0xFFFECDCA)) Color redVeryLight,
    @Default(Color(0xFFFEF3F2)) Color redBackground,
  }) = _AppColors;
}
