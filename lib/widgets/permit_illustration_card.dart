// lib/widgets/permit_illustration_card.dart

import 'package:flutter/material.dart';
import '../extension/context_extension.dart';

class PermitIllustrationCard extends StatelessWidget {
  final String imagePath;

  const PermitIllustrationCard({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.screenWidth * 0.62,
      child: Image.asset(
        imagePath,
        fit: BoxFit.contain,
      ),
    );
  }
}