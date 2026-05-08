// lib/modules/stage_detail/binding/stage_detail_binding.dart

import 'package:get/get.dart';
import '../../../stage_detail/controller/stage_detail_controller.dart';

class StageDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StageDetailController>(() => StageDetailController());
  }
}
