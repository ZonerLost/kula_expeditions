import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../../constants/app_imges.dart';
import '../../../routes/app_routes.dart';
import '../model/stage_model.dart';

class StagesController extends GetxController {
  final stages = <StageModel>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _fetchStages();
  }

  Future<void> _fetchStages() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('stages')
          .orderBy('order')
          .get();

      stages.value = snapshot.docs
          .map((doc) => StageModel.fromFirestore(doc.data(), doc.id))
          .toList();
    } finally {
      isLoading.value = false;
    }
  }

  void onStageTap(StageModel stage) {
    Get.toNamed(
      AppRoutes.stageDetail,
      arguments: {
        'title': stage.title.replaceAll(':', ' —'),
        'distance': stage.distanceLabel,
        'estimatedDuration': stage.estimatedTimeLabel,
        'highestPoint': stage.elevationLabel,
        'difficulty': stage.difficulty,
        'image': stage.coverImageUrl.isNotEmpty ? stage.coverImageUrl : AppImages.stage1,
        'isNetworkImage': stage.coverImageUrl.isNotEmpty,
        'subtitle': stage.subtitle,
        'description': stage.description,
        'waterAndCamps': stage.waterAndCamps,
        'importantNotes': stage.importantNotes,
        'pdfGuideUrl': stage.pdfGuideUrl,
      },
    );
  }
}
