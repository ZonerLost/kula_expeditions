// lib/widgets/permit_header.dart

import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../extension/context_extension.dart';

class PermitHeader extends StatelessWidget {
  const PermitHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.screenWidth * 0.06,
        vertical: context.screenHeight * 0.01,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Permit',
          style: AppTextStyles.title.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: AppColors.black.withOpacity(0.65),
          ),
        ),
      ),
    );
  }
}