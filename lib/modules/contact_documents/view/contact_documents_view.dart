import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/app_button.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/app_text_styles.dart';
import '../../../constants/app_textfield.dart';
import '../../../widgets/upload_box_widget.dart';
import '../controller/contact_documents_controller.dart';


class ContactDocumentsView extends GetView<ContactDocumentsController> {
  const ContactDocumentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.contactAndDocuments,
                      style: AppTextStyles.title.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 24),

                    Text(
                      AppStrings.emailAddress,
                      style: AppTextStyles.title.copyWith(fontSize: 14),
                    ),
                    const SizedBox(height: 6),
                    _readOnlyField(
                      text: controller.displayEmail,
                      suffixText: '(default)',
                    ),
                    const SizedBox(height: 18),

                    AppTextField(
                      title: AppStrings.emergencyContact,
                      controller: controller.emergencyContactController,
                      keyboardType: TextInputType.phone,
                    ),

                    Text(
                      AppStrings.uploadPassportPhoto,
                      style: AppTextStyles.title.copyWith(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Obx(
                          () => UploadBoxWidget(
                        onTap: controller.uploadPassport,
                        fileName: controller.passportFileName.value,
                      ),
                    ),
                    const SizedBox(height: 18),

                    Text(
                      AppStrings.doYouNeedVisaToEnterMontenegro,
                      style: AppTextStyles.title.copyWith(fontSize: 14),
                    ),
                    const SizedBox(height: 10),

                    Obx(
                          () => Row(
                        children: [
                          _radioOption(
                            title: AppStrings.yes,
                            value: true,
                            groupValue: controller.needsVisa.value,
                            onChanged: (value) {
                              controller.selectVisaOption(value ?? true);
                            },
                          ),
                          const SizedBox(width: 16),
                          _radioOption(
                            title: AppStrings.no,
                            value: false,
                            groupValue: controller.needsVisa.value,
                            onChanged: (value) {
                              controller.selectVisaOption(value ?? false);
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    Obx(
                          () => controller.needsVisa.value
                          ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.uploadVisaDocument,
                            style: AppTextStyles.title.copyWith(fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          UploadBoxWidget(
                            onTap: controller.uploadVisaDocument,
                            fileName: controller.visaFileName.value,
                          ),
                        ],
                      )
                          : const SizedBox.shrink(),
                    ),

                    const SizedBox(height: 26),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      child: Row(
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
                              AppStrings.documentsProcessedInfo,
                              style: AppTextStyles.small.copyWith(
                                fontSize: 11,
                                color: AppColors.greyText,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Obx(() => Container(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 16),
              color: AppColors.scaffoldBg,
              child: AppButton(
                text: controller.isLoading.value
                    ? 'Submitting...'
                    : AppStrings.continueText,
                onTap: controller.isLoading.value
                    ? () {}
                    : controller.onContinueTap,
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _readOnlyField({
    required String text,
    String? suffixText,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xffdcdcdc)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.body.copyWith(
                fontSize: 13,
                color: AppColors.black,
              ),
            ),
          ),
          if (suffixText != null)
            Text(
              suffixText,
              style: AppTextStyles.body.copyWith(
                fontSize: 12,
                color: const Color(0xFF9AA0A6),
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
    );
  }

  Widget _radioOption({
    required String title,
    required bool value,
    required bool groupValue,
    required ValueChanged<bool?> onChanged,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 18,
          height: 18,
          child: Radio<bool>(
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
            activeColor: Colors.green,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: AppTextStyles.body.copyWith(
            fontSize: 13,
            color: AppColors.black,
          ),
        ),
      ],
    );
  }
}