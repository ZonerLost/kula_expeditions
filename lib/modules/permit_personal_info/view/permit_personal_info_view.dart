// permit_personal_info_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kuala_exp/constants/app_textfield.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_styles.dart';
import '../../../constants/app_button.dart';
import '../../../../widgets/permit_dropdown.dart';
import '../controller/permit_personal_info_controller.dart';

class PermitPersonalInfoView extends GetView<PermitPersonalInfoController> {

  const PermitPersonalInfoView({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xfff3f3f3),

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [


            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                color: AppColors.white,

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      "Personal Information",
                      style: AppTextStyles.title.copyWith(
                        fontSize: 18,
                      ),
                    ),

                    const SizedBox(height: 30),

                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [

                            AppTextField(
                              title: "Full Name",
                              controller: controller.fullNameController,
                            ),

                            AppTextField(
                              title: "Passport Number",
                              controller: controller.passportController,
                            ),

                            AppTextField(
                              title: "Date of Birth",
                              controller: controller.dobController,
                              readOnly: true,
                              suffix: const Icon(Icons.calendar_today),
                              onTap: () {
                                controller.pickDate(context);
                              },
                            ),

                            Obx(() => PermitDropdown(
                              title: "Nationality",
                              value: controller.nationality.value,
                              items: controller.nationalities,
                              onChanged: (val) {
                                controller.nationality.value = val!;
                              },
                            )),

                            AppTextField(
                              title: "Place of Birth",
                              controller: controller.placeController,
                            ),

                            const SizedBox(height: 10),

                            Row(
                              children: const [

                                Text("💡"),

                                SizedBox(width: 6),

                                Expanded(
                                  child: Text(
                                    "Your passport details must match your uploaded document.",
                                    style: AppTextStyles.small,
                                  ),
                                ),
                              ],
                            ),

                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    AppButton(
                      text: "Continue",
                      onTap: controller.onContinueTap,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}