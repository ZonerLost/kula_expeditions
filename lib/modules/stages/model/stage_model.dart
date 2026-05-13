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
  final double startLat;
  final double startLon;
  final double endLat;
  final double endLon;
  final String startName;
  final String endName;

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
    required this.startLat,
    required this.startLon,
    required this.endLat,
    required this.endLon,
    required this.startName,
    required this.endName,
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
      startLat: _toDouble(data['startLat']),
      startLon: _toDouble(data['startLon']),
      endLat: _toDouble(data['endLat']),
      endLon: _toDouble(data['endLon']),
      startName: (data['startName'] ?? '').toString(),
      endName: (data['endName'] ?? '').toString(),
    );
  }

  factory StageModel.fromJson(Map<String, dynamic> data) {
    return StageModel(
      id: (data['id'] ?? '').toString(),
      title: (data['title'] ?? '').toString(),
      subtitle: (data['subtitle'] ?? '').toString(),
      description: (data['description'] ?? '').toString(),
      distanceKm: (data['distanceKm'] ?? 0).toInt(),
      estimatedMinutes: (data['estimatedMinutes'] ?? 0).toInt(),
      difficulty: (data['difficulty'] ?? '').toString(),
      elevationLabel: (data['elevationLabel'] ?? '').toString(),
      coverImageUrl: (data['coverImageUrl'] ?? '').toString(),
      status: (data['status'] ?? '').toString(),
      order: (data['order'] ?? 0).toInt(),
      trailId: (data['trailId'] ?? '').toString(),
      waterAndCamps: (data['waterAndCamps'] ?? '').toString(),
      importantNotes: (data['importantNotes'] ?? '').toString(),
      pdfGuideUrl: (data['pdfGuideUrl'] ?? '').toString(),
      pdfCoverUrl: (data['pdfCoverUrl'] ?? '').toString(),
      startLat: _toDouble(data['startLat']),
      startLon: _toDouble(data['startLon']),
      endLat: _toDouble(data['endLat']),
      endLon: _toDouble(data['endLon']),
      startName: (data['startName'] ?? '').toString(),
      endName: (data['endName'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'distanceKm': distanceKm,
      'estimatedMinutes': estimatedMinutes,
      'difficulty': difficulty,
      'elevationLabel': elevationLabel,
      'coverImageUrl': coverImageUrl,
      'status': status,
      'order': order,
      'trailId': trailId,
      'waterAndCamps': waterAndCamps,
      'importantNotes': importantNotes,
      'pdfGuideUrl': pdfGuideUrl,
      'pdfCoverUrl': pdfCoverUrl,
      'startLat': startLat,
      'startLon': startLon,
      'endLat': endLat,
      'endLon': endLon,
      'startName': startName,
      'endName': endName,
    };
  }

  String get stageRouteLabel {
    final from = startName.trim();
    final to = endName.trim();
    if (from.isNotEmpty && to.isNotEmpty) return '$from -> $to';
    if (from.isNotEmpty) return from;
    if (to.isNotEmpty) return to;
    return '';
  }

  String get stageDisplayTitle {
    final route = stageRouteLabel;
    if (route.isNotEmpty) return 'Stage $order: $route';
    return title;
  }

  String get distanceLabel => '$distanceKm km';

  String get estimatedTimeLabel {
    if (estimatedMinutes < 60) return '$estimatedMinutes min';
    final h = estimatedMinutes ~/ 60;
    final m = estimatedMinutes % 60;
    return m == 0 ? '${h}h' : '${h}h ${m}min';
  }

  bool get isLocked => status != 'published';

  bool get hasValidCoordinates =>
      startLat != 0 && startLon != 0 && endLat != 0 && endLon != 0;

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }
}
