import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/app_button.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/app_text_styles.dart';
import '../../../widgets/summary_row.dart';
import '../../../widgets/summary_section_card.dart';
import '../controller/confirm_pay_controller.dart';

class ConfirmPayView extends GetView<ConfirmPayController> {
  const ConfirmPayView({super.key});

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
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      AppStrings.confirmAndPay,
                      style: AppTextStyles.title.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 22),

                    Text(
                      AppStrings.permitSummary,
                      style: AppTextStyles.title.copyWith(fontSize: 14),
                    ),
                    const SizedBox(height: 10),

                    SummarySectionCard(
                      child: Column(
                        children: [
                          SummaryRow(
                            label: AppStrings.name,
                            value: data.name,
                          ),
                          SummaryRow(
                            label: AppStrings.passportNumber,
                            value: data.passportNumber,
                          ),
                          SummaryRow(
                            label: AppStrings.dates,
                            value: data.dates,
                          ),
                          SummaryRow(
                            label: AppStrings.entry,
                            value: data.entry,
                          ),
                          SummaryRow(
                            label: AppStrings.exit,
                            value: data.exit,
                            showDivider: false,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      AppStrings.orderSummary,
                      style: AppTextStyles.title.copyWith(fontSize: 14),
                    ),
                    const SizedBox(height: 10),

                    SummarySectionCard(
                      child: Column(
                        children: [
                          SummaryRow(
                            label: AppStrings.permitFee,
                            value: data.permitFee,
                          ),
                          SummaryRow(
                            label: AppStrings.processingFee,
                            value: data.processingFee,
                          ),
                          SummaryRow(
                            label: AppStrings.gstTax,
                            value: data.gstTax,
                          ),
                          SummaryRow(
                            label: AppStrings.total,
                            value: data.total,
                            isBold: true,
                            showDivider: false,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 1),
                          child: Icon(
                            Icons.lightbulb_outline,
                            size: 16,
                            color: Color(0xFFF4B400),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            AppStrings.paymentsProcessedByStripe,
                            style: AppTextStyles.small.copyWith(
                              fontSize: 11,
                              color: AppColors.greyText,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(22, 8, 22, 16),
              child: AppButton(
                text: AppStrings.paySecurely,
                onTap: controller.onPaySecurelyTap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}