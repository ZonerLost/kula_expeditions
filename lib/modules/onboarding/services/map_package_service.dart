import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/map_package_model.dart';

class MapPackageService {
  static const _kDownloadedVersion = 'map_package_version';

  static Future<MapPackageModel?> fetchPackage() async {
    final doc = await FirebaseFirestore.instance
        .collection('map_package')
        .doc('main')
        .get();
    if (!doc.exists || doc.data() == null) return null;
    return MapPackageModel.fromFirestore(doc.data()!);
  }

  static Future<bool> isDownloaded(String version) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString(_kDownloadedVersion) != version) return false;
    try {
      final tileStore = await TileStore.createDefault();
      final regions = await tileStore.allTileRegions();
      if (!regions.any((r) => r.id == MapPackageModel.tileRegionId)) {
        return false;
      }
      return await tileStore.tileRegionContainsDescriptor(
        MapPackageModel.tileRegionId,
        [
          TilesetDescriptorOptions(
            styleURI: MapPackageModel.styleUrl,
            minZoom: 5,
            maxZoom: 14,
          ),
        ],
      );
    } catch (_) {
      return false;
    }
  }

  /// Downloads the map package and returns a Future that completes when done.
  /// The download automatically resumes from where it left off if restarted.
  static Future<void> downloadPackage(
    MapPackageModel package, {
    required void Function(double progress) onProgress,
  }) async {
    final tileStore = await TileStore.createDefault();

    final descriptorOptions = TilesetDescriptorOptions(
      styleURI: MapPackageModel.styleUrl,
      minZoom: 5,
      maxZoom: 14,
      stylePackOptions: StylePackLoadOptions(acceptExpired: true),
    );

    final geometry = {
      'type': 'Polygon',
      'coordinates': [
        [
          [MapPackageModel.minLng, MapPackageModel.minLat],
          [MapPackageModel.maxLng, MapPackageModel.minLat],
          [MapPackageModel.maxLng, MapPackageModel.maxLat],
          [MapPackageModel.minLng, MapPackageModel.maxLat],
          [MapPackageModel.minLng, MapPackageModel.minLat],
        ]
      ],
    };

    final loadOptions = TileRegionLoadOptions(
      geometry: geometry,
      descriptorsOptions: [descriptorOptions],
      acceptExpired: true,
      networkRestriction: NetworkRestriction.NONE,
    );

    await tileStore.loadTileRegion(
      MapPackageModel.tileRegionId,
      loadOptions,
      (progress) {
        final total = progress.requiredResourceCount;
        final done = progress.completedResourceCount;
        onProgress(total == 0 ? 0.0 : (done / total).clamp(0.0, 1.0));
      },
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kDownloadedVersion, package.version);
  }
}
