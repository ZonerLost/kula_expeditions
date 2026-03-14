import 'package:get/get.dart';

import '../controller/permit_personal_info_controller.dart';

class PermitPersonalInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PermitPersonalInfoController());
  }
}