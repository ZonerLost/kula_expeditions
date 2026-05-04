import 'package:get/get.dart';
import '../controller/map_screen_controller.dart';

class MapScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MapScreenController>(() => MapScreenController());
  }
}