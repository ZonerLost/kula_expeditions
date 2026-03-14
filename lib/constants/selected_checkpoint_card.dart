import 'package:flutter/material.dart';
import 'package:kuala_exp/extension/context_extension.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../modules/map/model/map_marker_model.dart';

class SelectedCheckpointCard extends StatelessWidget {
  final MapMarkerModel marker;
  final VoidCallback onClose;

  const SelectedCheckpointCard({
    super.key,
    required this.marker,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: EdgeInsets.fromLTRB(
          context.screenWidth * 0.05,
          context.screenHeight * 0.02,
          context.screenWidth * 0.05,
          context.screenHeight * 0.02,
        ),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(22),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x18000000),
              blurRadius: 12,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Next Checkpoint:",
                    style: AppTextStyles.title.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: onClose,
                  child: const Icon(
                    Icons.close,
                    size: 18,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: context.screenHeight * 0.012),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.lightBorder,
                ),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      marker.checkpointImage ?? marker.imagePath,
                      width: context.screenWidth * 0.13,
                      height: context.screenWidth * 0.13,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: context.screenWidth * 0.03),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          marker.title,
                          style: AppTextStyles.body.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.black,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Distance: ${marker.distance ?? '--'}",
                          style: AppTextStyles.small.copyWith(
                            fontSize: 11,
                            color: AppColors.greyText,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Estimated Time: ${marker.estimatedTime ?? '--'}",
                          style: AppTextStyles.small.copyWith(
                            fontSize: 11,
                            color: AppColors.greyText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}