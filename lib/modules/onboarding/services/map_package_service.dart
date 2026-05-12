import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
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
    if (!doc.exists || doc.data() == null) return null;
    return MapPackageModel.fromFirestore(doc.data()!);
  }

  /// Returns true only when the device is on Wi-Fi.
  /// Returns true (allow download) if the plugin is unavailable.
  static Future<bool> isOnWifi() async {
    try {
      final result = await Connectivity().checkConnectivity();
      return result.contains(ConnectivityResult.wifi);
    } catch (_) {
      return true; // can't determine — allow download
    }
  }

  static Future<bool> isDownloaded(String version) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString(_kDownloadedVersion) != version) return false;
    try {
      final tileStore = await TileStore.createDefault();
      final regions = await tileStore.allTileRegions();
      if (!regions.any((r) => r.id == MapPackageModel.tileRegionId))
        return false;
      return await tileStore
          .tileRegionContainsDescriptor(MapPackageModel.tileRegionId, [
            TilesetDescriptorOptions(
              styleURI: MapPackageModel.styleUrl,
              minZoom: 5,
              maxZoom: 14,
            ),
          ]);
    } catch (e) {
      debugPrint('[MapPackage] Error checking download status: $e');
      return false;
    }
  }

  /// Downloads the offline tile region over Wi-Fi.
  /// Zoom levels 5–16, bounds 42.0–43.5°N / 19.3–20.5°E (~600 MB).
  /// Throws [Exception] if not on Wi-Fi.
  static Future<void> downloadPackage(
    MapPackageModel package, {
    required void Function(double progress) onProgress,
  }) async {
    final onWifi = await isOnWifi();
    if (!onWifi) {
      throw Exception('Wi-Fi required to download the offline map.');
    }

    MapboxOptions.setAccessToken(dotenv.env['MAPBOX_DOWNLOAD_TOKEN'] ?? '');
    final tileStore = await TileStore.createDefault();

    final descriptorOptions = TilesetDescriptorOptions(
      styleURI: MapPackageModel.styleUrl,
      minZoom: 5,
      maxZoom: 14, // spec: zoom levels 5–16
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

    await tileStore.loadTileRegion(
      MapPackageModel.tileRegionId,
      TileRegionLoadOptions(
        geometry: geometry,
        descriptorsOptions: [descriptorOptions],
        acceptExpired: true,
        networkRestriction: NetworkRestriction.NONE,
      ),
      (progress) {
        final total = progress.requiredResourceCount;
        final done = progress.completedResourceCount;
        onProgress(total == 0 ? 0.0 : (done / total).clamp(0.0, 1.0));
      },
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kDownloadedVersion, package.version);
    debugPrint(
      '[MapPackage] Download complete – version ${package.version} saved',
    );
  }
}
