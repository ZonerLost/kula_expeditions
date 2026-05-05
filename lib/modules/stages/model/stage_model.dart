class StageModel {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final int distanceKm;
  final int estimatedMinutes;
  final String difficulty;
  final String elevationLabel;
  final String coverImageUrl;
  final String status;
  final int order;
  final String trailId;
  final String waterAndCamps;
  final String importantNotes;
  final String pdfGuideUrl;
  final String pdfCoverUrl;

  const StageModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.distanceKm,
    required this.estimatedMinutes,
    required this.difficulty,
    required this.elevationLabel,
    required this.coverImageUrl,
    required this.status,
    required this.order,
    required this.trailId,
    required this.waterAndCamps,
    required this.importantNotes,
    required this.pdfGuideUrl,
    required this.pdfCoverUrl,
  });

  factory StageModel.fromFirestore(Map<String, dynamic> data, String id) {
    return StageModel(
      id: id,
      title: data['title'] ?? '',
      subtitle: data['subtitle'] ?? '',
      description: data['description'] ?? '',
      distanceKm: (data['distanceKm'] ?? 0).toInt(),
      estimatedMinutes: (data['estimatedMinutes'] ?? 0).toInt(),
      difficulty: data['difficulty'] ?? '',
      elevationLabel: data['elevationLabel'] ?? '',
      coverImageUrl: data['coverImageUrl'] ?? '',
      status: data['status'] ?? '',
      order: (data['order'] ?? 0).toInt(),
      trailId: data['trailId'] ?? '',
      waterAndCamps: data['waterAndCamps'] ?? '',
      importantNotes: data['importantNotes'] ?? '',
      pdfGuideUrl: data['pdfGuideUrl'] ?? '',
      pdfCoverUrl: data['pdfCoverUrl'] ?? '',
    );
  }

  String get distanceLabel => '$distanceKm km';

  String get estimatedTimeLabel {
    if (estimatedMinutes < 60) return '$estimatedMinutes min';
    final h = estimatedMinutes ~/ 60;
    final m = estimatedMinutes % 60;
    return m == 0 ? '${h}h' : '${h}h ${m}min';
  }

  bool get isLocked => status != 'published';
}
