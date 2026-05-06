import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../modules/hiking_crossing/model/hiking_crossing_model.dart';

class BorderCrossingCard extends StatelessWidget {
  final HikingCrossingModel crossing;

  const BorderCrossingCard({super.key, required this.crossing});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.lightBorder),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: AppColors.buttonGreen,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.terrain_rounded,
                size: 16,
                color: AppColors.black,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${crossing.fromCountry} -> ${crossing.toCountry}',
                  style: AppTextStyles.body.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Dates: ${crossing.datesRange}',
                  style: AppTextStyles.small.copyWith(fontSize: 10),
                ),
                const SizedBox(height: 2),
                Text(
                  'Crossing Dates: ${crossing.crossingDate}',
                  style: AppTextStyles.small.copyWith(fontSize: 10),
                ),
                const SizedBox(height: 2),
                Text(
                  'Border Location: ${crossing.borderLocation}',
                  style: AppTextStyles.small.copyWith(fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
