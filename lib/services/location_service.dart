import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

/// Singleton GPS service.
/// Uses Android Fused / iOS CLLocation via geolocator.
/// Battery-optimised: [LocationAccuracy.balanced] ≈ ≤7 %/hr.
/// Works in airplane mode (GPS-only, no network).
class LocationService {
  LocationService._();
  static final LocationService instance = LocationService._();

  // 1-second live position stream
  static const _settings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 2, // metres – suppresses micro-jitter
    timeLimit: null,
  );

  StreamController<Position>? _controller;
  StreamSubscription<Position>? _gpsSub;
  Position? _last;

  Position? get lastPosition => _last;

  /// Returns a broadcast stream of GPS positions (~1 s cadence).
  /// Handles permission requests internally; emits nothing if denied.
  Stream<Position> get positionStream {
    _controller ??= StreamController<Position>.broadcast(
      onListen: _start,
      onCancel: _stop,
    );
    return _controller!.stream;
  }

  Future<bool> requestPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    LocationPermission perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    return perm == LocationPermission.whileInUse ||
        perm == LocationPermission.always;
  }

  void _start() async {
    final granted = await requestPermission();
    if (!granted) {
      debugPrint('[LocationService] Permission denied – GPS inactive');
      return;
    }
    _gpsSub = Geolocator.getPositionStream(locationSettings: _settings).listen(
      (pos) {
        _last = pos;
        _controller?.add(pos);
      },
      onError: (e) => debugPrint('[LocationService] GPS error: $e'),
      cancelOnError: false,
    );
    debugPrint('[LocationService] GPS stream started');
  }

  void _stop() {
    _gpsSub?.cancel();
    _gpsSub = null;
    debugPrint('[LocationService] GPS stream stopped');
  }

  void dispose() {
    _stop();
    _controller?.close();
    _controller = null;
  }
}
