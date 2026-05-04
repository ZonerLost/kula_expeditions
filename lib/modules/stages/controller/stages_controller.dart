// lib/modules/stages/controller/stages_controller.dart

import 'package:get/get.dart';
import '../../../constants/app_imges.dart';
import '../../../constants/app_strings.dart';
import '../../../routes/app_routes.dart';
import '../model/stage_model.dart';

class StagesController extends GetxController {

  final stages = const <StageModel>[
    StageModel(
      title: "Stage 1: Theth → Valbona",
      distance: "16 km",
      estimatedTime: "52 min",
      elevation: "Moderate",
      image: AppImages.mountains,
      isLocked: true,
    ),
    StageModel(
      title: "Stage 2: Valbona → Theth",
      distance: "16 km",
      estimatedTime: "50 min",
      elevation: "Moderate",
      image: AppImages.mountains,
      isLocked: true,
    ),
    StageModel(
      title: "Stage 3: Theth → Grunas",
      distance: "12 km",
      estimatedTime: "40 min",
      elevation: "Challenging",
      image: AppImages.mountains,
      isLocked: true,
    ),
    StageModel(
      title: "Stage 4: Grunas → Rroshnik",
      distance: "14 km",
      estimatedTime: "45 min",
      elevation: "Moderate",
      image: AppImages.mountains,
      isLocked: true,
    ),
    StageModel(
      title: "Stage 5: Rroshnik → Koman",
      distance: "20 km",
      estimatedTime: "1 hr 15 min",
      elevation: "Moderate",
      image: AppImages.mountains,
      isLocked: true,
    ),
    StageModel(
      title: "Stage 6: Koman → Shkodra",
      distance: "22 km",
      estimatedTime: "1 hr 30 min",
      elevation: "Easy",
      image: AppImages.mountains,
      isLocked: true,
    ),
  ];

  @override
  void onInit() {
    super.onInit();
  }

  void onStageTap(StageModel stage) {
    Get.toNamed(
      AppRoutes.stageDetail,
      arguments: {
        'title': stage.title.replaceAll(':', ' —'),
        'distance': stage.distance,
        'estimatedDuration': stage.title.contains('Stage 1')
            ? '6–8 hours'
            : stage.title.contains('Stage 2')
            ? '5–7 hours'
            : stage.title.contains('Stage 3')
            ? '4–5 hours'
            : stage.title.contains('Stage 4')
            ? '5–6 hours'
            : stage.title.contains('Stage 5')
            ? '6–7 hours'
            : '7–8 hours',
        'highestPoint': stage.title.contains('Valbona')
            ? 'Valbona Pass'
            : stage.title.contains('Grunas')
            ? 'Grunas Ridge'
            : stage.title.contains('Koman')
            ? 'Koman Crest'
            : 'Trail Peak',
        'difficulty': stage.elevation,
        'image': AppImages.stage1,
        'subtitle':
        'A scenic mountain crossing connecting key points along the route. Expect varied terrain, exposed ridges, forest paths, and panoramic views.',
        'description':
        'This stage includes a steady climb, uneven terrain, and scenic trail sections. Start early, carry enough water, and be prepared for changing weather conditions along the route.',
        'waterAndCamps':
        'Water sources may be available near the start or at seasonal trail streams. Suitable resting and camp areas can be found at selected points along the route.',
        'importantNotes':
        'Weather can change quickly in higher sections. Trail markings should be followed carefully, and mobile signal may be weak or unavailable in some areas.',
      },
    );
  }
}