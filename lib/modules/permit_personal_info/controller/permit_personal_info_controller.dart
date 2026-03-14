// permit_personal_info_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../hiking_crossing/controller/hiking_details_controller.dart';
import '../../hiking_crossing/view/hiking_details_view.dart';

class PermitPersonalInfoController extends GetxController {

  final fullNameController = TextEditingController();
  final passportController = TextEditingController();
  final dobController = TextEditingController();
  final placeController = TextEditingController();

  final nationality = 'French'.obs;

  final nationalities = [
    "French",
    "German",
    "Italian",
    "Spanish",
    "Kosovo",
    "Montenegro"
  ];

  Future<void> pickDate(BuildContext context) async {

    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2026),
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );

    if (picked != null) {

      dobController.text =
      "${picked.day}-${picked.month}-${picked.year}";
    }
  }

  void onContinueTap() {
    Get.put(HikingDetailsController());
    Get.to(() => const HikingDetailsView());
  }
  }
