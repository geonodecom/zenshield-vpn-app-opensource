import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:zenshield/gen/assets.gen.dart';
import 'package:zenshield/config/theme/app_colors/app_colors.dart';

class RoundedFlag extends StatelessWidget {
  const RoundedFlag({
    required this.countryCode,
    required this.flagUrl,
    required this.size,
    super.key,
  });

  final String countryCode;
  final String flagUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors();

    final shouldShowFallback = countryCode.trim().isEmpty ||
        countryCode.toLowerCase() == 'unknown' ||
        flagUrl.trim().isEmpty;

    final fallbackWidget = Assets.images.planetColor.image(
      width: size,
      height: size,
    );

    final placeholder = ClipOval(
      child: Container(
        color: appColors.grayBackground,
        width: size,
        height: size,
      ),
    );

    return ClipOval(
      child: shouldShowFallback
          ? fallbackWidget
          : CachedNetworkImage(
              imageUrl: flagUrl,
              fit: BoxFit.fitHeight,
              width: size,
              height: size,
              placeholder: (_, __) => placeholder,
              errorWidget: (_, __, ___) => placeholder,
              maxWidthDiskCache: 64,
              maxHeightDiskCache: 64,
              memCacheWidth: 64,
              memCacheHeight: 64,
            ),
    );
  }
}
