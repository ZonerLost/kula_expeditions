import 'package:get/get.dart';
import '../../../constants/app_imges.dart';
import '../../../constants/app_strings.dart';
import '../model/map_marker_model.dart';

enum MapBottomCardType {
  none,
  selectedCheckpoint,
  lockedTrail,
  campDetail,
  stageGuide,
}

class MapScreenController extends GetxController {
  final selectedChipIndex = 0.obs;
  final selectedMarker = Rxn<MapMarkerModel>();
  final lockedMarker = Rxn<MapMarkerModel>();
  final currentCard = MapBottomCardType.selectedCheckpoint.obs;

  final chips = <String>[
    AppStrings.chipCamps,
    AppStrings.chipMountainPass,
    AppStrings.chipVillage,
  ];

  final markers = <MapMarkerModel>[
    MapMarkerModel(
      title: 'Water Source',
      subtitle: 'Fresh Water',
      imagePath: AppImages.image1,
      top: 0.12,
      left: 0.05,
      checkpointImage: AppImages.image1,
      distance: '1.2 km',
      estimatedTime: '20 min',
    ),
    MapMarkerModel(
      title: 'Camp Spot',
      subtitle: 'Rest Area',
      imagePath: AppImages.image1,
      top: 0.03,
      left: 0.53,
      checkpointImage: AppImages.image1,
      distance: '1.8 km',
      estimatedTime: '30 min',
    ),
    MapMarkerModel(
      title: 'Vista Point',
      subtitle: 'Scenic View',
      imagePath: AppImages.image1,
      top: 0.36,
      left: 0.04,
      checkpointImage: AppImages.image1,
      distance: '2.0 km',
      estimatedTime: '35 min',
    ),
    MapMarkerModel(
      title: 'Mountain Pass',
      subtitle: 'High Crossing',
      imagePath: AppImages.lock_image1,
      top: 0.26,
      left: 0.63,
      checkpointImage: AppImages.lock_image1,
      distance: '2.4 km',
      estimatedTime: '52 min',
      isLocked: true,
    ),
    MapMarkerModel(
      title: 'Village Stop',
      subtitle: 'Food Supply',
      imagePath: AppImages.image1,
      top: 0.44,
      left: 0.68,
      checkpointImage: AppImages.image1,
      distance: '2.7 km',
      estimatedTime: '58 min',
    ),
    MapMarkerModel(
      title: 'Shelter/Hut',
      subtitle: 'Safe Stop',
      imagePath: AppImages.image1,
      top: 0.56,
      left: 0.04,
      checkpointImage: AppImages.image1,
      distance: '3.0 km',
      estimatedTime: '1 hr 05 min',
    ),
  ];

  final MapMarkerModel defaultCheckpoint = MapMarkerModel(
    title: 'Valbona Pass',
    subtitle: 'Next Checkpoint',
    imagePath: AppImages.image1,
    top: 0.41,
    left: 0.42,
    checkpointImage: AppImages.image1,
    distance: '2.4 km',
    estimatedTime: '52 min',
  );

  final MapMarkerModel shepherdCamp = MapMarkerModel(
    title: 'Shepherd Camp',
    subtitle: 'Camp Spot',
    imagePath: AppImages.image1,
    top: 0.30,
    left: 0.50,
    checkpointImage: AppImages.image1,
    distance: '2.4 km',
    estimatedTime: '52 min',
  );

  @override
  void onInit() {
    super.onInit();
    selectedMarker.value = defaultCheckpoint;
    currentCard.value = MapBottomCardType.selectedCheckpoint;
  }

  void changeChipIndex(int index) {
    selectedChipIndex.value = index;
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
    selectedMarker.value = defaultCheckpoint;
    currentCard.value = MapBottomCardType.selectedCheckpoint;
  }

  void onUnlockFullAccess() {
    selectedMarker.value = shepherdCamp;
    currentCard.value = MapBottomCardType.campDetail;
  }

  void onViewStageGuide() {
    currentCard.value = MapBottomCardType.stageGuide;
  }

  void onCloseCampDetail() {
    currentCard.value = MapBottomCardType.none;
  }

  void onCloseStageGuide() {
    currentCard.value = MapBottomCardType.none;
  }

  void onMapTap() {}

  void onSearchTap() {}

  void onLocationTap() {}

  void onDirectionTap() {}
}