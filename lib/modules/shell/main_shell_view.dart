import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/app_imges.dart';
import '../../constants/app_strings.dart';
import '../../constants/bottom_nav_bar/bottom_nav_controller.dart';
import '../../constants/bottom_nav_bar/custom_bottom_nav_bar.dart';
import '../../constants/bottom_nav_bar/map_nav_item_model.dart';
import '../../modules/map/binding/map_screen_binding.dart';
import '../../modules/map/view/map_screen_view.dart';
import '../../modules/permit/binding/permit_binding.dart';
import '../../modules/permit/view/permit_view.dart';
import '../../modules/stages/binding/stages_binding.dart';
import '../../modules/stages/view/stages_view.dart';
import '../../modules/unlock_access/binding/unlock_binding.dart';
import '../../modules/unlock_access/view/unlock_code_view.dart';

class MainShellView extends StatefulWidget {
  const MainShellView({super.key});

  @override
  State<MainShellView> createState() => _MainShellViewState();
}

class _MainShellViewState extends State<MainShellView> {
  @override
  void initState() {
    super.initState();
    MapScreenBinding().dependencies();
    StagesBinding().dependencies();
    PermitBinding().dependencies();
    UnlockBinding().dependencies();
  }

  final _navItems = <MapNavItemModel>[
    MapNavItemModel(
      label: AppStrings.navMap,
      icon: AppImages.pinPoint,
      iconData: Icons.map_outlined,
    ),
    MapNavItemModel(label: AppStrings.navStages, icon: AppImages.layers),
    MapNavItemModel(label: AppStrings.navPermit, icon: AppImages.permit),
    MapNavItemModel(label: AppStrings.navUnlock, icon: AppImages.lock),
  ];

  final _screens = const [
    MapScreenView(),
    StagesView(),
    PermitView(),
    UnlockCodeView(),
  ];

  @override
  Widget build(BuildContext context) {
    final navController = Get.find<BottomNavController>();

    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: navController.selectedIndex.value,
          children: _screens,
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(items: _navItems),
    );
  }
}
