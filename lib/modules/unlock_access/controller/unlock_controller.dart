import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../model/unlock_access_model.dart';

class UnlockController extends GetxController {
  final code1Controller = TextEditingController();
  final code2Controller = TextEditingController();
  final code3Controller = TextEditingController();
  final code4Controller = TextEditingController();

  final unlockData = UnlockAccessModel(
    code: "XXXX XXXX XXXX XXXX",
    couponCode: "KULA-15",
    exitCountry: "Montenegro",
    trailsUnlocked: true,
    poisAvailable: true,
    permitDiscount: "€10 discount",
  ).obs;

  String get fullCode =>
      "${code1Controller.text} ${code2Controller.text} ${code3Controller.text} ${code4Controller.text}";

  void onUnlockNowTap() {
    Get.toNamed(AppRoutes.unlockActivated);
  }

  void onGetEbookTap() {
    Get.snackbar(
      "Info",
      "E-book purchase flow coming soon",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void onApplyPermitTap() {
    Get.toNamed(AppRoutes.permit);
  }

  void onExploreMapTap() {
    Get.toNamed(AppRoutes.mapScreen);
  }

  void onSeeBenefitsTap() {
    Get.toNamed(AppRoutes.unlockBenefits);
  }

  @override
  void onClose() {
    code1Controller.dispose();
    code2Controller.dispose();
    code3Controller.dispose();
    code4Controller.dispose();
    super.onClose();
  }
}