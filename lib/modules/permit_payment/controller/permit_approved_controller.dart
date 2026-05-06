import 'dart:io';

import 'package:get/get.dart';

import '../../../constants/bottom_nav_bar/bottom_nav_controller.dart';
import '../../../routes/app_routes.dart';
import '../../permit/controller/permit_controller.dart';
import '../model/permit_payment_model.dart';

class PermitApprovedController extends GetxController {
  final PermitController _permitController =
      Get.isRegistered<PermitController>()
      ? Get.find<PermitController>()
      : Get.put(PermitController());

  final selectedPermitId = ''.obs;
  final qrFilePath = RxnString();

  PermitPaymentModel get permitData {
    final permit = _permitController.selectedPermit.value;
    if (permit == null) {
      return PermitPaymentModel(
        name: '',
        passportNumber: '',
        dates: '',
        entry: '',
        exit: '',
        permitFee: 'EUR 0',
        processingFee: 'EUR 0',
        gstTax: 'EUR 0',
        total: 'EUR 0',
        permitId: selectedPermitId.value.isEmpty
            ? 'N/A'
            : selectedPermitId.value,
        validity: '',
        deliveryAddress: '',
        isPaid: false,
      );
    }

    return PermitPaymentModel(
      name: permit.fullName,
      passportNumber: permit.passportNumber,
      dates: '${permit.startDate} - ${permit.endDate}',
      entry: permit.fromCountry,
      exit: permit.toCountry,
      permitFee: 'EUR ${permit.amountPaid}',
      processingFee: 'EUR 0',
      gstTax: 'EUR 0',
      total: 'EUR ${permit.amountPaid}',
      permitId: permit.permitId,
      validity: '${permit.startDate} - ${permit.endDate}',
      deliveryAddress: permit.borderPoint,
      isPaid: permit.paymentStatus.toLowerCase() == 'paid',
    );
  }

  String get qrPayload {
    final permit = _permitController.selectedPermit.value;
    if (permit == null) {
      return '';
    }
    return _permitController.generateQrPayload(permit);
  }

  String get qrPreviewUrl {
    final payload = qrPayload;
    if (payload.isEmpty) {
      return 'https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=NO_PERMIT';
    }
    return 'https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=${Uri.encodeComponent(payload)}';
  }

  bool get hasOfflineQr =>
      qrFilePath.value != null &&
      qrFilePath.value!.isNotEmpty &&
      File(qrFilePath.value!).existsSync();

  String get statusTitle =>
      permitData.isPaid ? 'Permit Approved' : 'Payment Pending';

  String get statusChipText => permitData.isPaid ? 'Paid' : 'Payment Pending';

  @override
  void onInit() {
    super.onInit();
    _resolveSelectedPermitFromArguments();
    _loadQrPath();
  }

  Future<void> onDownloadQrTap() async {
    final permit = _permitController.selectedPermit.value;
    if (permit == null) {
      Get.snackbar('Info', 'No permit selected.');
      return;
    }
    if (permit.status.toLowerCase() != 'approved') {
      Get.snackbar(
        'Info',
        'QR is available only when permit status is approved.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final path = await _permitController.saveQrForOffline(permit);
    if (path != null) {
      qrFilePath.value = path;
      Get.snackbar(
        'Success',
        'QR saved for offline access.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void onBackTap() {
    _openPermitListInShell();
  }

  void onBackToPermitTap() {
    _openPermitListInShell();
  }

  void _resolveSelectedPermitFromArguments() {
    final arg = Get.arguments;
    String permitId = '';

    if (arg is String) {
      permitId = arg;
    } else if (arg is Map<String, dynamic> && arg['permitId'] is String) {
      permitId = arg['permitId'] as String;
    } else {
      permitId = _permitController.selectedPermit.value?.permitId ?? '';
    }

    selectedPermitId.value = permitId;
    if (permitId.isEmpty) {
      return;
    }

    final selected = _permitController.findPermitById(permitId);
    if (selected != null) {
      _permitController.selectedPermit.value = selected;
      qrFilePath.value = selected.qrLocalPath;
    }
  }

  Future<void> _loadQrPath() async {
    final permit = _permitController.selectedPermit.value;
    if (permit == null) {
      return;
    }
    qrFilePath.value = permit.qrLocalPath;
  }

  void _openPermitListInShell() {
    _permitController.openPermitListTab();
    if (Get.isRegistered<BottomNavController>()) {
      Get.find<BottomNavController>().selectedIndex.value = 2;
    }
    if (Get.currentRoute != AppRoutes.shell) {
      Get.offAllNamed(AppRoutes.shell);
    }
  }
}
