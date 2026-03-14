import 'package:get/get.dart';
import '../controller/hiking_details_controller.dart';

class HikingDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HikingDetailsController>(() => HikingDetailsController());
  }
}