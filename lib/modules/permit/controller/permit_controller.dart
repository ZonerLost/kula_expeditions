// lib/modules/permit/controller/permit_controller.dart

import 'dart:io';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';

import '../../../features/permits/models/permit_model.dart' as permit_entity;
import '../../../features/permits/models/permit_request_model.dart';
import '../../../features/permits/services/permit_local_storage_service.dart';
import '../../../features/permits/services/permit_remote_service.dart';
import '../../../features/permits/services/permit_storage_service.dart';
import '../../../constants/app_imges.dart';
import '../../../constants/app_strings.dart';
import '../../../routes/app_routes.dart';
import '../model/permit_model.dart' as permit_ui;

class PermitController extends GetxController {
  PermitController({
    PermitRemoteService? remoteService,
    PermitLocalStorageService? localStorageService,
    PermitStorageService? storageService,
  }) : _remoteService = remoteService ?? PermitRemoteService(),
       _localStorageService =
           localStorageService ?? PermitLocalStorageService(),
       _storageService = storageService ?? PermitStorageService();

  final permit = permit_ui.PermitModel(
    title: AppStrings.permitMainTitle,
    description: AppStrings.permitDescription,
    buttonText: AppStrings.applyPermit,
    footerText: AppStrings.permitFooter,
    image: AppImages.permit_image,
  );

  final PermitRemoteService _remoteService;
  final PermitLocalStorageService _localStorageService;
  final PermitStorageService _storageService;

  final isLoading = false.obs;
  final isSubmitting = false.obs;
  final permits = <permit_entity.PermitModel>[].obs;
  final savedPermitIds = <String>[].obs;
  final forceShowMainPermitScreen = false.obs;
  final showPermitStatusScreen = false.obs;
  final selectedPermit = Rxn<permit_entity.PermitModel>();

  final personalInfoFormKey = GlobalKey<FormState>();
  final hikingDetailsFormKey = GlobalKey<FormState>();
  final contactDocumentsFormKey = GlobalKey<FormState>();

  final fullNameController = TextEditingController();
  final passportController = TextEditingController();
  final dobController = TextEditingController();
  final placeController = TextEditingController();

  final startDateController = TextEditingController(text: '12-02-2026');
  final endDateController = TextEditingController(text: '12-02-2026');
  final crossingDateController = TextEditingController(text: '18-02-2026');
  final fromController = TextEditingController(text: 'Albania');
  final toController = TextEditingController(text: 'Montenegro');
  final borderPointController = TextEditingController(text: 'Valbona Pass');

  final emailController = TextEditingController(text: 'Diablo@gmail.com');
  final emergencyContactController = TextEditingController(
    text: '+9883232783823',
  );
  final amountController = TextEditingController(text: '0');

  final nationality = 'French'.obs;
  final nationalities = const <String>[
    'French',
    'German',
    'Italian',
    'Spanish',
    'Kosovo',
    'Montenegro',
  ];

  final needsVisa = true.obs;
  final hasDiscount = false.obs;
  final passportFileName = ''.obs;
  final visaFileName = ''.obs;
  PlatformFile? _passportFile;
  PlatformFile? _visaFile;

  static const String permitVerifyBaseUrl =
      'https://yourdomain.com/verify-permit';

  // This is not a real authenticated user ID. Permits are shown by locally saved permitIds only.
  static const String demoUserId = 'demo-mobile-user-1';

  @override
  void onInit() {
    super.onInit();
    loadMyPermits();
  }

  @override
  void onClose() {
    fullNameController.dispose();
    passportController.dispose();
    dobController.dispose();
    placeController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    crossingDateController.dispose();
    fromController.dispose();
    toController.dispose();
    borderPointController.dispose();
    emailController.dispose();
    emergencyContactController.dispose();
    amountController.dispose();
    super.onClose();
  }

  void onApplyPermitTap() {
    Get.toNamed(AppRoutes.permitPersonalInfo);
  }

  void startNewPermitFlow() {
    showPermitStatusScreen.value = false;
    forceShowMainPermitScreen.value = true;
  }

  void openPermitListTab() {
    showPermitStatusScreen.value = false;
    forceShowMainPermitScreen.value = false;
  }

  void openPermitStatusScreen({permit_entity.PermitModel? permit}) {
    if (permit != null) {
      selectedPermit.value = permit;
    }
    forceShowMainPermitScreen.value = false;
    showPermitStatusScreen.value = true;
  }

