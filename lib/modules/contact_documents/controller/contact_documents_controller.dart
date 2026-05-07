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
    if (!value) {
      _permitController.clearVisaImage();
    }
  }

  Future<void> uploadPassport() async {
    try {
      await _permitController.pickPassportImage();
    } catch (error) {
      final message = error is StateError
          ? error.message.toString()
          : 'Unable to pick passport image.';
      Get.snackbar('Upload failed', message);
    }
  }

  Future<void> uploadVisaDocument() async {
    try {
      await _permitController.pickVisaImage();
    } catch (error) {
      final message = error is StateError
          ? error.message.toString()
          : 'Unable to pick visa image.';
      Get.snackbar('Upload failed', message);
    }
  }

  void onContinueTap() {
    if (!_permitController.validateContactDocuments()) {
      return;
    }
    Get.toNamed(AppRoutes.confirmPay);
  }
}
