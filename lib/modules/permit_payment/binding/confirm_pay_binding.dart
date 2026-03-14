import 'package:get/get.dart';
import '../controller/confirm_pay_controller.dart';

class ConfirmPayBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConfirmPayController>(() => ConfirmPayController());
  }
}