import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zenshield/core/models/theme.dart';
import 'package:zenshield/config/theme/app_colors/app_colors.dart';

part 'app_theme.freezed.dart';

@freezed
class AppTheme with _$AppTheme {
  const factory AppTheme({
    required ThemeType themeType,
    required AppColors colors,
  }) = _AppTheme;
}
