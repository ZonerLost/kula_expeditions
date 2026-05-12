import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:get/get.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../../../constants/app_imges.dart';
import '../../../services/location_service.dart';
import '../../../utils/vincenty_util.dart';
import '../../onboarding/model/map_package_model.dart';
import '../model/map_marker_model.dart';
import '../model/poi_category_model.dart';
import '../model/poi_model.dart';

enum MapBottomCardType { none, selectedCheckpoint, lockedTrail, campDetail, stageGuide }

class MapScreenController extends GetxController {
  MapScreenController({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  // ── Observables ──────────────────────────────────────────────────────────
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

  // Live GPS observables (updated every 1 s)
  final userLat = Rxn<double>();
  final userLng = Rxn<double>();

  // Distance / ETA to selected checkpoint (updated every 5 s)
  final liveDistance = ''.obs;
  final liveEta = ''.obs;

  // ── Private state ─────────────────────────────────────────────────────────
  final List<PoiModel> _allPois = [];
  final List<MapMarkerModel> _currentMarkers = [];
  final List<PointAnnotation> _annotations = [];

  StreamSubscription<QuerySnapshot>? _poisSub;
  StreamSubscription<QuerySnapshot>? _categoriesSub;
  StreamSubscription<geo.Position>? _gpsSub;
  Timer? _etaTimer;
  Timer? _zoomDebounce;

  MapboxMap? mapboxMap;
  PointAnnotationManager? _annotationManager;
  CircleAnnotationManager? _blueDotManager;
  CircleAnnotation? _blueDotAnnotation;

  double _currentZoom = 8.0;
  double? _cameraLat;
  double? _cameraLng;

  // ── Lifecycle ─────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    _listenPoiCategories();
    _listenPois();
    _startGps();
  }

  @override
  void onClose() {
    _zoomDebounce?.cancel();
    _etaTimer?.cancel();
    _gpsSub?.cancel();
    _poisSub?.cancel();
    _categoriesSub?.cancel();
    super.onClose();
  }

  // ── GPS ───────────────────────────────────────────────────────────────────
  void _startGps() async {
    final granted = await LocationService.instance.requestPermission();
    if (!granted) {
      debugPrint('[Map] Location permission denied');
      return;
    }

    _gpsSub = LocationService.instance.positionStream.listen((geo.Position pos) {
      userLat.value = pos.latitude;
      userLng.value = pos.longitude;
      _updateBlueDot(pos.latitude, pos.longitude);
    });

    // 5-second ETA refresh timer
    _etaTimer = Timer.periodic(const Duration(seconds: 5), (_) => _refreshEta());
  }

  void _refreshEta() {
    final lat = userLat.value;
    final lng = userLng.value;
    final marker = selectedMarker.value;
    if (lat == null || lng == null || marker == null) return;

    final metres = VincentyUtil.distanceMetres(lat, lng, marker.latitude, marker.longitude);
    liveDistance.value = VincentyUtil.formatDistance(metres);
    liveEta.value = VincentyUtil.formatEta(metres);
  }

  Future<void> _updateBlueDot(double lat, double lng) async {
    final manager = _blueDotManager;
    if (manager == null) return;

    if (_blueDotAnnotation == null) {
      _blueDotAnnotation = await manager.create(
        CircleAnnotationOptions(
          geometry: Point(coordinates: Position(lng, lat)),
          circleRadius: 8.0,
          circleColor: const Color(0xFF4A90E2).toARGB32(),
          circleStrokeWidth: 2.5,
          circleStrokeColor: Colors.white.toARGB32(),
          circleOpacity: 0.95,
        ),
      );
    } else {
      _blueDotAnnotation!.geometry = Point(coordinates: Position(lng, lat));
      await manager.update(_blueDotAnnotation!);
    }
  }

  // ── Firestore streams ─────────────────────────────────────────────────────
  void _listenPoiCategories() {
    _categoriesSub = _firestore.collection('poi_categories').snapshots().listen(
      (snapshot) {
        final active = snapshot.docs
            .map((d) => PoiCategoryModel.fromFirestore(d.data(), d.id))
            .where((c) => c.status.trim().toLowerCase() == 'active')
            .toList()
          ..sort((a, b) => a.label.toLowerCase().compareTo(b.label.toLowerCase()));

        categories.assignAll(active);
        chips.assignAll(['All', ...active.map((c) => c.label)]);
        if (selectedChipIndex.value >= chips.length) selectedChipIndex.value = 0;
        _applyFiltersAndRefreshMarkers();
      },
      onError: (e) => debugPrint('Error loading categories: $e'),
    );
  }

  void _listenPois() {
    _poisSub = _firestore.collection('pois').snapshots().listen(
      (snapshot) {
        final active = snapshot.docs
            .map((d) => PoiModel.fromFirestore(d.data(), d.id))
            .where((p) => p.status.trim().toLowerCase() == 'active')
            .where((p) => p.latitude != 0 && p.longitude != 0)
            .toList()
          ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

        _allPois
          ..clear()
          ..addAll(active);
        _applyFiltersAndRefreshMarkers();
        isLoading.value = false;
      },
      onError: (e) {
        debugPrint('Error loading POIs: $e');
        isLoading.value = false;
      },
    );
  }

  // ── Filtering & annotations ───────────────────────────────────────────────
  String? get _selectedCategoryId {
    if (selectedChipIndex.value == 0) return null;
    final idx = selectedChipIndex.value - 1;
    if (idx < 0 || idx >= categories.length) return null;
    return categories[idx].id;
  }

  Future<void> _applyFiltersAndRefreshMarkers() async {
    final query = searchQuery.value.trim().toLowerCase();
    final catId = _selectedCategoryId;

    final filtered = _allPois.where((poi) {
      if (catId != null && poi.categoryId != catId) return false;
      if (query.isEmpty) return true;
      final catLabel = _findCategoryById(poi.categoryId)?.label.toLowerCase();
      return poi.name.toLowerCase().contains(query) ||
          poi.description.toLowerCase().contains(query) ||
          (catLabel?.contains(query) ?? false);
    }).toList();

    final baseMarkers = filtered.map((poi) {
      final metres = _distanceToPoiMetres(poi.latitude, poi.longitude);
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
        distance: VincentyUtil.formatDistance(metres),
        estimatedTime: VincentyUtil.formatEta(metres),
      );
    }).toList();

    markers.assignAll(baseMarkers);
    await _updateMapAnnotations(baseMarkers);

    final currentId = selectedMarker.value?.id;
    if (currentId != null) {
      selectedMarker.value = _findMarkerById(baseMarkers, currentId);
      if (selectedMarker.value == null) currentCard.value = MapBottomCardType.none;
    }
  }

