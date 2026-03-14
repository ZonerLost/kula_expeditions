import 'package:flutter/material.dart';
import '../../../constants/app_button.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/app_text_styles.dart';
import '../modules/permit_list/model/permit_list_model.dart';

class PermitCardWidget extends StatelessWidget {
  final PermitListModel permit;
  final VoidCallback onOpenMapTap;
  final VoidCallback onDownloadQrTap;

  const PermitCardWidget({
    super.key,
    required this.permit,
    required this.onOpenMapTap,
    required this.onDownloadQrTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.lightBorder),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.asset(
                  permit.imagePath,
                  width: 28,
                  height: 28,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Permit ID: ${permit.permitId}",
                      style: AppTextStyles.body.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "${AppStrings.validity}: ${permit.validity}",
                      style: AppTextStyles.small.copyWith(
                        fontSize: 10,
                        color: AppColors.greyText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  text: AppStrings.openMap,
                  onTap: onOpenMapTap,
                  color: const Color(0xFFF1F2F4),
                  borderColor: Colors.transparent,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AppButton(
                  text: AppStrings.downloadQr,
                  onTap: onDownloadQrTap,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}