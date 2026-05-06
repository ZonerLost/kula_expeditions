import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../permit/controller/permit_controller.dart';
import '../../contact_documents/binding/contact_documents_binding.dart';
import '../../contact_documents/view/contact_documents_view.dart';
import '../model/hiking_crossing_model.dart';

class HikingDetailsController extends GetxController {
  final PermitController _permitController =
      Get.isRegistered<PermitController>()
      ? Get.find<PermitController>()
      : Get.put(PermitController());

  TextEditingController get startDateController =>
      _permitController.startDateController;
  TextEditingController get endDateController =>
      _permitController.endDateController;
  TextEditingController get crossingDateController =>
      _permitController.crossingDateController;
  TextEditingController get fromController => _permitController.fromController;
  TextEditingController get toController => _permitController.toController;
  TextEditingController get borderPointController =>
      _permitController.borderPointController;

  final RxList<HikingCrossingModel> crossings = <HikingCrossingModel>[
    HikingCrossingModel(
      fromCountry: 'Albania',
      toCountry: 'Montenegro',
      datesRange: '12 Feb - 18 Feb, 2026',
      crossingDate: '18 Feb, 2026',
      borderLocation: 'Valbona Pass',
    ),
  ].obs;

  @override
  void onInit() {
    super.onInit();
    _updatePrimaryCrossingPreview();
    startDateController.addListener(_updatePrimaryCrossingPreview);
    endDateController.addListener(_updatePrimaryCrossingPreview);
    crossingDateController.addListener(_updatePrimaryCrossingPreview);
    fromController.addListener(_updatePrimaryCrossingPreview);
    toController.addListener(_updatePrimaryCrossingPreview);
    borderPointController.addListener(_updatePrimaryCrossingPreview);
  }

  void onAddCrossingTap() {
    crossings.add(
      HikingCrossingModel(
        fromCountry: fromController.text.trim().isEmpty
            ? 'Albania'
            : fromController.text.trim(),
        toCountry: toController.text.trim().isEmpty
            ? 'Montenegro'
            : toController.text.trim(),
        datesRange: _formatDatesRange(
          startDateController.text.trim(),
          endDateController.text.trim(),
        ),
        crossingDate: crossingDateController.text.trim().isEmpty
            ? '18 Feb, 2026'
            : _formatSingleDate(crossingDateController.text.trim()),
        borderLocation: borderPointController.text.trim().isEmpty
            ? 'Valbona Pass'
            : borderPointController.text.trim(),
      ),
    );
  }

  void onContinueTap() {
    if (!_permitController.validateHikingDetails()) {
      return;
    }
    Get.to(
      () => const ContactDocumentsView(),
      binding: ContactDocumentsBinding(),
    );
  }

  Future<void> pickDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime initialDate = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2035),
    );

    if (picked != null) {
      controller.text =
          '${picked.day.toString().padLeft(2, '0')}-'
          '${picked.month.toString().padLeft(2, '0')}-'
          '${picked.year}';
    }
  }

  @override
  void onClose() {
    startDateController.removeListener(_updatePrimaryCrossingPreview);
    endDateController.removeListener(_updatePrimaryCrossingPreview);
    crossingDateController.removeListener(_updatePrimaryCrossingPreview);
    fromController.removeListener(_updatePrimaryCrossingPreview);
    toController.removeListener(_updatePrimaryCrossingPreview);
    borderPointController.removeListener(_updatePrimaryCrossingPreview);
    super.onClose();
  }

  void _updatePrimaryCrossingPreview() {
    if (crossings.isEmpty) {
      crossings.add(
        HikingCrossingModel(
          fromCountry: fromController.text.trim().isEmpty
              ? 'Albania'
              : fromController.text.trim(),
          toCountry: toController.text.trim().isEmpty
              ? 'Montenegro'
              : toController.text.trim(),
          datesRange: _formatDatesRange(
            startDateController.text.trim(),
            endDateController.text.trim(),
          ),
          crossingDate: _formatSingleDate(crossingDateController.text.trim()),
          borderLocation: borderPointController.text.trim().isEmpty
              ? 'Valbona Pass'
              : borderPointController.text.trim(),
        ),
      );
      return;
    }

    crossings[0] = HikingCrossingModel(
      fromCountry: fromController.text.trim().isEmpty
          ? 'Albania'
          : fromController.text.trim(),
      toCountry: toController.text.trim().isEmpty
          ? 'Montenegro'
          : toController.text.trim(),
      datesRange: _formatDatesRange(
        startDateController.text.trim(),
        endDateController.text.trim(),
      ),
      crossingDate: _formatSingleDate(crossingDateController.text.trim()),
      borderLocation: borderPointController.text.trim().isEmpty
          ? 'Valbona Pass'
          : borderPointController.text.trim(),
    );
  }

  String _formatDatesRange(String startRaw, String endRaw) {
    final start = _parseDdMmYyyy(startRaw);
    final end = _parseDdMmYyyy(endRaw);
    if (start == null || end == null) {
      return '$startRaw - $endRaw';
    }

    return '${DateFormat('dd MMM').format(start)} - ${DateFormat('dd MMMM, yyyy').format(end)}';
  }

  String _formatSingleDate(String raw) {
    final parsed = _parseDdMmYyyy(raw);
    if (parsed == null) {
      return raw;
    }
    return DateFormat('dd MMM, yyyy').format(parsed);
  }

  DateTime? _parseDdMmYyyy(String raw) {
    if (raw.isEmpty) {
      return null;
    }
    try {
      return DateFormat('dd-MM-yyyy').parseStrict(raw);
    } catch (_) {
      return null;
    }
  }
}
