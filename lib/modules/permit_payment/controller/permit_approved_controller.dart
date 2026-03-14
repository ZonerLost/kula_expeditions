import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../model/permit_payment_model.dart';

class PermitApprovedController extends GetxController {
  final permitData = PermitPaymentModel(
    name: "Jamal Koliver",
    passportNumber: "32422-44343423-3",
    dates: "Aug 12 – Aug 18",
    entry: "Albania",
    exit: "Montenegro",
    permitFee: "€30",
    processingFee: "€31",
    gstTax: "€3 (10%)",
    total: "€27.00",
    permitId: "BLK-8F23-9XJ2",
    validity: "Aug 12 – Aug 18",
    deliveryAddress: "Sky Avenue, Street 5, House 14, NYC",
    isPaid: true,
  );

  void onDownloadQrTap() {
    Get.offAllNamed(AppRoutes.permit);
  }
}