import 'package:flutter/material.dart';
import 'package:zenshield/gen/assets.gen.dart';
import 'package:zenshield/config/theme/app_colors/app_colors.dart';
import 'package:zenshield/config/theme/app_text_styles/app_text_styles.dart';

class SearchableList extends StatelessWidget {
  const SearchableList({
    super.key,
    required this.searchController,
    required this.searchHintText,
    required this.onSearchChanged,
    required this.onClose,
    required this.itemBuilder,
    required this.itemCount,
    this.title,
  });

  final TextEditingController searchController;
  final String searchHintText;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClose;
  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors();
    final appTextStyles = AppTextStyles();

    return Container(
      decoration: BoxDecoration(
        color: appColors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: appColors.grayUltraLight,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 12, 4),
            child: Row(
              children: [
                Expanded(
                  child: title != null
                      ? Text(
                          title!,
                          style: appTextStyles
                              .interSemiBold16(color: appColors.black)
                              .copyWith(fontSize: 18),
                        )
                      : const SizedBox.shrink(),
                ),
                GestureDetector(
                  onTap: onClose,
                  child: Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: appColors.grayBackground,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      size: 18,
                      color: appColors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: appColors.grayBackground,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                children: [
                  Assets.images.search.image(width: 15.6, height: 16),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      style: appTextStyles.interRegular14(
                        color: appColors.black,
                      ),
                      decoration: InputDecoration(
                        hintText: searchHintText,
                        hintStyle: appTextStyles.interRegular14(
                          color: appColors.grayLight,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 6),
                      ),
                      onChanged: onSearchChanged,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 10);
              },
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
              itemCount: itemCount,
              itemBuilder: itemBuilder,
            ),
          ),
        ],
      ),
    );
  }
}
