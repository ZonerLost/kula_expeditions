// lib/modules/permit/controller/permit_controller.dart

import 'package:get/get.dart';
import '../../../constants/app_imges.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/bottom_nav_bar/bottom_nav_controller.dart';
import '../../../constants/bottom_nav_bar/map_nav_item_model.dart';
import '../../../routes/app_routes.dart';
import '../model/permit_model.dart';

class PermitController extends GetxController {
  final bottomNavController = Get.find<BottomNavController>();

  final navItems = <MapNavItemModel>[
    MapNavItemModel(
      label: AppStrings.navMap,
      icon: AppImages.pinPoint,
    ),
    MapNavItemModel(
      label: AppStrings.navStages,
      icon: AppImages.layers,
    ),
    MapNavItemModel(
      label: AppStrings.navPermit,
      icon: AppImages.permit,
    ),
    MapNavItemModel(
      label: AppStrings.navUnlock,
      icon: AppImages.lock,
    ),
  ];

  final permit = PermitModel(
    title: AppStrings.permitMainTitle,
    description: AppStrings.permitDescription,
    buttonText: AppStrings.applyPermit,
    footerText: AppStrings.permitFooter,
    image: AppImages.permit_image,
  );

  @override
  void onInit() {
    super.onInit();
    bottomNavController.updateIndexFromRoute(AppRoutes.permit);
  }

  void onApplyPermitTap() {
    Get.toNamed(AppRoutes.permitPersonalInfo);

  }
}