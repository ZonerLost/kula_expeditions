import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/app_strings.dart';
import '../../contact_documents/binding/contact_documents_binding.dart';
import '../../contact_documents/view/contact_documents_view.dart';
import '../model/hiking_crossing_model.dart';

class HikingDetailsController extends GetxController {
  final startDateController = TextEditingController(text: "12-02-2026");
  final endDateController = TextEditingController(text: "12-02-2026");
  final crossingDateController = TextEditingController(text: "18-02-2026");
  final fromController = TextEditingController(text: "Albania");
  final toController = TextEditingController(text: "Montenegro");
  final borderPointController = TextEditingController(text: "Valbona Pass");

  final RxList<HikingCrossingModel> crossings = <HikingCrossingModel>[
    HikingCrossingModel(
      fromCountry: "Albania",
      toCountry: "Montenegro",
      crossingDate: "18 Feb, 2026",
      borderLocation: "Valbona Pass",
    ),
  ].obs;

  void onAddCrossingTap() {
    crossings.add(
      HikingCrossingModel(
        fromCountry: fromController.text.trim().isEmpty
            ? "Albania"
            : fromController.text.trim(),
        toCountry: toController.text.trim().isEmpty
            ? "Montenegro"
            : toController.text.trim(),
        crossingDate: crossingDateController.text.trim().isEmpty
            ? "18 Feb, 2026"
            : crossingDateController.text.trim(),
        borderLocation: borderPointController.text.trim().isEmpty
            ? "Valbona Pass"
            : borderPointController.text.trim(),
      ),
    );
  }

  void onContinueTap() {
    Get.to(
          () => const ContactDocumentsView(),
      binding: ContactDocumentsBinding(),
    );
  }

  Future<void> pickDate(
      BuildContext context,
      TextEditingController controller,
      ) async {
    final DateTime initialDate = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2035),
    );

    if (picked != null) {
      controller.text =
      "${picked.day.toString().padLeft(2, '0')}-"
          "${picked.month.toString().padLeft(2, '0')}-"
          "${picked.year}";
    }
  }

  @override
  void onClose() {
    startDateController.dispose();
    endDateController.dispose();
    crossingDateController.dispose();
    fromController.dispose();
    toController.dispose();
    borderPointController.dispose();
    super.onClose();
  }
}