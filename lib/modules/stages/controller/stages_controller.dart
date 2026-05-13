import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import '../../../constants/app_imges.dart';
import '../../../routes/app_routes.dart';
import '../model/stage_model.dart';

class StagesController extends GetxController {
  final stages = <StageModel>[].obs;
  final isLoading = true.obs;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;
  bool _isWifiConnected = false;
  bool _isWifiRefreshRunning = false;

  @override
  void onInit() {
    super.onInit();
    _fetchStages();
    _watchWifiAndRefreshStages();
  }

  @override
  void onClose() {
    _connectivitySub?.cancel();
    super.onClose();
  }

  Future<void> _fetchStages({Source source = Source.serverAndCache}) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('stages')
          .orderBy('order')
          .get(GetOptions(source: source));

      stages.value = snapshot.docs
          .map((doc) => StageModel.fromFirestore(doc.data(), doc.id))
          .toList();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _watchWifiAndRefreshStages() async {
    final connectivity = Connectivity();
    try {
      final results = await connectivity.checkConnectivity();
      _isWifiConnected = results.contains(ConnectivityResult.wifi);
      if (_isWifiConnected) {
        await _refreshStagesFromServer();
      }
    } catch (_) {}

    _connectivitySub = connectivity.onConnectivityChanged.listen((results) {
      final hasWifi = results.contains(ConnectivityResult.wifi);
      final justConnected = hasWifi && !_isWifiConnected;
      _isWifiConnected = hasWifi;
      if (justConnected) {
        _refreshStagesFromServer();
      }
    });
  }

  Future<void> _refreshStagesFromServer() async {
    if (_isWifiRefreshRunning) return;
    _isWifiRefreshRunning = true;
    try {
      await _fetchStages(source: Source.server);
    } finally {
      _isWifiRefreshRunning = false;
    }
  }

  void onStageTap(StageModel stage) {
    Get.toNamed(
      AppRoutes.stageDetail,
      arguments: {
        'title': stage.title.replaceAll(':', ' —'),
        'distance': stage.distanceLabel,
        'estimatedDuration': stage.estimatedTimeLabel,
        'highestPoint': stage.elevationLabel,
        'difficulty': stage.difficulty,
        'image': stage.coverImageUrl.isNotEmpty
            ? stage.coverImageUrl
            : AppImages.stage1,
        'isNetworkImage': stage.coverImageUrl.isNotEmpty,
        'subtitle': stage.subtitle,
        'description': stage.description,
        'waterAndCamps': stage.waterAndCamps,
        'importantNotes': stage.importantNotes,
        'pdfGuideUrl': stage.pdfGuideUrl,
      },
    );
  }
}
