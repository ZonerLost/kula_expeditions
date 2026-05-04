import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../extension/context_extension.dart';
import '../app_colors.dart';
import '../app_text_styles.dart';
import 'bottom_nav_controller.dart';
import 'map_nav_item_model.dart';

class CustomBottomNavBar extends StatelessWidget {
  final List<MapNavItemModel> items;

  const CustomBottomNavBar({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final navController = Get.find<BottomNavController>();

    return Obx(
      () => Container(
        height: context.screenHeight * 0.09,
        padding: EdgeInsets.symmetric(horizontal: context.screenWidth * 0.04),
        decoration: const BoxDecoration(
          color: AppColors.white,
          border: Border(top: BorderSide(color: AppColors.lightBorder)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (index) {
            final item = items[index];
            final isSelected = navController.selectedIndex.value == index;

            return GestureDetector(
              onTap: () => navController.onItemTapped(index),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  item.iconData != null
                      ? Icon(
                          item.iconData,
                          size: 23,
                          color: isSelected
                              ? AppColors.navSelected
                              : AppColors.navUnselected,
                        )
                      : SvgPicture.asset(
                          item.icon,
                          height: 23,
                          width: 23,
                          colorFilter: ColorFilter.mode(
                            isSelected
                                ? AppColors.navSelected
                                : AppColors.navUnselected,
                            BlendMode.srcIn,
                          ),
                        ),
                  const SizedBox(height: 4),
                  Text(
                    item.label,
                    style: AppTextStyles.small.copyWith(
                      fontSize: context.screenWidth * 0.03,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: isSelected
                          ? AppColors.navSelected
                          : AppColors.navUnselected,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
