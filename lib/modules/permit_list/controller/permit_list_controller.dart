import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../routes/app_routes.dart';
import '../../permit/controller/permit_controller.dart';
import '../model/permit_list_model.dart';

class PermitListController extends GetxController {
  final PermitController _permitController =
      Get.isRegistered<PermitController>()
      ? Get.find<PermitController>()
      : Get.put(PermitController());

  final permits = <PermitListModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _syncPermits();
    ever(_permitController.permits, (_) => _syncPermits());
    ever(_permitController.savedPermitIds, (_) => _syncPermits());
    _permitController.refreshPermits();
  }

  void onOpenMapTap(PermitListModel permit) {
    Get.toNamed(AppRoutes.mapScreen);
  }

  void onCreateNewPermitTap() {
    _permitController.startNewPermitFlow();
  }

  void onDownloadQrTap(PermitListModel permit) {
    final selected = _permitController.findPermitById(permit.permitId);
    if (selected == null) {
      Get.snackbar('Info', 'Permit not found.');
      return;
    }

    _permitController.selectedPermit.value = selected;
    if (selected.status.toLowerCase() != 'approved') {
      Get.snackbar(
        'Info',
        'Permit status is ${selected.status}. QR is available only for approved permits.',
      );
      return;
    }

    _permitController.openPermitStatusScreen(permit: selected);
  }

  void _syncPermits() {
    if (_permitController.permits.isEmpty &&
        _permitController.savedPermitIds.isNotEmpty) {
      permits.assignAll(
        _permitController.savedPermitIds.map(
          (permitId) => PermitListModel(
            imagePath: 'assets/images/permit1.png',
            permitId: permitId,
            validity: '--',
          ),
        ),
      );
      return;
    }

    permits.assignAll(
      _permitController.permits.map(
        (permit) => PermitListModel(
          imagePath: 'assets/images/permit1.png',
          permitId: permit.permitId,
          validity: _formatValidity(permit.startDate, permit.endDate),
        ),
      ),
    );
  }

  String _formatValidity(String startDate, String endDate) {
    final start = _parseDate(startDate);
    final end = _parseDate(endDate);
    if (start == null || end == null) {
      return '$startDate - $endDate';
    }
    return '${DateFormat('MMM dd').format(start)} – ${DateFormat('MMM dd').format(end)}';
  }

  DateTime? _parseDate(String value) {
    try {
      return DateFormat('yyyy-MM-dd').parseStrict(value);
    } catch (_) {
      try {
        return DateFormat('dd-MM-yyyy').parseStrict(value);
      } catch (_) {
        return null;
      }
    }
  }
}
