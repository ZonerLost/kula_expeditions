// permit_personal_info_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../../permit/controller/permit_controller.dart';

class PermitPersonalInfoController extends GetxController {
  final PermitController _permitController =
      Get.isRegistered<PermitController>()
      ? Get.find<PermitController>()
      : Get.put(PermitController());

  TextEditingController get fullNameController =>
      _permitController.fullNameController;
  TextEditingController get passportController =>
      _permitController.passportController;
  TextEditingController get dobController => _permitController.dobController;
  TextEditingController get placeController =>
      _permitController.placeController;

  RxString get nationality => _permitController.nationality;
  List<String> get nationalities => _permitController.nationalities;

  Future<void> pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2026),
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      dobController.text = '${picked.day}-${picked.month}-${picked.year}';
    }
  }

  void onContinueTap() {
    if (!_permitController.validatePersonalInfo()) {
      return;
    }
    Get.toNamed(AppRoutes.hikingDetails);
  }
}
