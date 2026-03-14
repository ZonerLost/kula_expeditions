// lib/modules/stage_detail/controller/stage_detail_controller.dart

import 'package:get/get.dart';
import '../../../constants/app_imges.dart';
import '../model/stage_detail_model.dart';

class StageDetailController extends GetxController {
  late final StageDetailModel stageDetail;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments as Map<String, dynamic>?;

    stageDetail = StageDetailModel(
      title: args?['title'] ?? 'Stage 1 — Theth to Valbona',
      subtitle: args?['subtitle'] ??
          'A scenic mountain crossing connecting Theth and Valbona through Valbona Pass. Expect steep ascents, exposed ridges, and panoramic views.',
      distance: args?['distance'] ?? '16 km',
      estimatedDuration: args?['estimatedDuration'] ?? '6–8 hours',
      highestPoint: args?['highestPoint'] ?? 'Valbona Pass',
      difficulty: args?['difficulty'] ?? 'Moderate',
      description: args?['description'] ??
          'Steady climb from Theth valley followed by a steep ascent toward Valbona Pass. Descent into Valbona includes rocky terrain and narrow paths. Carry sufficient water and begin early to avoid afternoon heat.',
      waterAndCamps: args?['waterAndCamps'] ??
          'Water sources available near start and mid-trail streams (seasonal). Camp spots available near pass clearing and Valbona valley.',
      importantNotes: args?['importantNotes'] ??
          'Weather can change rapidly at higher elevations. Trail markings are red and white. Mobile signal is often unavailable along this stage.',
      image: args?['image'] ?? AppImages.mountains,
    );
  }
}