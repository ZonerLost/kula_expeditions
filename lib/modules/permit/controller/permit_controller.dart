// lib/modules/permit/controller/permit_controller.dart

import 'package:get/get.dart';
import '../../../constants/app_imges.dart';
import '../../../constants/app_strings.dart';
import '../../../routes/app_routes.dart';
import '../model/permit_model.dart';

class PermitController extends GetxController {

  final permit = PermitModel(
    title: AppStrings.permitMainTitle,
    description: AppStrings.permitDescription,
    buttonText: AppStrings.applyPermit,
    footerText: AppStrings.permitFooter,
    image: AppImages.permit_image,
  );

  @override
  void onInit() {
    super.onInit();
  }

  void onApplyPermitTap() {
    Get.toNamed(AppRoutes.permitPersonalInfo);

  }
}