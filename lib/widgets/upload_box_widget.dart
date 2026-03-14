import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/app_text_styles.dart';

class UploadBoxWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String? fileName;

  const UploadBoxWidget({
    super.key,
    required this.onTap,
    this.fileName,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasFile = fileName != null && fileName!.isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.lightBorder,
          ),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.upload_outlined,
              size: 18,
              color: AppColors.greyText,
            ),
            const SizedBox(height: 10),
            Text(
              hasFile ? fileName! : AppStrings.dropFilesOrClickToAdd,
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(
                fontSize: 12,
                color: hasFile ? AppColors.black : AppColors.greyText,
                fontWeight: hasFile ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}