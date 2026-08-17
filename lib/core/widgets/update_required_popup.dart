import 'package:flutter/material.dart';
import 'package:zenshield/l10n/app_localizations.dart';
import 'package:zenshield/config/theme/app_colors/app_colors.dart';
import 'package:zenshield/config/theme/app_text_styles/app_text_styles.dart';

class UpdateRequiredPopup extends StatefulWidget {
  const UpdateRequiredPopup({
    required this.onDismissTap,
    required this.onUpdateTap,
    required this.isDismissible,
    super.key,
  });

  final VoidCallback onDismissTap;
  final VoidCallback onUpdateTap;
  final bool isDismissible;

  @override
  State<UpdateRequiredPopup> createState() => _UpdateRequiredPopupState();

  static Future show(
    BuildContext context, {
    required bool isDismissible,
    required VoidCallback onDismissTap,
    required VoidCallback onUpdateTap,
  }) {
    final appColors = AppColors();

    return showModalBottomSheet(
      context: context,
      isDismissible: isDismissible,
      enableDrag: isDismissible,
      backgroundColor: Colors.transparent,
      barrierColor: appColors.black.withValues(alpha: 0.6),
      builder: (context) => PopScope(
        canPop: isDismissible,
        child: UpdateRequiredPopup(
          onDismissTap: onDismissTap,
          onUpdateTap: onUpdateTap,
          isDismissible: isDismissible,
        ),
      ),
    );
  }
}

class _UpdateRequiredPopupState extends State<UpdateRequiredPopup> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: _PopupContent(
          onDismissTap: widget.onDismissTap,
          onUpdateTap: widget.onUpdateTap,
          isDismissible: widget.isDismissible,
        ),
      ),
    );
  }
}

class _PopupContent extends StatelessWidget {
  const _PopupContent({
    required this.onDismissTap,
    required this.onUpdateTap,
    required this.isDismissible,
  });

  final VoidCallback onDismissTap;
  final VoidCallback onUpdateTap;
  final bool isDismissible;

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors();

    return Container(
      constraints: BoxConstraints(
        maxWidth: 350,
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: appColors.white,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            const _PopupTitle(),
            const SizedBox(height: 8),
            const _PopupMessages(),
            const SizedBox(height: 42),
            _DownloadButton(onUpdateTap: onUpdateTap),
            if (isDismissible) ...[
              const SizedBox(height: 24),
              _RemindLaterButton(onDismissTap: onDismissTap),
            ],
            SizedBox(height: isDismissible ? 25 : 14),
          ],
        ),
      ),
    );
  }
}

class _PopupTitle extends StatelessWidget {
  const _PopupTitle();

  @override
  Widget build(BuildContext context) {
    final appTextStyles = AppTextStyles();
    final appColors = AppColors();
    final l10n = AppLocalizations.of(context);

    return SizedBox(
      width: double.infinity,
      child: Text(
        l10n?.updateRequiredPopupTitle ?? 'Update Required',
        textAlign: TextAlign.center,
        style: appTextStyles.helveticaNeueBold20(
          color: appColors.black,
        ),
      ),
    );
  }
}

class _PopupMessages extends StatelessWidget {
  const _PopupMessages();

  @override
  Widget build(BuildContext context) {
    final appTextStyles = AppTextStyles();
    final appColors = AppColors();
    final l10n = AppLocalizations.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: double.infinity,
          child: Text(
            l10n?.updateRequiredPopupMessage1 ??
                'Your current version of Zenshield VPN is out of date.',
            textAlign: TextAlign.center,
            style: appTextStyles
                .interRegular16(
                  color: appColors.black,
                )
                .copyWith(fontSize: 15),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: Text(
            l10n?.updateRequiredPopupMessage2 ??
                'Please install the latest version to continue using the app securely and without interruptions.',
            textAlign: TextAlign.center,
            style: appTextStyles
                .interRegular16(
                  color: appColors.black,
                )
                .copyWith(fontSize: 15),
          ),
        ),
      ],
    );
  }
}

class _DownloadButton extends StatelessWidget {
  const _DownloadButton({
    required this.onUpdateTap,
  });

  final VoidCallback onUpdateTap;

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors();
    final appTextStyles = AppTextStyles();
    final l10n = AppLocalizations.of(context);

    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onUpdateTap,
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
          l10n?.updateRequiredPopupButtonDownload ?? 'Download Update',
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
  const _RemindLaterButton({
    required this.onDismissTap,
  });

  final VoidCallback onDismissTap;

  @override
  Widget build(BuildContext context) {
    final appTextStyles = AppTextStyles();
    final appColors = AppColors();
    final l10n = AppLocalizations.of(context);

    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: onDismissTap,
        child: Text(
          l10n?.updateRequiredPopupButtonRemindLater ?? 'Remind Me Later',
          textAlign: TextAlign.center,
          style: appTextStyles
              .interRegular14(
                color: appColors.black,
              )
              .copyWith(fontSize: 13),
        ),
      ),
    );
  }
}
