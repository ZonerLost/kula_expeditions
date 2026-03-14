import 'package:flutter/material.dart';
import 'package:kuala_exp/extension/context_extension.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';

class MapFilterChips extends StatelessWidget {
  final List<String> chips;
  final int selectedIndex;
  final Function(int) onChipTap;

  const MapFilterChips({
    super.key,
    required this.chips,
    required this.selectedIndex,
    required this.onChipTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: context.screenHeight * 0.085,
      left: context.screenWidth * 0.06,
      right: context.screenWidth * 0.06,
      child: SizedBox(
        height: context.screenHeight * 0.04,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: chips.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final isSelected = selectedIndex == index;

            return GestureDetector(
              onTap: () => onChipTap(index),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.screenWidth * 0.035,
                  vertical: context.screenHeight * 0.008,
                ),
                decoration: BoxDecoration(
                  color: AppColors.chipBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.navSelected
                        : AppColors.chipBorder,
                  ),
                ),
                child: Center(
                  child: Text(
                    chips[index],
                    style: AppTextStyles.small.copyWith(
                      fontSize: context.screenWidth * 0.026,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}