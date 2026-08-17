import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenshield/core/utils/platform_utils.dart';
import 'package:zenshield/gen/assets.gen.dart';
import 'package:zenshield/l10n/app_localizations.dart';
import 'package:zenshield/feature/app_update/presentation/app_update_bloc.dart';
import 'package:zenshield/feature/app_update/presentation/app_update_view.dart';
import 'package:zenshield/config/theme/app_colors/app_colors.dart';
import 'package:zenshield/config/theme/app_text_styles/app_text_styles.dart';

const double _desktopDialogWidth = 420;

class UpdateRequiredPopupNew extends StatefulWidget {
  const UpdateRequiredPopupNew({
    required this.isDismissible,
    this.version,
    super.key,
  });

  final bool isDismissible;
  final String? version;

  @override
  State<UpdateRequiredPopupNew> createState() => _UpdateRequiredPopupNewState();

  static Future show(
    BuildContext context, {
    required bool isDismissible,
    String? version,
  }) {
    final appColors = AppColors();
    final appUpdateBloc = context.read<AppUpdateBloc>();

    return showDialog(
      context: context,
      barrierDismissible: isDismissible,
      barrierColor: appColors.black.withValues(alpha: 0.6),
      builder: (context) => BlocProvider.value(
        value: appUpdateBloc,
        child: PopScope(
          canPop: isDismissible,
          child: UpdateRequiredPopupNew(
            isDismissible: isDismissible,
            version: version,
          ),
        ),
      ),
    );
  }
}

class _UpdateRequiredPopupNewState extends State<UpdateRequiredPopupNew> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: _PopupContent(
        isDismissible: widget.isDismissible,
        version: widget.version,
      ),
    );
  }
}

class _PopupContent extends StatelessWidget {
  const _PopupContent({
    required this.isDismissible,
    this.version,
  });

  final bool isDismissible;
  final String? version;

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors();
    final screenWidth = MediaQuery.of(context).size.width;
    final dialogWidth = PlatformUtils.isDesktop
        ? _desktopDialogWidth
        : screenWidth * 0.9;

    return Container(
      width: dialogWidth,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      decoration: BoxDecoration(
        color: appColors.white,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 24),
            Assets.images.appLogo.image(width: 56, height: 56),
            const SizedBox(height: 16),
            const _PopupMessage(),
            const SizedBox(height: 32),
            _DownloadButton(),
            if (isDismissible) ...[
              const SizedBox(height: 24),
              _RemindLaterButton(),
            ] else ...[
              const SizedBox(height: 24),
              _RestartTimer(),
            ],
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _PopupMessage extends StatelessWidget {
  const _PopupMessage();

  @override
  Widget build(BuildContext context) {
    final appTextStyles = AppTextStyles();
    final appColors = AppColors();
    final l10n = AppLocalizations.of(context);

    final message =
        l10n?.updateAvailablePopupMessage ?? 'A new version is available';

    return SizedBox(
      width: double.infinity,
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: appTextStyles
            .interRegular16(
              color: appColors.black,
            )
            .copyWith(fontWeight: FontWeight.w500),
      ),
    );
  }
}

class _DownloadButton extends StatelessWidget {
  const _DownloadButton();

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors();
    final appTextStyles = AppTextStyles();
    final l10n = AppLocalizations.of(context);

    return SizedBox(
      width: double.infinity,
      height: 57,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacementNamed(
            AppUpdateView.routeName,
            arguments: const StartUpdateEvent(),
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
          l10n?.updateAvailablePopupButtonUpdate ?? 'Update now',
          style: appTextStyles
              .nunitoSansBold18(
                color: appColors.white,
              )
              .copyWith(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _RemindLaterButton extends StatelessWidget {
  const _RemindLaterButton();

  @override
  Widget build(BuildContext context) {
    final appTextStyles = AppTextStyles();
    final appColors = AppColors();
    final l10n = AppLocalizations.of(context);

    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
          context.read<AppUpdateBloc>().add(const SkipUpdateEvent());
        },
        child: Text(
          l10n?.updateAvailablePopupButtonRemindLater ?? 'Remind me later',
          textAlign: TextAlign.center,
          style: appTextStyles
              .interRegular14(
                color: appColors.black,
              )
              .copyWith(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

class _RestartTimer extends StatefulWidget {
  const _RestartTimer();

  @override
  State<_RestartTimer> createState() => _RestartTimerState();
}

class _RestartTimerState extends State<_RestartTimer> {
  Timer? _timer;
  int _remainingSeconds = 20;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer?.cancel();
        _onTimerComplete();
      }
    });
  }

  void _onTimerComplete() {
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacementNamed(
      AppUpdateView.routeName,
      arguments: const StartUpdateEvent(),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '$minutes:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appTextStyles = AppTextStyles();
    final l10n = AppLocalizations.of(context);

    final timeString = _formatTime(_remainingSeconds);
    final timerText = l10n?.updateAvailablePopupTimer(timeString) ??
        'Restarting in $timeString';

    return SizedBox(
      width: double.infinity,
      child: Text(
        timerText,
        textAlign: TextAlign.center,
        style: appTextStyles.interRegular14(
          color: const Color(0xFF98A2B3),
        ),
      ),
    );
  }
}
