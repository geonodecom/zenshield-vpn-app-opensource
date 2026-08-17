import 'package:flutter/material.dart';
import 'package:zenshield/core/widgets/rounded_flag.dart';
import 'package:zenshield/core/utils/string_utils.dart';
import 'package:zenshield/config/theme/app_colors/app_colors.dart';
import 'package:zenshield/config/theme/app_text_styles/app_text_styles.dart';
import 'package:zenshield/core/widgets/black_circular_progress_indicator.dart';

class HomeServerItem extends StatelessWidget {
  const HomeServerItem({
    super.key,
    required this.cityName,
    required this.countryName,
    required this.ip,
    required this.flagUrl,
    required this.onTap,
    required this.countryCode,
    this.subtitle,
    this.subtitleFlagCountryCode,
    this.subtitleFlagUrl,
    this.isSubtitleLoading = false,
  });

  final String cityName;
  final String countryName;
  final String ip;
  final String flagUrl;
  final VoidCallback onTap;
  final String countryCode;

  /// Overrides the second line (defaults to "$cityName $ip") — used for
  /// states that have no specific city/IP to show, e.g. "Auto select".
  final String? subtitle;

  /// A small flag shown right after the subtitle text — used by "Auto
  /// select" once connected, to hint at the actual resolved exit country
  /// without replacing the generic globe icon/title on the left.
  final String? subtitleFlagCountryCode;
  final String? subtitleFlagUrl;

  /// Shows a small spinner after the subtitle instead of the flag — "Auto
  /// select" while the post-connect health check is still choosing a server.
  final bool isSubtitleLoading;

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors();
    final AppTextStyles appTextStyles = AppTextStyles();
    final displayCountry = StringUtils.capitalizeFirst(countryName);
    final displayCity = StringUtils.capitalizeFirst(cityName);

    return Material(
      color: appColors.white,
      borderRadius: BorderRadius.circular(18),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: appColors.white,
            border: Border.all(color: appColors.grayUltraLight),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 200,
                blurStyle: BlurStyle.normal,
                offset: const Offset(0, 170),
                spreadRadius: -100,
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: appColors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.10),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: RoundedFlag(
                  countryCode: countryCode,
                  flagUrl: flagUrl,
                  size: 36,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayCity.isEmpty
                          ? displayCountry
                          : '$displayCountry, $displayCity',
                      overflow: TextOverflow.ellipsis,
                      style: appTextStyles.interSemiBold16(
                        color: appColors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            subtitle ?? '$displayCity $ip',
                            overflow: TextOverflow.ellipsis,
                            style: appTextStyles.interRegular12(
                              color: appColors.grayLight,
                            ),
                          ),
                        ),
                        if (isSubtitleLoading) ...[
                          const SizedBox(width: 6),
                          BlackCircularProgressIndicator(
                            size: 12,
                            strokeWidth: 2,
                          ),
                        ] else if (subtitleFlagCountryCode != null &&
                            subtitleFlagUrl != null) ...[
                          const SizedBox(width: 6),
                          RoundedFlag(
                            countryCode: subtitleFlagCountryCode!,
                            flagUrl: subtitleFlagUrl!,
                            size: 14,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: appColors.grayBackground,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: appColors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
