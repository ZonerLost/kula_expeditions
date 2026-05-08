import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/map_package_model.dart';

class MapPackageService {
  static const _kDownloadedVersion = 'map_package_version';

  static Future<MapPackageModel?> fetchPackage() async {
    debugPrint('[MapPackage] Fetching package from Firestore...');
    final doc = await FirebaseFirestore.instance
        .collection('map_package')
        .doc('main')
        .get();
    if (!doc.exists || doc.data() == null) {
      debugPrint('[MapPackage] No package found in Firestore');
      return null;
    }
    final package = MapPackageModel.fromFirestore(doc.data()!);
    debugPrint(
      '[MapPackage] Package fetched: version=${package.version}, isActive=${package.isActive}',
    );
    return package;
  }

  static Future<bool> isDownloaded(String version) async {
    debugPrint('[MapPackage] Checking if version $version is downloaded...');
    final prefs = await SharedPreferences.getInstance();
    final savedVersion = prefs.getString(_kDownloadedVersion);
    debugPrint(
      '[MapPackage] Saved version in SharedPreferences: $savedVersion',
    );

    if (savedVersion != version) {
      debugPrint(
        '[MapPackage] Version mismatch: saved=$savedVersion, required=$version',
      );
      return false;
    }

    try {
      final tileStore = await TileStore.createDefault();
      final regions = await tileStore.allTileRegions();
      debugPrint('[MapPackage] Found ${regions.length} tile regions');

      final hasRegion = regions.any(
        (r) => r.id == MapPackageModel.tileRegionId,
      );
      if (!hasRegion) {
        debugPrint(
          '[MapPackage] Tile region "${MapPackageModel.tileRegionId}" not found',
        );
        return false;
      }
      debugPrint(
        '[MapPackage] Tile region "${MapPackageModel.tileRegionId}" found',
      );

      final containsDescriptor = await tileStore
          .tileRegionContainsDescriptor(MapPackageModel.tileRegionId, [
            TilesetDescriptorOptions(
              styleURI: MapPackageModel.styleUrl,
              minZoom: 5,
              maxZoom: 14,
            ),
          ]);
      debugPrint(
        '[MapPackage] Tile region contains descriptor: $containsDescriptor',
      );
      return containsDescriptor;
    } catch (e) {
      debugPrint('[MapPackage] Error checking download status: $e');
      return false;
    }
  }

  static Future<void> downloadPackage(
    MapPackageModel package, {
    required void Function(double progress) onProgress,
  }) async {
    debugPrint(
      '[MapPackage] Starting download for version ${package.version}...',
    );
    MapboxOptions.setAccessToken(dotenv.env['MAPBOX_DOWNLOAD_TOKEN'] ?? '');
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
        ],
      ],
    };

    final loadOptions = TileRegionLoadOptions(
      geometry: geometry,
      descriptorsOptions: [descriptorOptions],
      acceptExpired: true,
      networkRestriction: NetworkRestriction.NONE,
    );

    debugPrint(
      '[MapPackage] Loading tile region "${MapPackageModel.tileRegionId}"...',
    );
    await tileStore.loadTileRegion(MapPackageModel.tileRegionId, loadOptions, (
      progress,
    ) {
      final total = progress.requiredResourceCount;
      final done = progress.completedResourceCount;
      final percentage = total == 0 ? 0.0 : (done / total).clamp(0.0, 1.0);
      debugPrint(
        '[MapPackage] Download progress: ${(percentage * 100).toStringAsFixed(1)}% ($done/$total)',
      );
      onProgress(percentage);
    });

    debugPrint(
      '[MapPackage] Download complete. Saving version to SharedPreferences...',
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kDownloadedVersion, package.version);
    debugPrint('[MapPackage] Version ${package.version} saved successfully');
  }
}
