import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:zenshield/config/theme/app_colors/app_colors.dart';
import 'package:zenshield/config/theme/app_text_styles/app_text_styles.dart';

class BandwidthPolicyMarkdown extends StatefulWidget {
  const BandwidthPolicyMarkdown({super.key, this.content});

  final String? content;

  @override
  State<BandwidthPolicyMarkdown> createState() =>
      _BandwidthPolicyMarkdownState();
}

class _BandwidthPolicyMarkdownState extends State<BandwidthPolicyMarkdown> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors();
    final appTextStyles = AppTextStyles();
    final content = widget.content != null && widget.content!.isNotEmpty
        ? widget.content!
        : '';

    final baseStyle = appTextStyles
        .interRegular14(color: appColors.black)
        .copyWith(height: 1.4);

    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: MarkdownBody(
          data: content,
          selectable: true,
          styleSheet: MarkdownStyleSheet(
            p: baseStyle,
            listBullet: baseStyle,
            h1: appTextStyles
                .interRegular14(color: appColors.black)
                .copyWith(
                  height: 1.4,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
            h2: appTextStyles
                .interRegular14(color: appColors.black)
                .copyWith(
                  height: 1.4,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
            h3: appTextStyles
                .interRegular14(color: appColors.black)
                .copyWith(
                  height: 1.4,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
            blockquote: baseStyle.copyWith(color: appColors.grayLight),
            code: baseStyle.copyWith(
              fontFamily: 'monospace',
              backgroundColor: appColors.grayLight.withValues(alpha: 0.3),
            ),
          ),
        ),
      ),
    );
  }
}
