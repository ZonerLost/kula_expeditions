import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/app_button.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/app_text_styles.dart';
import '../../../constants/app_textfield.dart';
import '../../../widgets/border_crossing_card.dart';
import '../controller/hiking_details_controller.dart';

class HikingDetailsView extends GetView<HikingDetailsController> {
  const HikingDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _header(),
                    const SizedBox(height: 22),

                    AppTextField(
                      title: AppStrings.startDate,
                      controller: controller.startDateController,
                      readOnly: true,
                      onTap: () => controller.pickDate(
                        context,
                        controller.startDateController,
                      ),
                      suffix: const Icon(
                        Icons.calendar_today_outlined,
                        size: 18,
                        color: AppColors.black,
                      ),
                    ),

                    AppTextField(
                      title: AppStrings.endDate,
                      controller: controller.endDateController,
                      readOnly: true,
                      onTap: () => controller.pickDate(
                        context,
                        controller.endDateController,
                      ),
                      suffix: const Icon(
                        Icons.calendar_today_outlined,
                        size: 18,
                        color: AppColors.black,
                      ),
                    ),

                    AppTextField(
                      title: AppStrings.crossingDate,
                      controller: controller.crossingDateController,
                      readOnly: true,
                      onTap: () => controller.pickDate(
                        context,
                        controller.crossingDateController,
                      ),
                      suffix: const Icon(
                        Icons.calendar_today_outlined,
                        size: 18,
                        color: AppColors.black,
                      ),
                    ),

                    AppTextField(
                      title: AppStrings.from,
                      controller: controller.fromController,
                    ),

                    AppTextField(
                      title: AppStrings.to,
                      controller: controller.toController,
                    ),

                    AppTextField(
                      title: AppStrings.borderPoint,
                      controller: controller.borderPointController,
                    ),

                    Text(
                      AppStrings.borderCrossings,
                      style: AppTextStyles.title.copyWith(fontSize: 14),
                    ),
                    const SizedBox(height: 10),

                    Obx(
                          () => Column(
                        children: controller.crossings
                            .map(
                              (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: BorderCrossingCard(crossing: item),
                          ),
                        )
                            .toList(),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 16),
              color: AppColors.scaffoldBg,
              child: AppButton(
                text: AppStrings.continueText,
                onTap: controller.onContinueTap,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      children: [
        Expanded(
          child: Text(
            AppStrings.hikingDetails,
            style: AppTextStyles.title.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        GestureDetector(
          onTap: controller.onAddCrossingTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.floatingButtonIcon.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Text(
              AppStrings.addCrossing,
              style: AppTextStyles.body.copyWith(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.floatingButtonIcon,
              ),
            ),
          ),
        ),
      ],
    );
  }
}