// lib/modules/permit/binding/permit_binding.dart

import 'package:get/get.dart';
import '../controller/permit_controller.dart';

class PermitBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<PermitController>()) {
      Get.put<PermitController>(PermitController(), permanent: true);
    }
  }
}
