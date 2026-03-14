import 'package:get/get.dart';
import '../../../constants/bottom_nav_bar/bottom_nav_controller.dart';
import '../controller/map_screen_controller.dart';

class MapScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BottomNavController>(() => BottomNavController());
    Get.lazyPut<MapScreenController>(() => MapScreenController());
  }
}