  double _distanceToPoiMetres(double poiLat, double poiLng) {
    final fromLat = userLat.value ??
        _cameraLat ??
        MapPackageModel.minLat + (MapPackageModel.maxLat - MapPackageModel.minLat) / 2;
    final fromLng = userLng.value ??
        _cameraLng ??
        MapPackageModel.minLng + (MapPackageModel.maxLng - MapPackageModel.minLng) / 2;
    return VincentyUtil.distanceMetres(fromLat, fromLng, poiLat, poiLng);
  }

  Future<void> _updateMapAnnotations(List<MapMarkerModel> markerList) async {
    final manager = _annotationManager;
    if (manager == null) return;

    _annotations.clear();
    _currentMarkers
      ..clear()
      ..addAll(markerList);
    await manager.deleteAll();
    if (markerList.isEmpty) return;

    final iconSize = _iconSizeForZoom(_currentZoom);
    final options = await Future.wait(
      markerList.map((m) async {
        final iconBytes = await _buildMarkerIcon(m.title, m.subtitle);
        return PointAnnotationOptions(
          geometry: Point(coordinates: Position(m.longitude, m.latitude)),
          image: iconBytes,
          iconSize: iconSize,
          iconAnchor: IconAnchor.BOTTOM,
        );
      }),
    );

    final created = await manager.createMulti(options);
    _annotations.addAll(created.whereType<PointAnnotation>());
  }

  double _iconSizeForZoom(double zoom) =>
      ((zoom - 8.0) * (0.6 / 6.0) + 0.6).clamp(0.35, 1.2);

