import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MapPackageModel {
  final String name;
  final String version;
  final int sizeBytes;
  final String coverage;
  final bool isActive;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  // Bounds derived from coverage: 42.0–43.5°N / 19.3–20.5°E
  static const double minLat = 42.0;
  static const double maxLat = 43.5;
  static const double minLng = 19.3;
  static const double maxLng = 20.5;

  static const String styleUrl = MapboxStyles.OUTDOORS;
  static const String tileRegionId = 'peaks-of-the-balkans';

  static CoordinateBounds get bounds => CoordinateBounds(
        southwest: Point(coordinates: Position(minLng, minLat)),
        northeast: Point(coordinates: Position(maxLng, maxLat)),
        infiniteBounds: false,
      );

  const MapPackageModel({
    required this.name,
    required this.version,
    required this.sizeBytes,
    required this.coverage,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MapPackageModel.fromFirestore(Map<String, dynamic> data) {
    return MapPackageModel(
      name: data['name'] ?? '',
      version: data['version'] ?? '',
      sizeBytes: (data['sizeBytes'] ?? 0).toInt(),
      coverage: data['coverage'] ?? '',
      isActive: data['isActive'] ?? false,
      createdAt: data['createdAt'] ?? Timestamp.now(),
      updatedAt: data['updatedAt'] ?? Timestamp.now(),
    );
  }

  String get sizeMb => '${(sizeBytes / (1024 * 1024)).toStringAsFixed(0)} MB';
}
