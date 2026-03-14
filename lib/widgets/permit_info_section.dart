// lib/widgets/permit_info_section.dart

import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../extension/context_extension.dart';

class PermitInfoSection extends StatelessWidget {
  final String title;
  final String description;
  final String footerText;

  const PermitInfoSection({
    super.key,
    required this.title,
    required this.description,
    required this.footerText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.screenWidth * 0.09,
      ),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.title.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
          SizedBox(height: context.screenHeight * 0.012),
          Text(
            description,
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(
              fontSize: 13,
              color: AppColors.greyText,
              height: 1.35,
            ),
          ),
          SizedBox(height: context.screenHeight * 0.018),
          Text(
            footerText,
            textAlign: TextAlign.center,
            style: AppTextStyles.small.copyWith(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: AppColors.greyText,
            ),
          ),
        ],
      ),
    );
  }
}