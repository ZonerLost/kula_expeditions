import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';

class BenefitRow extends StatelessWidget {
  final String text;

  const BenefitRow({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 2),
          child: Icon(
            Icons.diamond,
            size: 12,
            color: AppColors.floatingButtonIcon,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.body.copyWith(
              fontSize: 12,
              color: AppColors.black,
            ),
          ),
        ),
      ],
    );
  }
}