import 'package:get/get.dart';

import '../controller/stages_controller.dart';

class StagesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StagesController>(() => StagesController());
  }
}