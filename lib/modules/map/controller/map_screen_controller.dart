import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../../../constants/app_imges.dart';
import '../../onboarding/model/map_package_model.dart';
import '../model/map_marker_model.dart';
import '../model/poi_category_model.dart';
import '../model/poi_model.dart';

enum MapBottomCardType {
  none,
  selectedCheckpoint,
  lockedTrail,
  campDetail,
  stageGuide,
}

class MapScreenController extends GetxController {
  MapScreenController({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  final selectedChipIndex = 0.obs;
  final searchQuery = ''.obs;
  final searchSuggestions = <String>[].obs;
  final selectedMarker = Rxn<MapMarkerModel>();
  final lockedMarker = Rxn<MapMarkerModel>();
  final currentCard = MapBottomCardType.none.obs;

  final chips = <String>[].obs;
  final categories = <PoiCategoryModel>[].obs;
  final markers = <MapMarkerModel>[].obs;
  final isLoading = true.obs;

  final List<PoiModel> _allPois = [];
  final List<MapMarkerModel> _currentMarkers = [];
  final List<PointAnnotation> _annotations = [];

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _poisSub;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _categoriesSub;

  MapboxMap? mapboxMap;
  PointAnnotationManager? _annotationManager;
  double _currentZoom = 8.0;
  double? _cameraLat;
  double? _cameraLng;
  Timer? _zoomDebounce;

  @override
  void onInit() {
    super.onInit();
    _listenPoiCategories();
    _listenPois();
  }

  void _listenPoiCategories() {
    _categoriesSub = _firestore.collection('poi_categories').snapshots().listen(
      (snapshot) {
        debugPrint('Loaded ${snapshot.docs.length} POI categories from Firestore');
        final activeCategories = snapshot.docs
            .map((doc) => PoiCategoryModel.fromFirestore(doc.data(), doc.id))
            .where((c) => c.status.trim().toLowerCase() == 'active')
            .toList()
          ..sort((a, b) => a.label.toLowerCase().compareTo(b.label.toLowerCase()));

        debugPrint('Active POI categories: ${activeCategories.length}');
        categories.assignAll(activeCategories);
        chips.assignAll(['All', ...activeCategories.map((c) => c.label)]);
        debugPrint('Chips updated: ${chips.length} chips');

        if (selectedChipIndex.value >= chips.length) {
          selectedChipIndex.value = 0;
        }
        _applyFiltersAndRefreshMarkers();
      },
      onError: (e) => debugPrint('Error loading categories: $e'),
    );
  }

  void _listenPois() {
    _poisSub = _firestore.collection('pois').snapshots().listen(
      (snapshot) {
        debugPrint('Loaded ${snapshot.docs.length} POIs from Firestore');
        final activePois = snapshot.docs
            .map((doc) => PoiModel.fromFirestore(doc.data(), doc.id))
            .where((p) => p.status.trim().toLowerCase() == 'active')
            .where((p) => p.latitude != 0 && p.longitude != 0)
            .toList()
          ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

        debugPrint('Active POIs with coordinates: ${activePois.length}');
        _allPois
          ..clear()
          ..addAll(activePois);
        _applyFiltersAndRefreshMarkers();
        isLoading.value = false;
      },
      onError: (e) {
        debugPrint('Error loading POIs: $e');
        isLoading.value = false;
      },
    );
  }

  String? get _selectedCategoryId {
    if (selectedChipIndex.value == 0) return null;
    final idx = selectedChipIndex.value - 1;
    if (idx < 0 || idx >= categories.length) return null;
    return categories[idx].id;
  }

  Future<void> _applyFiltersAndRefreshMarkers() async {
    final query = searchQuery.value.trim().toLowerCase();
    final selectedCategoryId = _selectedCategoryId;

    final filteredPois = _allPois.where((poi) {
      final matchesCategory =
          selectedCategoryId == null || poi.categoryId == selectedCategoryId;
      if (!matchesCategory) return false;
      if (query.isEmpty) return true;
      final categoryLabel = _findCategoryById(poi.categoryId)?.label.toLowerCase();
      return poi.name.toLowerCase().contains(query) ||
          poi.description.toLowerCase().contains(query) ||
          (categoryLabel?.contains(query) ?? false);
    }).toList();

    debugPrint('Filtered POIs: ${filteredPois.length}');

    final baseMarkers = filteredPois.map((poi) {
      return MapMarkerModel(
        id: poi.id,
        title: poi.name,
        subtitle: _findCategoryById(poi.categoryId)?.label ?? 'POI',
        description: poi.description,
        categoryId: poi.categoryId,
        latitude: poi.latitude,
        longitude: poi.longitude,
        imagePath: AppImages.image1,
        imageUrl: poi.imageUrl,
        top: 0,
        left: 0,
        checkpointImage: AppImages.image1,
        distance: _formatDistance(poi.latitude, poi.longitude),
        estimatedTime: _formatTime(poi.latitude, poi.longitude),
      );
    }).toList();

    markers.assignAll(baseMarkers);
    await _updateMapAnnotations(baseMarkers);

    final currentSelectedId = selectedMarker.value?.id;
    if (currentSelectedId != null) {
      selectedMarker.value = _findMarkerById(baseMarkers, currentSelectedId);
      if (selectedMarker.value == null) {
        currentCard.value = MapBottomCardType.none;
      }
    }
  }

  Future<void> _updateMapAnnotations(List<MapMarkerModel> markerList) async {
    final manager = _annotationManager;
    if (manager == null) return;

    _annotations.clear();
    _currentMarkers.clear();
    _currentMarkers.addAll(markerList);
    await manager.deleteAll();

    if (markerList.isEmpty) return;

    final iconSize = _iconSizeForZoom(_currentZoom);
    final options = await Future.wait(
      markerList.map((marker) async {
        final iconBytes = await _buildMarkerIcon(marker.title, marker.subtitle);
        return PointAnnotationOptions(
          geometry: Point(coordinates: Position(marker.longitude, marker.latitude)),
          image: iconBytes,
          iconSize: iconSize,
          iconAnchor: IconAnchor.BOTTOM,
        );
      }),
    );

    final created = await manager.createMulti(options);
    _annotations.addAll(created.whereType<PointAnnotation>());
    debugPrint('Created ${_annotations.length} map annotations at iconSize=$iconSize');
  }

  double _iconSizeForZoom(double zoom) {
    return ((zoom - 8.0) * (0.6 / 6.0) + 0.6).clamp(0.35, 1.2);
  }

  Future<void> _updateAnnotationSizes() async {
    final manager = _annotationManager;
    if (manager == null || _annotations.isEmpty) return;
    final iconSize = _iconSizeForZoom(_currentZoom);
    final snapshot = List<PointAnnotation>.from(_annotations);
    for (final annotation in snapshot) {
      if (!_annotations.contains(annotation)) return;
      try {
        annotation.iconSize = iconSize;
        annotation.image = null;
        await manager.update(annotation);
      } catch (e) {
        debugPrint('Skipping stale annotation update: $e');
      }
    }
  }

  double _haversineKm(double lat1, double lon1, double lat2, double lon2) {
    const r = 6371.0;
    final dLat = (lat2 - lat1) * math.pi / 180;
    final dLon = (lon2 - lon1) * math.pi / 180;
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1 * math.pi / 180) *
            math.cos(lat2 * math.pi / 180) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return r * c;
  }

  String _formatDistance(double poiLat, double poiLng) {
    final camLat = _cameraLat ??
        MapPackageModel.minLat + (MapPackageModel.maxLat - MapPackageModel.minLat) / 2;
    final camLng = _cameraLng ??
        MapPackageModel.minLng + (MapPackageModel.maxLng - MapPackageModel.minLng) / 2;
    final km = _haversineKm(camLat, camLng, poiLat, poiLng);
    if (km < 1) return '${(km * 1000).round()} m';
    return '${km.toStringAsFixed(1)} km';
  }

  String _formatTime(double poiLat, double poiLng) {
    final camLat = _cameraLat ??
        MapPackageModel.minLat + (MapPackageModel.maxLat - MapPackageModel.minLat) / 2;
    final camLng = _cameraLng ??
        MapPackageModel.minLng + (MapPackageModel.maxLng - MapPackageModel.minLng) / 2;
    final km = _haversineKm(camLat, camLng, poiLat, poiLng);
    final minutes = (km / 5.0 * 60).round();
    if (minutes < 60) return '$minutes min';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return m == 0 ? '${h}h' : '${h}h ${m}min';
  }

  Future<Uint8List> _buildMarkerIcon(String title, String subtitle) async {
    const double w = 260;
    const double h = 88;
    const double r = 44;
    const double avatarR = 30;
    const double avatarCx = 52;
    const double avatarCy = h / 2;
    const double tailW = 14;
    const double tailH = 14;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, w, h + tailH));

