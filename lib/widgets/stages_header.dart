import 'package:flutter/material.dart';
import '../../../constants/app_text_styles.dart';

class StagesHeader extends StatelessWidget {
  const StagesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      "Trail Stages & Daily Guides",
      style: AppTextStyles.title,
    );
  }
}