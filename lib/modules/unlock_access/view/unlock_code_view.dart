import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_button.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/app_text_styles.dart';
import '../../../widgets/unlock_code_box.dart';
import '../controller/unlock_controller.dart';

class UnlockCodeView extends GetView<UnlockController> {
  const UnlockCodeView({super.key});

  @override
  Widget build(BuildContext context) {
    final focus1 = FocusNode();
    final focus2 = FocusNode();
    final focus3 = FocusNode();
    final focus4 = FocusNode();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      bottomNavigationBar: _bottomNav(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.unlockFullTrailAccess,
                style: AppTextStyles.title.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                AppStrings.unlockDescription,
                style: AppTextStyles.body.copyWith(fontSize: 12),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  UnlockCodeBox(
                    controller: controller.code1Controller,
                    focusNode: focus1,
                    nextFocusNode: focus2,
                  ),
                  UnlockCodeBox(
                    controller: controller.code2Controller,
                    focusNode: focus2,
                    nextFocusNode: focus3,
                  ),
                  UnlockCodeBox(
                    controller: controller.code3Controller,
                    focusNode: focus3,
                    nextFocusNode: focus4,
                  ),
                  UnlockCodeBox(
                    controller: controller.code4Controller,
                    focusNode: focus4,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  AppStrings.dontHaveCode,
                  style: AppTextStyles.small.copyWith(
                    fontSize: 11,
                    color: Colors.red,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              AppButton(
                text: AppStrings.getBalkansEbook,
                onTap: controller.onGetEbookTap,
                color: AppColors.white,
                borderColor: AppColors.lightBorder,
              ),
              const SizedBox(height: 10),
              AppButton(
                text: AppStrings.unlockNow,
                onTap: controller.onUnlockNowTap,
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  AppStrings.codeIncludedWithPurchase,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.small.copyWith(
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomNav() {
    return Container(
      height: 74,
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
          top: BorderSide(color: AppColors.lightBorder),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Icons.map_outlined, AppStrings.navMap, false),
          _navItem(Icons.layers_outlined, AppStrings.navStages, false),
          _navItem(Icons.person_pin_outlined, AppStrings.navPermit, false),
          _navItem(Icons.lock_outline, AppStrings.navUnlock, true),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String title, bool selected) {
    final color = selected ? AppColors.navSelected : AppColors.navUnselected;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(height: 4),
        Text(
          title,
          style: AppTextStyles.small.copyWith(
            color: color,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}