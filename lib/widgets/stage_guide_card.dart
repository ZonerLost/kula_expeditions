import 'package:flutter/material.dart';
import 'package:kuala_exp/extension/context_extension.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_imges.dart';
import '../../../constants/app_text_styles.dart';
import '../modules/stages/model/stage_model.dart';

class StageGuideCard extends StatelessWidget {
  final VoidCallback onClose;
  final List<StageModel> stages;

  const StageGuideCard({
    super.key,
    required this.onClose,
    required this.stages,
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
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
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
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Trail Stages & Daily Guides',
                    style: AppTextStyles.title.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
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
            SizedBox(height: context.screenHeight * 0.016),
            if (stages.isEmpty)
              Text(
                'No published stages available yet.',
                style: AppTextStyles.small.copyWith(
                  fontSize: 12,
                  color: AppColors.greyText,
                ),
              )
            else
              ...List.generate(stages.length, (index) {
                final stage = stages[index];
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index == stages.length - 1
                        ? 0
                        : context.screenHeight * 0.012,
                  ),
                  child: _guideItem(
                    context,
                    title: 'Order ${stage.order}: ${_routeLabel(stage)}',
                    distance: stage.distanceLabel,
                    time: stage.estimatedTimeLabel,
                    level: stage.difficulty,
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _guideItem(
    BuildContext context, {
    required String title,
    required String distance,
    required String time,
    required String level,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightBorder),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              AppImages.mountains,
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
                  title,
                  style: AppTextStyles.body.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Distance: $distance',
                  style: AppTextStyles.small.copyWith(
                    fontSize: 11,
                    color: AppColors.greyText,
                  ),
                ),
                Text(
                  'Estimated Time: $time',
                  style: AppTextStyles.small.copyWith(
                    fontSize: 11,
                    color: AppColors.greyText,
                  ),
                ),
                Text(
                  'Elevation: $level',
                  style: AppTextStyles.small.copyWith(
                    fontSize: 11,
                    color: AppColors.greyText,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.floatingButtonIcon),
        ],
      ),
    );
  }

  String _routeLabel(StageModel stage) {
    final from = stage.startName.trim();
    final to = stage.endName.trim();
    if (from.isNotEmpty && to.isNotEmpty) return '$from -> $to';
    if (stage.stageRouteLabel.isNotEmpty) return stage.stageRouteLabel;
    return stage.title;
  }
}
