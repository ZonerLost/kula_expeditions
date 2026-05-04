import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_imges.dart';
import '../../../constants/map_filter_chips.dart';
import '../../../constants/map_floating_buttons.dart';
import '../../../constants/map_marker_card.dart';
import '../../../constants/map_search_bar.dart';
import '../../../constants/selected_checkpoint_card.dart';
import '../../../widgets/locked_trail_card.dart';
import '../../../widgets/camp_detail_card.dart';
import '../../../widgets/stage_guide_card.dart';
import '../controller/map_screen_controller.dart';

class MapScreenView extends GetView<MapScreenController> {
  const MapScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: controller.onMapTap,
                child: Image.asset(
                  AppImages.onboardingMap,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.03,
              left: MediaQuery.of(context).size.width * 0.06,
              right: MediaQuery.of(context).size.width * 0.06,
              child: MapSearchBar(
                onTap: controller.onSearchTap,
              ),
            ),
            Obx(
                  () => MapFilterChips(
                chips: controller.chips,
                selectedIndex: controller.selectedChipIndex.value,
                onChipTap: controller.changeChipIndex,
              ),
            ),
            ...controller.markers.map(
                  (marker) => MapMarkerCard(
                marker: marker,
                onTap: () => controller.onMarkerTap(marker),
              ),
            ),
            MapFloatingButtons(
              onLocationTap: controller.onLocationTap,
              onDirectionTap: controller.onDirectionTap,
            ),
            Obx(() {
              switch (controller.currentCard.value) {
                case MapBottomCardType.lockedTrail:
                  return controller.lockedMarker.value == null
                      ? const SizedBox.shrink()
                      : LockedTrailCard(
                    marker: controller.lockedMarker.value!,
                    onClose: controller.onCloseLockedMarker,
                    onContinue: controller.onContinueMainTrail,
                    onUnlock: controller.onUnlockFullAccess,
                  );

                case MapBottomCardType.campDetail:
                  return controller.selectedMarker.value == null
                      ? const SizedBox.shrink()
                      : CampDetailCard(
                    marker: controller.selectedMarker.value!,
                    onClose: controller.onCloseCampDetail,
                    onViewStageGuide: controller.onViewStageGuide,
                  );

                case MapBottomCardType.stageGuide:
                  return StageGuideCard(
                    onClose: controller.onCloseStageGuide,
                  );

                case MapBottomCardType.selectedCheckpoint:
                  return controller.selectedMarker.value == null
                      ? const SizedBox.shrink()
                      : SelectedCheckpointCard(
                    marker: controller.selectedMarker.value!,
                    onClose: controller.onCloseSelectedCheckpoint,
                  );

                case MapBottomCardType.none:
                  return const SizedBox.shrink();
              }
            }),
          ],
        ),
      ),
    );
  }
}