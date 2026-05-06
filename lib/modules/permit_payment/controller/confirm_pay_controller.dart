import 'package:get/get.dart';

import '../../../constants/bottom_nav_bar/bottom_nav_controller.dart';
import '../../../routes/app_routes.dart';
import '../../permit/controller/permit_controller.dart';
import '../model/permit_payment_model.dart';

class ConfirmPayController extends GetxController {
  final PermitController _permitController =
      Get.isRegistered<PermitController>()
      ? Get.find<PermitController>()
      : Get.put(PermitController());

  PermitPaymentModel get permitData {
    final currentAmount =
        num.tryParse(_permitController.amountController.text.trim()) ?? 0;
    final amountText = 'EUR ${currentAmount.toStringAsFixed(0)}';
    return PermitPaymentModel(
      name: _permitController.fullNameController.text.trim(),
      passportNumber: _permitController.passportController.text.trim(),
      dates:
          '${_permitController.startDateController.text.trim()} - ${_permitController.endDateController.text.trim()}',
      entry: _permitController.fromController.text.trim(),
      exit: _permitController.toController.text.trim(),
      permitFee: amountText,
      processingFee: 'EUR 0',
      gstTax: 'EUR 0',
      total: amountText,
      permitId: _permitController.selectedPermit.value?.permitId ?? 'Pending',
      validity:
          '${_permitController.startDateController.text.trim()} - ${_permitController.endDateController.text.trim()}',
      deliveryAddress: _permitController.borderPointController.text.trim(),
      isPaid: false,
    );
  }

  Future<void> onPaySecurelyTap() async {
    final submitted = await _permitController.submitPermitRequest();
    if (submitted == null) {
      return;
    }

    _permitController.openPermitStatusScreen(permit: submitted);
    if (Get.isRegistered<BottomNavController>()) {
      Get.find<BottomNavController>().selectedIndex.value = 2;
    }
    Get.offAllNamed(AppRoutes.shell);
  }
}
