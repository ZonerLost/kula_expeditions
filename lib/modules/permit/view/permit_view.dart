// lib/modules/permit/view/permit_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_button.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/bottom_nav_bar/custom_bottom_nav_bar.dart';
import '../../../constants/app_text_styles.dart';
import '../../../extension/context_extension.dart';
import '../controller/permit_controller.dart';

class PermitView extends GetView<PermitController> {
  const PermitView({super.key});

  @override
  Widget build(BuildContext context) {
    final permit = controller.permit;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      body: SafeArea(

        child: Column(
          children: [

            Expanded(
              child: Container(
                width: double.infinity,
                color: AppColors.white,
                child: Column(
                  children: [
                    SizedBox(height: context.screenHeight * 0.18),

                    // image direct screen me
                    Image.asset(
                      permit.image,
                      width: context.screenWidth * 0.72,
                      fit: BoxFit.contain,
                    ),

                    SizedBox(height: context.screenHeight * 0.028),

                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.screenWidth * 0.09,
                      ),
                      child: Column(
                        children: [
                          Text(
                            permit.title,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.title.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.black,
                            ),
                          ),
                          SizedBox(height: context.screenHeight * 0.012),
                          Text(
                            permit.description,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.body.copyWith(
                              fontSize: 13,
                              color: AppColors.greyText,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: context.screenHeight * 0.03),

                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.screenWidth * 0.07,
                      ),
                      child: AppButton(
                        text: permit.buttonText,
                        onTap: controller.onApplyPermitTap,
                      ),
                    ),

                    SizedBox(height: context.screenHeight * 0.02),

                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.screenWidth * 0.09,
                      ),
                      child: Text(
                        permit.footerText,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.small.copyWith(
                          fontSize: 10,
                          fontStyle: FontStyle.italic,
                          color: AppColors.greyText,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        items: controller.navItems,
      ),
    );
  }
}