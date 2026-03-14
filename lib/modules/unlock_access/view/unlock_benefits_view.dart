import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_button.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/app_text_styles.dart';
import '../../../widgets/unlock_summary_row.dart';
import '../controller/unlock_controller.dart';


class UnlockBenefitsView extends GetView<UnlockController> {
  const UnlockBenefitsView({super.key});

  @override
  Widget build(BuildContext context) {
    final data = controller.unlockData.value;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 6),
              Row(
                children: [
                  const Spacer(),
                  Text(
                    AppStrings.fullAccessActive,
                    style: AppTextStyles.title.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.verified,
                    size: 15,
                    color: AppColors.floatingButtonIcon,
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 26),
              Text(
                AppStrings.benefits,
                style: AppTextStyles.title.copyWith(fontSize: 14),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.lightBorder),
                ),
                child: Column(
                  children: [
                    UnlockSummaryRow(
                      label: AppStrings.additionalTrails,
                      value: AppStrings.unlocked,
                    ),
                    UnlockSummaryRow(
                      label: AppStrings.extendedPois,
                      value: AppStrings.available,
                    ),
                    UnlockSummaryRow(
                      label: AppStrings.permitDiscount,
                      value: data.permitDiscount,
                    ),
                    UnlockSummaryRow(
                      label: AppStrings.coupon,
                      value: data.couponCode,
                    ),
                    UnlockSummaryRow(
                      label: AppStrings.exit,
                      value: data.exitCountry,
                      showDivider: false,
                    ),
                  ],
                ),
              ),
              const Spacer(),
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