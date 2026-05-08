import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_colors.dart';
import '../../../widgets/OnboardingCard.dart';
import '../controller/onboarding_controller.dart';

class OnboardingScreen extends GetView<OnboardingController> {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryBgTop,
              AppColors.primaryBgBottom,
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Obx(() {
            // Read both currentIndex and isPaused to trigger rebuild
            final index = controller.currentIndex.value;
            controller.isPaused.value; // Force rebuild when isPaused changes
            final page = controller.pages[index];
            return Column(
              children: [
                const Spacer(),
                OnboardingCard(
                  model: page,
                  onPrimaryTap: () => controller.primaryAction(),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
