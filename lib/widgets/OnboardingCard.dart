import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../constants/app_button.dart';
import '../constants/app_imges.dart';
import '../modules/onboarding/controller/onboarding_controller.dart';
import '../modules/onboarding/model/onboarding_model.dart';

class OnboardingCard extends StatelessWidget {
  final OnboardingModel model;
  final VoidCallback onPrimaryTap;
  final VoidCallback? onSecondaryTap;

  const OnboardingCard({
    super.key,
    required this.model,
    required this.onPrimaryTap,
    this.onSecondaryTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final onboardingController = Get.find<OnboardingController>();

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              model.title,
              style: AppTextStyles.title.copyWith(
                fontSize: 15.5,
                fontWeight: FontWeight.w700,
                height: 1.2,
                color: const Color(0xFF2F3640),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              model.description,
              style: AppTextStyles.body.copyWith(
                fontSize: 12.2,
                height: 1.35,
                color: const Color(0xFF5D6470),
              ),
            ),
            const SizedBox(height: 16),

            if (model.showProgress) ...[
              Obx(() {
                final p = onboardingController.progress.value;
                return Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: AppColors.progressBg,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: p,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.buttonGreen,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${(p * 100).toInt()}%',
                      style: AppTextStyles.small.copyWith(
                        fontSize: 10,
                        color: const Color(0xFF5D6470),
                      ),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 14),
            ],

            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.asset(
                AppImages.onboardingMap,
                width: screenWidth - 40,
                height: 170,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 18),

            if (model.secondaryButtonText != null)
              SizedBox(
                width: double.infinity,
                height: 44,
                child: OutlinedButton(
                  onPressed: onSecondaryTap,
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppColors.white,
                    side: const BorderSide(
                      color: Color(0xFFD9D9D9),
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: EdgeInsets.zero,
                    elevation: 0,
                  ),
                  child: Text(
                    model.secondaryButtonText!,
                    style: AppTextStyles.button.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                ),
              ),

            if (model.secondaryButtonText != null) const SizedBox(height: 10),

            Obx(() {
              final loading = onboardingController.isLoadingPackage.value;
              return SizedBox(
                width: double.infinity,
                height: 44,
                child: loading
                    ? const Center(child: CircularProgressIndicator())
                    : AppButton(
                        text: model.buttonText,
                        onTap: onPrimaryTap,
                      ),
              );
            }),

            if (model.showFooterText) ...[
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: Text(
                  'Keep the app open. This may take a few minutes.',
                  style: AppTextStyles.small.copyWith(
                    fontSize: 11,
                    height: 1.3,
                    color: const Color(0xFF5D6470),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
