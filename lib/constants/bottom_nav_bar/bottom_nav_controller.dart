import 'package:get/get.dart';
import '../../routes/app_routes.dart';

class BottomNavController extends GetxController {
  final selectedIndex = 0.obs;

  void updateIndexFromRoute(String route) {
    switch (route) {
      case AppRoutes.mapScreen:
        selectedIndex.value = 0;
        break;
      case AppRoutes.stages:
      case AppRoutes.stageDetail:
        selectedIndex.value = 1;
        break;
      case AppRoutes.permit:
      case AppRoutes.permitPersonalInfo:
      case AppRoutes.hikingDetails:
      case AppRoutes.contactDocuments:
      case AppRoutes.confirmPay:
      case AppRoutes.permitApproved:
        selectedIndex.value = 2;
        break;
      case AppRoutes.unlockCode:
      case AppRoutes.unlockActivated:
      case AppRoutes.unlockBenefits:
        selectedIndex.value = 3;
        break;
      default:
        selectedIndex.value = 0;
    }
  }

  void onItemTapped(int index) {
    if (selectedIndex.value == index) return;

    selectedIndex.value = index;

    switch (index) {
      case 0:
        Get.offNamed(AppRoutes.mapScreen);
        break;
      case 1:
        Get.offNamed(AppRoutes.stages);
        break;
      case 2:
        Get.offNamed(AppRoutes.permit);
        break;
      case 3:
        Get.offNamed(AppRoutes.unlockCode);
        break;
    }
  }
}