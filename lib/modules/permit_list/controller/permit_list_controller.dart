import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../model/permit_list_model.dart';

class PermitListController extends GetxController {
  final permits = <PermitListModel>[
    PermitListModel(
      imagePath: 'assets/images/permit_thumb.png',
      permitId: 'BLK-8F23-9XJ2',
      validity: 'Aug 12 – Aug 18',
    ),
    PermitListModel(
      imagePath: 'assets/images/permit_thumb.png',
      permitId: 'BLK-9F34-0YH3',
      validity: 'Aug 19 – Aug 25',
    ),
    PermitListModel(
      imagePath: 'assets/images/permit_thumb.png',
      permitId: 'BLK-7G45-1ZK4',
      validity: 'Aug 26 – Sep 01',
    ),
    PermitListModel(
      imagePath: 'assets/images/permit_thumb.png',
      permitId: 'BLK-E23-9XJ2',
      validity: 'Aug 12 – Aug 18',
    ),
  ].obs;

  void onOpenMapTap(PermitListModel permit) {
    Get.toNamed(AppRoutes.mapScreen);
  }

  void onDownloadQrTap(PermitListModel permit) {
    Get.toNamed(AppRoutes.permitApproved, arguments: permit);
  }
}