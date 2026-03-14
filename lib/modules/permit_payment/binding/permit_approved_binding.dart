import 'package:get/get.dart';
import '../controller/permit_approved_controller.dart';

class PermitApprovedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PermitApprovedController>(() => PermitApprovedController());
  }
}