import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/map_floating_buttons.dart';
import '../../../constants/map_search_bar.dart';
import '../../../constants/selected_checkpoint_card.dart';
import '../../../modules/onboarding/model/map_package_model.dart';
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
              child: MapWidget(
                key: const ValueKey('mapbox_map'),
                onMapCreated: (map) => controller.onMapCreated(map),
                onMapIdleListener: (_) => controller.onMapIdle(),
                onCameraChangeListener: controller.onCameraChanged,
                styleUri: MapPackageModel.styleUrl,
                viewport: CameraViewportState(
                  center: Point(coordinates: Position(19.9, 42.7)),
                  zoom: 8.0,
                ),
                gestureRecognizers: const {},
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.03,
              left: MediaQuery.of(context).size.width * 0.06,
              right: MediaQuery.of(context).size.width * 0.06,
              child: Obx(
                () => Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MapSearchBar(
                      onChanged: controller.onSearchChanged,
                      suggestions: controller.searchSuggestions.toList(),
                      onSuggestionTap: controller.onSuggestionSelected,
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04,
                      child: Obx(
                        () => SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(controller.chips.length, (
                              index,
                            ) {
                              final isSelected =
                                  controller.selectedChipIndex.value == index;
                              return Padding(
                                padding: EdgeInsets.only(
                                  right: index < controller.chips.length - 1
                                      ? 8
                                      : 0,
                                ),
                                child: GestureDetector(
                                  onTap: () =>
                                      controller.changeChipIndex(index),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal:
                                          MediaQuery.of(context).size.width *
                                          0.035,
                                      vertical:
                                          MediaQuery.of(context).size.height *
                                          0.008,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.black
                                          : AppColors.chipBg,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: isSelected
                                            ? AppColors.black
                                            : AppColors.chipBorder,
                                      ),
                                    ),
                                    child: Text(
                                      controller.chips[index],
                                      style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                            0.03,
                                        fontWeight: FontWeight.w500,
                                        color: isSelected
                                            ? AppColors.white
                                            : AppColors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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
                  return StageGuideCard(onClose: controller.onCloseStageGuide);

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
