import 'package:get/get.dart';
import '../controller/permit_list_controller.dart';

class PermitListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PermitListController>(() => PermitListController());
  }
}