  bool validatePersonalInfo() {
    final fullName = fullNameController.text.trim();
    if (fullName.isEmpty) {
      _showError('Full Name is required.');
      return false;
    }
    if (fullName.length < 2) {
      _showError('Full Name must be at least 2 characters.');
      return false;
    }
    if (RegExp(r'\d').hasMatch(fullName)) {
      _showError('Full Name should not contain numbers.');
      return false;
    }

    final passport = passportController.text.trim();
    if (passport.isEmpty) {
      _showError('Passport Number is required.');
      return false;
    }
    if (passport.length < 5) {
      _showError('Passport Number must be at least 5 characters.');
      return false;
    }

    if (dobController.text.trim().isEmpty) {
      _showError('Date of Birth is required.');
      return false;
    }
    if (nationality.value.trim().isEmpty) {
      _showError('Nationality is required.');
      return false;
    }
    if (placeController.text.trim().isEmpty) {
      _showError('Place of Birth is required.');
      return false;
    }
    return true;
  }

  bool validateHikingDetails() {
    final startText = startDateController.text.trim();
    final endText = endDateController.text.trim();
    final crossingText = crossingDateController.text.trim();
    final fromCountry = fromController.text.trim();
    final toCountry = toController.text.trim();
    final borderPoint = borderPointController.text.trim();

    if (startText.isEmpty) {
      _showError('Start Date is required.');
      return false;
    }
    if (endText.isEmpty) {
      _showError('End Date is required.');
      return false;
    }
    if (crossingText.isEmpty) {
      _showError('Crossing Date is required.');
      return false;
    }
    if (fromCountry.isEmpty) {
      _showError('From Country is required.');
      return false;
    }
    if (toCountry.isEmpty) {
      _showError('To Country is required.');
      return false;
    }
    if (borderPoint.isEmpty) {
      _showError('Border Point is required.');
      return false;
    }
    if (fromCountry.toLowerCase() == toCountry.toLowerCase()) {
      _showError('From Country and To Country should not be the same.');
      return false;
    }

    final start = _parseInputDate(startText);
    final end = _parseInputDate(endText);
    final crossing = _parseInputDate(crossingText);
    if (start == null || end == null || crossing == null) {
      _showError('Please select valid dates.');
      return false;
    }
    if (end.isBefore(start)) {
      _showError('End Date cannot be before Start Date.');
      return false;
    }
    if (crossing.isBefore(start) || crossing.isAfter(end)) {
      _showError('Crossing Date should be between Start Date and End Date.');
      return false;
    }

    return true;
  }

  bool validateContactDocuments() {
    final email = emailController.text.trim();
    final emergency = emergencyContactController.text.trim();
    final amount = amountController.text.trim();

    if (email.isEmpty) {
      _showError('Email is required.');
      return false;
    }
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      _showError('Please enter a valid email address.');
      return false;
    }
    if (emergency.isEmpty) {
      _showError('Emergency Contact is required.');
      return false;
    }
    if (!RegExp(r'^\+?[0-9\s\-\(\)]{7,20}$').hasMatch(emergency)) {
      _showError('Please enter a valid emergency contact number.');
      return false;
    }

    if (amount.isNotEmpty && num.tryParse(amount) == null) {
      _showError('Amount must be numeric.');
      return false;
    }

