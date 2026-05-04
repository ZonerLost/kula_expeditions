import 'package:get/get.dart';
import '../../../constants/app_strings.dart';
import '../model/onboarding_model.dart';

class OnboardingController extends GetxController {
  final currentIndex = 0.obs;

  final pages = <OnboardingModel>[
    OnboardingModel(
      title: AppStrings.offlineTitle,
      description: AppStrings.offlineDescription,
      buttonText: AppStrings.downloadOfflineMap,
      secondaryButtonText: AppStrings.alreadyDownloaded,
    ),
    OnboardingModel(
      title: AppStrings.downloadingOfflineMapTitle,
      description: AppStrings.offlineDescription,
      buttonText: AppStrings.pauseDownload,
      showProgress: true,
      progress: 0.45,
      showFooterText: true,
    ),
    OnboardingModel(
      title: AppStrings.mapReadyTitle,
      description: AppStrings.mapReadyDescription,
      buttonText: AppStrings.openMap,
      showOpenMapButton: true,
    ),
  ];

  void nextPage() {
    if (currentIndex.value < pages.length - 1) {
      currentIndex.value++;
    }
  }

  void previousPage() {
    if (currentIndex.value > 0) {
      currentIndex.value--;
    }
  }

  void primaryAction() {
    if (currentIndex.value == 0) {
      currentIndex.value = 1;
    } else if (currentIndex.value == 1) {
      currentIndex.value = 2;
    } else {
      Get.offAllNamed('/shell');
    }
  }
  void secondaryAction() {
    currentIndex.value = 2;
  }
}