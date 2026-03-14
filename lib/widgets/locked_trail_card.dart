import 'package:flutter/material.dart';
import 'package:kuala_exp/extension/context_extension.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../modules/map/model/map_marker_model.dart';

class LockedTrailCard extends StatelessWidget {
  final MapMarkerModel marker;
  final VoidCallback onClose;
  final VoidCallback onContinue;
  final VoidCallback onUnlock;

  const LockedTrailCard({
    super.key,
    required this.marker,
    required this.onClose,
    required this.onContinue,
    required this.onUnlock,
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
                    height: context.screenHeight * 0.20,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: onClose,
                    child: Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.25),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: context.screenHeight * 0.018),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Additional Trails Locked',
                    style: AppTextStyles.title.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                  ),
                ),
                const Icon(
                  Icons.lock_outline,
                  size: 17,
                  color: AppColors.black,
                ),
              ],
            ),
            SizedBox(height: context.screenHeight * 0.008),
            Text(
              'Unlock extended routes, detailed POIs, and permit discounts with your e-book code.',
              style: AppTextStyles.small.copyWith(
                fontSize: 12,
                color: AppColors.greyText,
                height: 1.35,
              ),
            ),
            SizedBox(height: context.screenHeight * 0.022),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onContinue,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    color: Color(0xFF8BE35A),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  'Continue on Main Trail',
                  style: AppTextStyles.body.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
              ),
            ),
            SizedBox(height: context.screenHeight * 0.012),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onUnlock,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8BE35A),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  'Unlock Full Access',
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