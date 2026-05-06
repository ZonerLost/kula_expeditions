import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../permit/controller/permit_controller.dart';

class ContactDocumentsController extends GetxController {
  final PermitController _permitController =
      Get.isRegistered<PermitController>()
      ? Get.find<PermitController>()
      : Get.put(PermitController());

  TextEditingController get emailController =>
      _permitController.emailController;
  TextEditingController get emergencyContactController =>
      _permitController.emergencyContactController;

  RxBool get needsVisa => _permitController.needsVisa;
  RxString get passportFileName => _permitController.passportFileName;
  RxString get visaFileName => _permitController.visaFileName;

  void selectVisaOption(bool value) {
    needsVisa.value = value;
  }

  void uploadPassport() {
    // TODO: Implement passport image upload later.
    // For now, backend receives passportUrl as empty string.
    Get.snackbar('Info', 'Passport upload will be implemented later.');
  }

  void uploadVisaDocument() {
    // TODO: Implement visa document upload later.
    // For now, backend receives visaUrl as empty string.
    Get.snackbar('Info', 'Visa upload will be implemented later.');
  }

  void onContinueTap() {
    if (!_permitController.validateContactDocuments()) {
      return;
    }
    Get.toNamed(AppRoutes.confirmPay);
  }
}
