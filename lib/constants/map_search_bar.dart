import 'package:flutter/material.dart';
import 'package:kuala_exp/extension/context_extension.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/app_text_styles.dart';

class MapSearchBar extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final String? hintText;
  final List<String> suggestions;
  final ValueChanged<String>? onSuggestionTap;

  const MapSearchBar({
    super.key,
    this.onChanged,
    this.controller,
    this.hintText,
    this.suggestions = const [],
    this.onSuggestionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: context.screenHeight * 0.052,
          padding: EdgeInsets.symmetric(horizontal: context.screenWidth * 0.04),
          decoration: BoxDecoration(
            color: AppColors.mapSearchBg,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: AppColors.lightBorder, width: 1),
            boxShadow: const [
              BoxShadow(
                color: Color(0x12000000),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.search, size: 18, color: Color(0xFF9B9B9B)),
              SizedBox(width: context.screenWidth * 0.025),
              Expanded(
                child: TextField(
                  controller: controller,
                  onChanged: onChanged,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: hintText ?? AppStrings.mapSearchHint,
                    hintStyle: AppTextStyles.small.copyWith(
                      fontSize: context.screenWidth * 0.03,
                      color: const Color(0xFF9B9B9B),
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                    isCollapsed: true,
                  ),
                  style: AppTextStyles.small.copyWith(
                    fontSize: context.screenWidth * 0.03,
                    color: AppColors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (suggestions.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 6),
            constraints: BoxConstraints(maxHeight: context.screenHeight * 0.25),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.lightBorder),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 6),
              shrinkWrap: true,
              itemCount: suggestions.length,
              separatorBuilder: (_, __) => Divider(
                height: 1,
                color: AppColors.lightBorder,
                indent: context.screenWidth * 0.04,
                endIndent: context.screenWidth * 0.04,
              ),
              itemBuilder: (context, i) => InkWell(
                onTap: () => onSuggestionTap?.call(suggestions[i]),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.screenWidth * 0.04,
                    vertical: context.screenHeight * 0.012,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 16, color: Color(0xFF9B9B9B)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          suggestions[i],
                          style: AppTextStyles.small.copyWith(
                            fontSize: context.screenWidth * 0.032,
                            color: AppColors.black,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
