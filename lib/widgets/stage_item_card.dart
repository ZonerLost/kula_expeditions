import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_imges.dart';
import '../../../constants/app_text_styles.dart';
import '../../../extension/context_extension.dart';
import '../modules/stages/model/stage_model.dart';

class StageItemCard extends StatelessWidget {
  final StageModel stage;
  final VoidCallback onTap;

  const StageItemCard({
    super.key,
    required this.stage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(context.screenWidth * 0.025),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFFDCDCDC),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _StageImage(imagePath: stage.image),
            SizedBox(width: context.screenWidth * 0.03),
            Expanded(
              child: _StageInfo(stage: stage),
            ),
            SizedBox(width: context.screenWidth * 0.02),
            if (stage.isLocked) const _LockedBadge(),
          ],
        ),
      ),
    );
  }
}

class _StageImage extends StatelessWidget {
  final String imagePath;

  const _StageImage({
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.asset(
        imagePath,
        width: context.screenWidth * 0.16,
        height: context.screenWidth * 0.16,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _StageInfo extends StatelessWidget {
  final StageModel stage;

  const _StageInfo({
    required this.stage,
  });

  @override
  Widget build(BuildContext context) {
    final smallStyle = AppTextStyles.small.copyWith(
      fontSize: context.screenWidth * 0.028,
      color: AppColors.greyText,
      fontWeight: FontWeight.w400,
      height: 1.2,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          stage.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.body.copyWith(
            fontSize: context.screenWidth * 0.037,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
            height: 1.2,
          ),
        ),
        SizedBox(height: context.screenHeight * 0.004),
        Text(
          "Distance: ${stage.distance}",
          style: smallStyle,
        ),
        SizedBox(height: context.screenHeight * 0.002),
        Text(
          "Estimated Time: ${stage.estimatedTime}",
          style: smallStyle,
        ),
        SizedBox(height: context.screenHeight * 0.002),
        Text(
          "Elevation: ${stage.elevation}",
          style: smallStyle,
        ),
      ],
    );
  }
}

class _LockedBadge extends StatelessWidget {
  const _LockedBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.screenWidth * 0.06,
      height: context.screenWidth * 0.06,
      decoration: const BoxDecoration(
        color: Color(0xFF7B6EF6),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: SvgPicture.asset(
          AppImages.sign_board,
          width: context.screenWidth * 0.022,
          height: context.screenWidth * 0.022,

        ),
      ),
    );
  }
}