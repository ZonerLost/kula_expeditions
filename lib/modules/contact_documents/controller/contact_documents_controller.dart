import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class ContactDocumentsController extends GetxController {
  final emailController =
  TextEditingController(text: "Diablo@gmail.com");
  final emergencyContactController =
  TextEditingController(text: "+9883232783823");

  final RxBool needsVisa = true.obs;

  final RxString passportFileName = "".obs;
  final RxString visaFileName = "".obs;

  void selectVisaOption(bool value) {
    needsVisa.value = value;
  }

  void uploadPassport() {
    passportFileName.value = "passport_photo.jpg";
  }

  void uploadVisaDocument() {
    visaFileName.value = "visa_document.pdf";
  }

  void onContinueTap() {
    Get.toNamed(AppRoutes.confirmPay);
  }

  @override
  void onClose() {
    emailController.dispose();
    emergencyContactController.dispose();
    super.onClose();
  }
}