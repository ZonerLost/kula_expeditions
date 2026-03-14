import 'package:flutter/material.dart';
import 'package:kuala_exp/extension/context_extension.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/app_text_styles.dart';

class MapSearchBar extends StatelessWidget {
  final VoidCallback? onTap;
  final String? hintText;

  const MapSearchBar({
    super.key,
    this.onTap,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          height: context.screenHeight * 0.052,
          padding: EdgeInsets.symmetric(
            horizontal: context.screenWidth * 0.04,
          ),
          decoration: BoxDecoration(
            color: AppColors.mapSearchBg,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: AppColors.lightBorder,
              width: 1,
            ),
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
              const Icon(
                Icons.search,
                size: 18,
                color: Color(0xFF9B9B9B),
              ),
              SizedBox(width: context.screenWidth * 0.025),
              Expanded(
                child: Text(
                  hintText ?? AppStrings.mapSearchHint,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.small.copyWith(
                    fontSize: context.screenWidth * 0.03,
                    color: const Color(0xFF9B9B9B),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}