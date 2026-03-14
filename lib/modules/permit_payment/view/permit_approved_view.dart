import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/app_button.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/app_text_styles.dart';
import '../controller/permit_approved_controller.dart';

class PermitApprovedView extends GetView<PermitApprovedController> {
  const PermitApprovedView({super.key});

  @override
  Widget build(BuildContext context) {
    final data = controller.permitData;

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
                    IconButton(
                      onPressed: Get.back,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 28),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.lightBorder),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Center(
                                  child: Text(
                                    AppStrings.permitApproved,
                                    style: AppTextStyles.title.copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.verified,
                                size: 16,
                                color: Color(0xFF7B61FF),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),

                          Text(
                            AppStrings.show,
                            style: AppTextStyles.body.copyWith(
                              fontSize: 13,
                              color: AppColors.black,
                            ),
                          ),
                          const SizedBox(height: 8),

                          Container(
                            width: 86,
                            height: 86,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: AppColors.lightBorder),
                              image: const DecorationImage(
                                image: NetworkImage(
                                  'https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=BLK-8F23-9XJ2',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          const SizedBox(height: 14),
                          Divider(color: AppColors.lightBorder, height: 1),
                          const SizedBox(height: 14),

                          _infoTitleValue(AppStrings.permitId, data.permitId),
                          const SizedBox(height: 10),
                          _infoTitleValue(AppStrings.validity, data.validity),
                          const SizedBox(height: 10),
                          _infoTitleValue(
                            AppStrings.deliveryAddress,
                            data.deliveryAddress,
                          ),
                          const SizedBox(height: 14),

                          Row(
                            children: [
                              Expanded(
                                child: _infoTitleValue(
                                  AppStrings.total,
                                  data.total,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8F7E8),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  AppStrings.paid,
                                  style: AppTextStyles.small.copyWith(
                                    fontSize: 10,
                                    color: const Color(0xFF4CAF50),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 16),
              child: AppButton(
                text: AppStrings.downloadQr,
                onTap: controller.onDownloadQrTap,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTitleValue(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$title:",
          style: AppTextStyles.body.copyWith(
            fontSize: 12,
            color: AppColors.greyText,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTextStyles.body.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
      ],
    );
  }
}