    if (_passportFile == null) {
      _showError('Passport image is required.');
      return false;
    }
    if (needsVisa.value && _visaFile == null) {
      _showError('Visa image is required when visa is needed.');
      return false;
    }
    return true;
  }

  Future<void> pickPassportImage() async {
    final selected = await _pickImageFile();
    if (selected == null) {
      return;
    }
    _passportFile = selected;
    passportFileName.value = selected.name;
  }

  Future<void> pickVisaImage() async {
    final selected = await _pickImageFile();
    if (selected == null) {
      return;
    }
    _visaFile = selected;
    visaFileName.value = selected.name;
  }

  void clearVisaImage() {
    _visaFile = null;
    visaFileName.value = '';
  }

  PermitRequestModel buildPermitRequest() {
    final amount = num.tryParse(amountController.text.trim()) ?? 0;
    return PermitRequestModel(
      fullName: fullNameController.text.trim(),
      passportNumber: passportController.text.trim(),
      nationality: nationality.value.trim(),
      startDate: _toBackendDate(startDateController.text.trim()) ?? '',
      endDate: _toBackendDate(endDateController.text.trim()) ?? '',
      crossingDate: _toBackendDate(crossingDateController.text.trim()) ?? '',
      fromCountry: fromController.text.trim(),
      toCountry: toController.text.trim(),
      borderPoint: borderPointController.text.trim(),
      email: emailController.text.trim(),
      emergencyContact: emergencyContactController.text.trim(),
      needsVisa: needsVisa.value,
      hasDiscount: hasDiscount.value,
      amountPaid: amount,
      paymentStatus: 'unpaid',
      passportUrl: '',
      visaUrl: '',
      userId: demoUserId,
      status: 'pending',
    );
  }

  Future<permit_entity.PermitModel?> submitPermitRequest() async {
    if (!validatePersonalInfo() ||
        !validateHikingDetails() ||
        !validateContactDocuments()) {
      debugPrint('[Permit][Submit] Validation failed, aborting.');
      return null;
    }

    isSubmitting.value = true;
    try {
      final request = buildPermitRequest();
      debugPrint('[Permit][Submit] Submit started.');
      final createdPermit = await _remoteService.createPermitRequest(request);
      debugPrint(
        '[Permit][Submit] Firestore write succeeded. permitId=${createdPermit.permitId}',
      );
      final uploadedUrls = await _uploadAndPersistDocumentUrls(
        permitId: createdPermit.permitId,
      );
      final permitWithUrls = createdPermit.copyWith(
        passportUrl: uploadedUrls.$1,
        visaUrl: uploadedUrls.$2,
      );

      var savedLocally = true;
      try {
        await savePermitIdAfterSubmit(createdPermit.permitId);
        debugPrint(
          '[Permit][Submit] Saved permitId locally. permitId=${createdPermit.permitId}',
        );
      } on PlatformException catch (storageError) {
        savedLocally = false;
        debugPrint(
          '[Permit][Submit] Local save failed. '
          'code=${storageError.code}, message=${storageError.message}',
        );
      } catch (storageError, storageStack) {
        savedLocally = false;
        debugPrint('[Permit][Submit] Local save failed. error=$storageError');
        debugPrint('[Permit][Submit] Local save stack=$storageStack');
      }

      try {
        await refreshPermits();
        debugPrint(
          '[Permit][Submit] Refresh succeeded. permitsCount=${permits.length}',
        );
      } on FirebaseException catch (refreshError) {
        debugPrint(
          '[Permit][Submit] Refresh failed after successful submit. '
          'code=${refreshError.code}, message=${refreshError.message}',
        );
      } catch (refreshError, refreshStack) {
        debugPrint(
          '[Permit][Submit] Refresh failed after successful submit. '
          'error=$refreshError',
        );
        debugPrint('[Permit][Submit] Refresh stack=$refreshStack');
      }

      selectedPermit.value =
          _findPermit(permitWithUrls.permitId) ?? permitWithUrls;
      if (savedLocally) {
        Get.snackbar('Success', 'Permit request submitted successfully.');
      } else {
        Get.snackbar(
          'Submitted',
          'Permit submitted, but local save failed. Permit ID: ${permitWithUrls.permitId}',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 5),
        );
      }
      return selectedPermit.value;
    } on FirebaseException catch (error) {
      debugPrint(
        '[Permit][Submit][FirebaseException] code=${error.code}, message=${error.message}',
      );
      debugPrint(
        '[Permit][Submit][FirebaseException] stack=${error.stackTrace}',
      );
      _showError('Submit failed [${error.code}] ${error.message ?? ''}'.trim());
      return null;
    } catch (error) {
      debugPrint('[Permit][Submit][Exception] error=$error');
      _showError('Unable to submit permit request. Please try again.');
      return null;
    } finally {
      isSubmitting.value = false;
      debugPrint('[Permit][Submit] Submit completed.');
    }
  }

  Future<void> savePermitIdAfterSubmit(String permitId) async {
    await _localStorageService.savePermitId(permitId);
    if (!savedPermitIds.contains(permitId)) {
      savedPermitIds.add(permitId);
    }
  }

  Future<void> loadMyPermits() async {
    isLoading.value = true;
    try {
      List<String> permitIds;
      try {
        permitIds = await _localStorageService.getPermitIds();
      } on PlatformException catch (storageError) {
        debugPrint(
          '[Permit][LoadMyPermits] Local read failed. '
          'code=${storageError.code}, message=${storageError.message}',
        );
        savedPermitIds.clear();
        permits.clear();
        return;
      }
      savedPermitIds.assignAll(permitIds);
      if (permitIds.isEmpty) {
        permits.clear();
        return;
      }

      final latestPermits = await _remoteService.getPermitsByIds(permitIds);
      final withQrPaths = await Future.wait(
        latestPermits.map((permit) async {
          final qrPath = await _localStorageService.getQrLocalPath(
            permit.permitId,
          );
          return permit.copyWith(qrLocalPath: qrPath);
        }),
      );

      permits.assignAll(withQrPaths);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshPermits() async {
    await loadMyPermits();
  }

  String generateQrPayload(permit_entity.PermitModel permit) {
    final isPlaceholder = permitVerifyBaseUrl.contains('yourdomain.com');
    if (isPlaceholder) {
      return 'PERMIT_ID:${permit.permitId}';
    }
    return '$permitVerifyBaseUrl/${permit.permitId}';
  }

  Future<String?> saveQrForOffline(permit_entity.PermitModel permit) async {
    if (permit.status.toLowerCase() != 'approved') {
      _showError('QR is available only for approved permits.');
      return null;
    }

    final payload = generateQrPayload(permit);
    final painter = QrPainter(data: payload, version: QrVersions.auto);
    final pngData = await painter.toImageData(
      900,
      format: ui.ImageByteFormat.png,
    );
    final bytes = pngData?.buffer.asUint8List();
    if (bytes == null) {
      _showError('Unable to generate QR right now.');
      return null;
    }

    final documentsDir = await getApplicationDocumentsDirectory();
    final qrDir = Directory('${documentsDir.path}/permits/qr');
    if (!await qrDir.exists()) {
      await qrDir.create(recursive: true);
    }

    final file = File('${qrDir.path}/${permit.permitId}.png');
    await file.writeAsBytes(bytes, flush: true);
    await _localStorageService.saveQrLocalPath(permit.permitId, file.path);

    final index = permits.indexWhere(
      (item) => item.permitId == permit.permitId,
    );
    if (index >= 0) {
      final updated = permits[index].copyWith(qrLocalPath: file.path);
      permits[index] = updated;
      if (selectedPermit.value?.permitId == updated.permitId) {
        selectedPermit.value = updated;
      }
    }

    return file.path;
  }

  // Important limitation:
  // This app has no auth and no recovery. Permits are linked only through
  // locally saved permitIds on this device. If user deletes app, clears app data,
  // or changes device, old permits cannot be restored.

  permit_entity.PermitModel? findPermitById(String permitId) {
    return _findPermit(permitId);
  }

  bool get hasSavedPermitIds => savedPermitIds.isNotEmpty;

  permit_entity.PermitModel? _findPermit(String permitId) {
    for (final permit in permits) {
      if (permit.permitId == permitId) {
        return permit;
      }
    }
    return null;
  }

  Future<(String, String)> _uploadAndPersistDocumentUrls({
    required String permitId,
  }) async {
    if (_passportFile == null) {
      throw StateError('Passport image is missing.');
    }
    if (needsVisa.value && _visaFile == null) {
      throw StateError('Visa image is missing.');
    }

    final passportUrl = await _storageService.uploadDocument(
      file: _passportFile!,
      permitId: permitId,
      type: PermitDocumentType.passport,
    );

    String visaUrl = '';
    if (needsVisa.value) {
      visaUrl = await _storageService.uploadDocument(
        file: _visaFile!,
        permitId: permitId,
        type: PermitDocumentType.visa,
      );
    }

    await _remoteService.updatePermitDocumentUrls(
      permitId: permitId,
      passportUrl: passportUrl,
      visaUrl: needsVisa.value ? visaUrl : '',
    );
    return (passportUrl, visaUrl);
  }

  Future<PlatformFile?> _pickImageFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      withData: true,
      allowedExtensions: const <String>['jpg', 'jpeg', 'png', 'webp', 'heic'],
    );
    if (result == null || result.files.isEmpty) {
      return null;
    }

    final file = result.files.first;
    if (file.bytes == null || file.bytes!.isEmpty) {
      throw StateError(
        'Could not read selected file. Please pick a smaller image and try again.',
      );
    }
    return file;
  }

  DateTime? _parseInputDate(String value) {
    try {
      return DateFormat('dd-MM-yyyy').parseStrict(value);
    } catch (_) {
      return null;
    }
  }

  String? _toBackendDate(String value) {
    final parsed = _parseInputDate(value);
    if (parsed == null) {
      return null;
    }
    return DateFormat('yyyy-MM-dd').format(parsed);
  }

  void _showError(String message) {
    Get.snackbar('Validation', message, snackPosition: SnackPosition.BOTTOM);
  }
}
