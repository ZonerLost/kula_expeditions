import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';

class SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final bool showDivider;

  const SummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.isBold = false,
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
              textAlign: TextAlign.right,
              style: AppTextStyles.body.copyWith(
                fontSize: 12,
                fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
                color: AppColors.black,
              ),
            ),
          ],
        ),
        if (showDivider) ...[
          const SizedBox(height: 8),
          Divider(
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