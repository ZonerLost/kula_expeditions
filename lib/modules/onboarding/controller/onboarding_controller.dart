import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../constants/app_strings.dart';
import '../model/onboarding_model.dart';
import '../model/map_package_model.dart';
import '../services/map_package_service.dart';

class OnboardingController extends GetxController {
  final currentIndex = 0.obs;
  final progress = 0.0.obs;
  final isLoadingPackage = false.obs;
  final isPaused = false.obs;

  bool _downloadComplete = false;
  MapPackageModel? _currentPackage;
  bool _downloadCancelled = false;

  List<OnboardingModel> get pages => [
        OnboardingModel(
          title: AppStrings.offlineTitle,
          description: AppStrings.offlineDescription,
          buttonText: AppStrings.downloadOfflineMap,
        ),
        OnboardingModel(
          title: AppStrings.downloadingOfflineMapTitle,
          description: AppStrings.offlineDescription,
          buttonText: isPaused.value
              ? AppStrings.resumeDownload
              : AppStrings.pauseDownload,
          showProgress: true,
          showFooterText: true,
        ),
        OnboardingModel(
          title: AppStrings.mapReadyTitle,
          description: AppStrings.mapReadyDescription,
          buttonText: AppStrings.openMap,
          showOpenMapButton: true,
        ),
      ];

  Future<void> primaryAction() async {
    if (currentIndex.value == 0) {
      isLoadingPackage.value = true;
      final package = await MapPackageService.fetchPackage();
      isLoadingPackage.value = false;
      if (package == null || !package.isActive) return;
      _currentPackage = package;
      progress.value = 0.0;
      currentIndex.value = 1;
      _startDownload();
    } else if (currentIndex.value == 1) {
      if (isPaused.value) {
        _resumeDownload();
      } else {
        _pauseDownload();
      }
    } else if (currentIndex.value == 2 && _downloadComplete) {
      Get.offAllNamed('/shell');
    }
  }

  void _startDownload() {
    if (_currentPackage == null) return;
    _downloadCancelled = false;
    isPaused.value = false;
    _runDownload();
  }

  void _pauseDownload() {
    _downloadCancelled = true;
    isPaused.value = true;
  }

  void _resumeDownload() {
    isPaused.value = false;
    _runDownload();
  }

  void _runDownload() {
    if (_currentPackage == null) return;
    _downloadCancelled = false;

    debugPrint('[Onboarding] Starting map download...');
    MapPackageService.downloadPackage(
      _currentPackage!,
      onProgress: (p) {
        if (!_downloadCancelled) {
          progress.value = p;
        }
      },
    ).then((_) {
      if (!_downloadCancelled) {
        debugPrint('[Onboarding] Download complete. Navigating to shell...');
        _downloadComplete = true;
        currentIndex.value = 2;
      }
    }).catchError((e) {
      debugPrint('[Onboarding] Download failed: $e');
      if (!_downloadCancelled) {
        currentIndex.value = 0;
        progress.value = 0.0;
      }
    });
  }
}