    // Shadow
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(4, 4, w - 8, h), const Radius.circular(r)),
      Paint()
        ..color = const Color(0x40000000)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );

    // White pill
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, w, h), const Radius.circular(r)),
      Paint()..color = const Color(0xFFFFFFFF),
    );

    // Tail
    canvas.drawPath(
      Path()
        ..moveTo(w / 2 - tailW, h)
        ..lineTo(w / 2, h + tailH)
        ..lineTo(w / 2 + tailW, h)
        ..close(),
      Paint()..color = const Color(0xFFFFFFFF),
    );

    // Avatar circle
    canvas.drawCircle(
      const Offset(avatarCx, avatarCy),
      avatarR,
      Paint()..color = const Color(0xFFE9E9E9),
    );

    // Location pin icon
    final iconPaint = Paint()..color = const Color(0xFF334155);
    canvas.drawCircle(const Offset(avatarCx, avatarCy - 6), 12, iconPaint);
    canvas.drawPath(
      Path()
        ..moveTo(avatarCx - 7, avatarCy + 4)
        ..lineTo(avatarCx, avatarCy + 16)
        ..lineTo(avatarCx + 7, avatarCy + 4)
        ..close(),
      iconPaint,
    );

    // Title
    final titlePainter = TextPainter(
      text: TextSpan(
        text: title,
        style: const TextStyle(
          color: Color(0xFF111111),
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: ui.TextDirection.ltr,
      maxLines: 1,
      ellipsis: '…',
    )..layout(maxWidth: w - avatarCx * 2 - 20);
    titlePainter.paint(canvas, Offset(avatarCx * 2 + 8, avatarCy - titlePainter.height - 3));

    // Subtitle
    if (subtitle.isNotEmpty) {
      final subtitlePainter = TextPainter(
        text: TextSpan(
          text: subtitle,
          style: const TextStyle(color: Color(0xFF6D6D6D), fontSize: 16),
        ),
        textDirection: ui.TextDirection.ltr,
        maxLines: 1,
        ellipsis: '…',
      )..layout(maxWidth: w - avatarCx * 2 - 20);
      subtitlePainter.paint(canvas, Offset(avatarCx * 2 + 8, avatarCy + 5));
    }

    final picture = recorder.endRecording();
    final image = await picture.toImage(w.toInt(), (h + tailH).toInt());
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    return bytes!.buffer.asUint8List();
  }

  PoiCategoryModel? _findCategoryById(String id) {
    for (final category in categories) {
      if (category.id == id) return category;
    }
    return null;
  }

  MapMarkerModel? _findMarkerById(List<MapMarkerModel> list, String id) {
    for (final marker in list) {
      if (marker.id == id) return marker;
    }
    return null;
  }

  Future<void> onMapCreated(MapboxMap map) async {
    mapboxMap = map;
    _annotationManager = await map.annotations.createPointAnnotationManager();
    _annotationManager?.addOnPointAnnotationClickListener(
      _AnnotationClickListener(
        onAnnotationClick: (annotation) {
          final lng = annotation.geometry.coordinates.lng;
          final lat = annotation.geometry.coordinates.lat;
          final marker = _currentMarkers.firstWhereOrNull(
            (m) => m.longitude == lng && m.latitude == lat,
          );
          if (marker != null) onMarkerTap(marker);
        },
      ),
    );
    map.setCamera(CameraOptions(zoom: _currentZoom));
    await _applyFiltersAndRefreshMarkers();
  }

  Future<void> onCameraChanged(CameraChangedEventData event) async {
    final state = await mapboxMap?.getCameraState();
    if (state == null) return;
    final zoom = state.zoom;
    _cameraLat = state.center.coordinates.lat.toDouble();
    _cameraLng = state.center.coordinates.lng.toDouble();
    if ((zoom - _currentZoom).abs() < 0.2) return;
    _currentZoom = zoom;
    _zoomDebounce?.cancel();
    _zoomDebounce = Timer(const Duration(milliseconds: 150), _updateAnnotationSizes);
  }

  Future<void> onMapIdle() async {}

  void changeChipIndex(int index) {
    debugPrint('Chip selected: index=$index, chip=${chips.length > index ? chips[index] : "invalid"}');
    selectedChipIndex.value = index;
    _applyFiltersAndRefreshMarkers();
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
    if (value.trim().isEmpty) {
      searchSuggestions.clear();
      _applyFiltersAndRefreshMarkers();
      return;
    }
    final query = value.trim().toLowerCase();
    final matches = _allPois
        .where((poi) => poi.name.toLowerCase().contains(query))
        .take(5)
        .map((poi) => poi.name)
        .toList();
    searchSuggestions.assignAll(matches);
    _applyFiltersAndRefreshMarkers();
  }

  Future<void> onSuggestionSelected(String poiName) async {
    searchSuggestions.clear();
    searchQuery.value = poiName;
    final poi = _allPois.firstWhereOrNull((p) => p.name == poiName);
    if (poi == null) return;
    final marker = markers.firstWhereOrNull((m) => m.id == poi.id);
    if (marker == null) return;
    await mapboxMap?.flyTo(
      CameraOptions(
        center: Point(coordinates: Position(poi.longitude, poi.latitude)),
        zoom: 14.0,
        pitch: 0,
      ),
      MapAnimationOptions(duration: 1500, startDelay: 0),
    );
    await Future.delayed(const Duration(milliseconds: 1600));
    onMarkerTap(marker);
  }

  void onMarkerTap(MapMarkerModel marker) {
    if (marker.isLocked) {
      lockedMarker.value = marker;
      selectedMarker.value = null;
      currentCard.value = MapBottomCardType.lockedTrail;
      return;
    }
    lockedMarker.value = null;
    selectedMarker.value = marker;
    currentCard.value = MapBottomCardType.selectedCheckpoint;
  }

  void onCloseSelectedCheckpoint() {
    selectedMarker.value = null;
    currentCard.value = MapBottomCardType.none;
  }

  void onCloseLockedMarker() {
    lockedMarker.value = null;
    currentCard.value = MapBottomCardType.none;
  }

  void onContinueMainTrail() {
    lockedMarker.value = null;
    currentCard.value = MapBottomCardType.none;
  }

  void onUnlockFullAccess() => currentCard.value = MapBottomCardType.none;
  void onViewStageGuide() => currentCard.value = MapBottomCardType.stageGuide;
  void onCloseCampDetail() => currentCard.value = MapBottomCardType.none;
  void onCloseStageGuide() => currentCard.value = MapBottomCardType.none;
  void onMapTap() {}
  void onLocationTap() {}
  void onDirectionTap() {}

  @override
  void onClose() {
    _zoomDebounce?.cancel();
    _poisSub?.cancel();
    _categoriesSub?.cancel();
    super.onClose();
  }
}

class _AnnotationClickListener extends OnPointAnnotationClickListener {
  final void Function(PointAnnotation) onAnnotationClick;

  _AnnotationClickListener({required this.onAnnotationClick});

  @override
  void onPointAnnotationClick(PointAnnotation annotation) {
    onAnnotationClick(annotation);
  }
}
