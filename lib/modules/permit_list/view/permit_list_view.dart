import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/app_text_styles.dart';
import '../../../constants/bottom_nav_bar/custom_bottom_nav_bar.dart';
import '../../../constants/bottom_nav_bar/map_nav_item_model.dart';
import '../../../constants/bottom_nav_bar/bottom_nav_controller.dart';
import '../../../widgets/permit_card_widget.dart';
import '../controller/permit_list_controller.dart';


class PermitListView extends GetView<PermitListController> {
  const PermitListView({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomNavController = Get.find<BottomNavController>();
    bottomNavController.updateIndexFromRoute(Get.currentRoute);

    final navItems = [
      MapNavItemModel(
        icon: 'assets/icons/map.svg',
        label: AppStrings.navMap,
      ),
      MapNavItemModel(
        icon: 'assets/icons/stages.svg',
        label: AppStrings.navStages,
      ),
      MapNavItemModel(
        icon: 'assets/icons/permit.svg',
        label: AppStrings.navPermit,
      ),
      MapNavItemModel(
        icon: 'assets/icons/unlock.svg',
        label: AppStrings.navUnlock,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      bottomNavigationBar: CustomBottomNavBar(items: navItems),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.permits,
                style: AppTextStyles.title.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: Obx(
                      () => ListView.separated(
                    itemCount: controller.permits.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final permit = controller.permits[index];
                      return PermitCardWidget(
                        permit: permit,
                        onOpenMapTap: () => controller.onOpenMapTap(permit),
                        onDownloadQrTap: () => controller.onDownloadQrTap(permit),
                      );
                    },
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