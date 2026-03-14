import 'package:get/get.dart';
import '../controller/unlock_controller.dart';

class UnlockBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UnlockController>(() => UnlockController());
  }
}