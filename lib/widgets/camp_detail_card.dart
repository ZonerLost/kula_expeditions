import 'package:flutter/material.dart';
import 'package:kuala_exp/extension/context_extension.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../modules/map/model/map_marker_model.dart';

class CampDetailCard extends StatelessWidget {
  final MapMarkerModel marker;
  final VoidCallback onClose;
  final VoidCallback onViewStageGuide;

  const CampDetailCard({
    super.key,
    required this.marker,
    required this.onClose,
    required this.onViewStageGuide,
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
          context.screenHeight * 0.025,
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
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.asset(
                    marker.checkpointImage,
                    width: double.infinity,
                    height: context.screenHeight * 0.22,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: onClose,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.25),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 16,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: context.screenHeight * 0.018),
            Text(
              marker.title,
              style: AppTextStyles.title.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
              ),
            ),
            SizedBox(height: context.screenHeight * 0.010),
            Text(
              'A quiet grass clearing used by local shepherds in summer. Fresh water stream 50m downhill. Suitable for 2–3 tents. No facilities, but sheltered from strong winds and close to the main trail.',
              style: AppTextStyles.small.copyWith(
                fontSize: 12,
                color: AppColors.greyText,
                height: 1.4,
              ),
            ),
            SizedBox(height: context.screenHeight * 0.016),
            Text(
              'Type Tag:',
              style: AppTextStyles.body.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              marker.subtitle,
              style: AppTextStyles.small.copyWith(
                fontSize: 12,
                color: AppColors.greyText,
              ),
            ),
            SizedBox(height: context.screenHeight * 0.016),
            Text(
              'Coordinates',
              style: AppTextStyles.body.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '43.34334, 20.32423',
              style: AppTextStyles.small.copyWith(
                fontSize: 12,
                color: AppColors.greyText,
              ),
            ),
            SizedBox(height: context.screenHeight * 0.024),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onViewStageGuide,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonGreen,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  'View Stage Guide',
                  style: AppTextStyles.body.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}