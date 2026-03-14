import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_button.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_imges.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/app_text_styles.dart';
import '../../../widgets/benefit_row.dart';
import '../controller/unlock_controller.dart';


class UnlockActivatedView extends GetView<UnlockController> {
  const UnlockActivatedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Image.asset(
                AppImages.unlock,
                height: 220,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 14),
              Text(
                AppStrings.fullAccessActivated,
                style: AppTextStyles.title.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                AppStrings.activatedDescription,
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(fontSize: 12),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  const Expanded(
                    child: Divider(color: AppColors.buttonGreen, thickness: 1),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      AppStrings.benefits,
                      style: AppTextStyles.small.copyWith(
                        fontStyle: FontStyle.italic,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Divider(color: AppColors.buttonGreen, thickness: 1),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const BenefitRow(text: AppStrings.additionalTrailsUnlocked),
              const SizedBox(height: 12),
              const BenefitRow(text: AppStrings.permitDiscountApplied),
              const SizedBox(height: 12),
              const BenefitRow(text: AppStrings.kulaDiscountAvailable),
              const SizedBox(height: 12),
              const BenefitRow(text: AppStrings.couponDisplayed),
              const SizedBox(height: 22),
              AppButton(
                text: AppStrings.applyPermit,
                onTap: controller.onApplyPermitTap,
                color: AppColors.white,
                borderColor: AppColors.lightBorder,
              ),
              const SizedBox(height: 10),
              AppButton(
                text: AppStrings.exploreMap,
                onTap: controller.onExploreMapTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}