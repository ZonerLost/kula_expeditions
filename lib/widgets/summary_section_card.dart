import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';

class SummarySectionCard extends StatelessWidget {
  final Widget child;

  const SummarySectionCard({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightBorder),
      ),
      child: child,
    );
  }
}