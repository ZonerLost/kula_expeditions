import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';

class UnlockSummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool showDivider;

  const UnlockSummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                "$label:",
                style: AppTextStyles.body.copyWith(
                  fontSize: 12,
                  color: AppColors.greyText,
                ),
              ),
            ),
            Text(
              value,
              style: AppTextStyles.body.copyWith(
                fontSize: 12,
                color: AppColors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        if (showDivider) ...[
          const SizedBox(height: 8),
          const Divider(
            height: 1,
            thickness: 1,
            color: AppColors.lightBorder,
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}