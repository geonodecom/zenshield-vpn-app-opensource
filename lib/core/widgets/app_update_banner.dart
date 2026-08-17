import 'package:flutter/material.dart';
import 'package:zenshield/gen/assets.gen.dart';
import 'package:zenshield/l10n/app_localizations.dart';
import 'package:zenshield/config/theme/app_colors/app_colors.dart';
import 'package:zenshield/config/theme/app_text_styles/app_text_styles.dart';

class AppUpdatedBanner extends StatefulWidget {
  const AppUpdatedBanner({
    required this.version,
    required this.onClose,
    super.key,
  });

  final String version;
  final VoidCallback onClose;

  @override
  State<AppUpdatedBanner> createState() => _AppUpdatedBannerState();
}

class _AppUpdatedBannerState extends State<AppUpdatedBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onClose();
      }
    });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors();
    final appTextStyles = AppTextStyles();
    final l10n = AppLocalizations.of(context);

    final message = l10n?.homeAppWasUpdated(widget.version) ??
        'App was updated to version ${widget.version}';

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(top: 12),
        decoration: BoxDecoration(
          color: appColors.black,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 23.0),
                    child: Text(
                      message,
                      textAlign: TextAlign.left,
                      style: appTextStyles.nunitoSansMedium16(
                        color: appColors.white,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: widget.onClose,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 20),
                    child: Assets.images.appUpdatedCloseIcon.image(
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Container(
                  height: 6.67,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4BFFB3).withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: _animation.value,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF4BFFB3),
                            borderRadius: BorderRadius.circular(99),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
