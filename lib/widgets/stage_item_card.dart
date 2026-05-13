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

  const StageItemCard({super.key, required this.stage, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(context.screenWidth * 0.025),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFDCDCDC)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _StageImage(
              imagePath: stage.coverImageUrl.isNotEmpty
                  ? stage.coverImageUrl
                  : AppImages.mountains,
              isNetwork: stage.coverImageUrl.isNotEmpty,
            ),
            SizedBox(width: context.screenWidth * 0.03),
            Expanded(child: _StageInfo(stage: stage)),
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
  final bool isNetwork;

  const _StageImage({required this.imagePath, this.isNetwork = false});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: isNetwork
          ? Image.network(
              imagePath,
              width: context.screenWidth * 0.16,
              height: context.screenWidth * 0.16,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _fallback(context),
            )
          : Image.asset(
              imagePath,
              width: context.screenWidth * 0.16,
              height: context.screenWidth * 0.16,
              fit: BoxFit.cover,
            ),
    );
  }

  Widget _fallback(BuildContext context) => Image.asset(
    AppImages.mountains,
    width: context.screenWidth * 0.16,
    height: context.screenWidth * 0.16,
    fit: BoxFit.cover,
  );
}

class _StageInfo extends StatelessWidget {
  final StageModel stage;

  const _StageInfo({required this.stage});

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
        Row(
          children: [
            Expanded(
              child: Text(
                stage.stageDisplayTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body.copyWith(
                  fontSize: context.screenWidth * 0.037,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                  height: 1.2,
                ),
              ),
            ),
            SizedBox(width: context.screenWidth * 0.015),

            CircleAvatar(
              radius: context.screenWidth * 0.035,
              backgroundColor: AppColors.floatingButtonIcon,
              child: SvgPicture.asset(
                AppImages.sign_board,
                width: context.screenWidth * 0.04,
                height: context.screenWidth * 0.04,
              ),
            ),
          ],
        ),
        SizedBox(height: context.screenHeight * 0.004),
        // if (stage.stageRouteLabel.isNotEmpty) ...[
        //   Text(stage.stageRouteLabel, style: smallStyle),
        //   SizedBox(height: context.screenHeight * 0.002),
        // ],
        Text("Distance: ${stage.distanceLabel}", style: smallStyle),
        SizedBox(height: context.screenHeight * 0.002),
        Text("Estimated Time: ${stage.estimatedTimeLabel}", style: smallStyle),
        SizedBox(height: context.screenHeight * 0.002),
        Text("Elevation: ${stage.difficulty}", style: smallStyle),
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
