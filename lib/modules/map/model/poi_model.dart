class PoiModel {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String categoryId;
  final String stageId;
  final String trailId;
  final String status;
  final String visibility;
  final double latitude;
  final double longitude;

  const PoiModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.categoryId,
    required this.stageId,
    required this.trailId,
    required this.status,
    required this.visibility,
    required this.latitude,
    required this.longitude,
  });

  factory PoiModel.fromFirestore(Map<String, dynamic> data, String id) {
    final coordinates = (data['coordinates'] as Map<String, dynamic>?) ?? {};
    return PoiModel(
      id: id,
      name: (data['name'] ?? '').toString().trim(),
      description: (data['description'] ?? '').toString().trim(),
      imageUrl: (data['imageUrl'] ?? '').toString().trim(),
      categoryId: (data['categoryId'] ?? '').toString().trim(),
      stageId: (data['stageId'] ?? '').toString().trim(),
      trailId: (data['trailId'] ?? '').toString().trim(),
      status: (data['status'] ?? 'inactive').toString().trim(),
      visibility: (data['visibility'] ?? 'public').toString().trim(),
      latitude: _toDouble(coordinates['lat']),
      longitude: _toDouble(coordinates['lng']),
    );
  }

  static double _toDouble(Object? value) {
    if (value is num) return value.toDouble();
    return 0;
  }
}
