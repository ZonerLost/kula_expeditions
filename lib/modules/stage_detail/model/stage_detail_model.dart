// lib/modules/stage_detail/model/stage_detail_model.dart

class StageDetailModel {
  final String title;
  final String subtitle;
  final String distance;
  final String estimatedDuration;
  final String highestPoint;
  final String difficulty;
  final String description;
  final String waterAndCamps;
  final String importantNotes;
  final String image;
  final String pdfGuideUrl;

  const StageDetailModel({
    required this.title,
    required this.subtitle,
    required this.distance,
    required this.estimatedDuration,
    required this.highestPoint,
    required this.difficulty,
    required this.description,
    required this.waterAndCamps,
    required this.importantNotes,
    required this.image,
    required this.pdfGuideUrl,
  });
}