  Future<void> _updateAnnotationSizes() async {
    final manager = _annotationManager;
    if (manager == null || _annotations.isEmpty) return;
    final iconSize = _iconSizeForZoom(_currentZoom);
    for (final annotation in List<PointAnnotation>.from(_annotations)) {
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

  // ── Map callbacks ─────────────────────────────────────────────────────────
  Future<void> onMapCreated(MapboxMap map) async {
    mapboxMap = map;
    _annotationManager = await map.annotations.createPointAnnotationManager();
    _blueDotManager = await map.annotations.createCircleAnnotationManager();

    // ignore: deprecated_member_use
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

    final lat = userLat.value;
    final lng = userLng.value;
    if (lat != null && lng != null) _updateBlueDot(lat, lng);
  }

  Future<void> onCameraChanged(CameraChangedEventData event) async {
    final state = await mapboxMap?.getCameraState();
    if (state == null) return;
    _cameraLat = state.center.coordinates.lat.toDouble();
    _cameraLng = state.center.coordinates.lng.toDouble();
    final zoom = state.zoom;
    if ((zoom - _currentZoom).abs() < 0.2) return;
    _currentZoom = zoom;
    _zoomDebounce?.cancel();
    _zoomDebounce = Timer(const Duration(milliseconds: 150), _updateAnnotationSizes);
  }

  Future<void> onMapIdle() async {}

  // ── Location button ───────────────────────────────────────────────────────
  void onLocationTap() {
    final lat = userLat.value;
    final lng = userLng.value;
    if (lat == null || lng == null) return;
    mapboxMap?.flyTo(
      CameraOptions(
        center: Point(coordinates: Position(lng, lat)),
        zoom: 14.0,
        pitch: 0,
      ),
      MapAnimationOptions(duration: 800, startDelay: 0),
    );
  }

  // ── Chip / search ─────────────────────────────────────────────────────────
  void changeChipIndex(int index) {
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
    final q = value.trim().toLowerCase();
    searchSuggestions.assignAll(
      _allPois.where((p) => p.name.toLowerCase().contains(q)).take(5).map((p) => p.name),
    );
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

  // ── Marker interaction ────────────────────────────────────────────────────
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
    _refreshEta();
  }

  void onCloseSelectedCheckpoint() {
    selectedMarker.value = null;
    liveDistance.value = '';
    liveEta.value = '';
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
  void onDirectionTap() {}

  // ── Helpers ───────────────────────────────────────────────────────────────
  PoiCategoryModel? _findCategoryById(String id) {
    for (final c in categories) {
      if (c.id == id) return c;
    }
    return null;
  }

  MapMarkerModel? _findMarkerById(List<MapMarkerModel> list, String id) {
    for (final m in list) {
      if (m.id == id) return m;
    }
    return null;
  }

  Future<Uint8List> _buildMarkerIcon(String title, String subtitle) async {
    const double w = 260, h = 88, r = 44;
    const double avatarR = 30, avatarCx = 52, avatarCy = h / 2;
    const double tailW = 14, tailH = 14;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, w, h + tailH));

    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(4, 4, w - 8, h), const Radius.circular(r)),
      Paint()
        ..color = const Color(0x40000000)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, w, h), const Radius.circular(r)),
      Paint()..color = const Color(0xFFFFFFFF),
    );
    canvas.drawPath(
      Path()
        ..moveTo(w / 2 - tailW, h)
        ..lineTo(w / 2, h + tailH)
        ..lineTo(w / 2 + tailW, h)
        ..close(),
      Paint()..color = const Color(0xFFFFFFFF),
    );
    canvas.drawCircle(
      const Offset(avatarCx, avatarCy),
      avatarR,
      Paint()..color = const Color(0xFFE9E9E9),
    );
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
}

// ignore: deprecated_member_use
class _AnnotationClickListener extends OnPointAnnotationClickListener {
  final void Function(PointAnnotation) onAnnotationClick;
  _AnnotationClickListener({required this.onAnnotationClick});

  @override
  void onPointAnnotationClick(PointAnnotation annotation) => onAnnotationClick(annotation);
}
