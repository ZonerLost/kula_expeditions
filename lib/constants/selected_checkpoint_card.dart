import 'package:flutter/material.dart';
import 'package:kuala_exp/extension/context_extension.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../modules/map/model/map_marker_model.dart';

class SelectedCheckpointCard extends StatefulWidget {
  final MapMarkerModel marker;
  final VoidCallback onClose;
  final String? liveDistance;
  final String? liveEta;
  final MapMarkerModel? poiMarker;
  final VoidCallback? onClosePoi;

  const SelectedCheckpointCard({
    super.key,
    required this.marker,
    required this.onClose,
    this.liveDistance,
    this.liveEta,
    this.poiMarker,
    this.onClosePoi,
  });

  @override
  State<SelectedCheckpointCard> createState() => _SelectedCheckpointCardState();
}

class _SelectedCheckpointCardState extends State<SelectedCheckpointCard> {
  bool _expanded = true;

  @override
  void didUpdateWidget(SelectedCheckpointCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Collapse checkpoint when a POI is shown
    if (widget.poiMarker != null && oldWidget.poiMarker == null) {
      setState(() => _expanded = false);
    }
    // Re-expand when POI is closed
    if (widget.poiMarker == null && oldWidget.poiMarker != null) {
      setState(() => _expanded = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final distance = widget.liveDistance?.isNotEmpty == true
        ? widget.liveDistance!
        : widget.marker.distance;
    final eta = widget.liveEta?.isNotEmpty == true
        ? widget.liveEta!
        : widget.marker.estimatedTime;

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
          boxShadow: [
            BoxShadow(
              color: Color(0x18000000),
              blurRadius: 12,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── POI overlay ──────────────────────────────────────────────
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: widget.poiMarker != null
                  ? _PoiOverlay(
                      poi: widget.poiMarker!,
                      onClose: widget.onClosePoi ?? () {},
                    )
                  : const SizedBox.shrink(),
            ),

            // ── Checkpoint section ───────────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(
                context.screenWidth * 0.05,
                context.screenHeight * 0.015,
                context.screenWidth * 0.05,
                context.screenHeight * 0.02,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header — always visible
                  GestureDetector(
                    onTap: () => setState(() => _expanded = !_expanded),
                    behavior: HitTestBehavior.opaque,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Next Checkpoint:',
                            style: AppTextStyles.title.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Icon(
                          _expanded
                              ? Icons.keyboard_arrow_down
                              : Icons.keyboard_arrow_up,
                          size: 22,
                          color: AppColors.black,
                        ),
                        SizedBox(width: context.screenWidth * 0.02),
                        // GestureDetector(
                        //   onTap: widget.onClose,
                        //   child: const Icon(Icons.close, size: 18, color: AppColors.black),
                        // ),
                      ],
                    ),
                  ),
                  // Collapsible details
                  AnimatedSize(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    child: _expanded
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: context.screenHeight * 0.012),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppColors.lightBorder,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image(
                                        image: widget.marker.imageUrl.isNotEmpty
                                            ? NetworkImage(
                                                widget.marker.imageUrl,
                                              )
                                            : AssetImage(
                                                    widget
                                                        .marker
                                                        .checkpointImage,
                                                  )
                                                  as ImageProvider,
                                        width: context.screenWidth * 0.13,
                                        height: context.screenWidth * 0.13,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(width: context.screenWidth * 0.03),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.marker.title,
                                            style: AppTextStyles.body.copyWith(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.black,
                                              height: 1.2,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'Distance: $distance',
                                            style: AppTextStyles.small.copyWith(
                                              fontSize: 11,
                                              color: AppColors.greyText,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'ETA: $eta',
                                            style: AppTextStyles.small.copyWith(
                                              fontSize: 11,
                                              color: AppColors.greyText,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PoiOverlay extends StatelessWidget {
  final MapMarkerModel poi;
  final VoidCallback onClose;

  const _PoiOverlay({required this.poi, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        context.screenWidth * 0.05,
        context.screenHeight * 0.015,
        context.screenWidth * 0.05,
        context.screenHeight * 0.012,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
        border: Border(bottom: BorderSide(color: AppColors.lightBorder)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image(
              image: poi.imageUrl.isNotEmpty
                  ? NetworkImage(poi.imageUrl)
                  : AssetImage(poi.checkpointImage) as ImageProvider,
              width: context.screenWidth * 0.13,
              height: context.screenWidth * 0.13,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: context.screenWidth * 0.03),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  poi.title,
                  style: AppTextStyles.body.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                    height: 1.2,
                  ),
                ),
                if (poi.subtitle.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    poi.subtitle,
                    style: AppTextStyles.small.copyWith(
                      fontSize: 11,
                      color: AppColors.greyText,
                    ),
                  ),
                ],
                const SizedBox(height: 2),
                Text(
                  'Distance: ${poi.distance}',
                  style: AppTextStyles.small.copyWith(
                    fontSize: 11,
                    color: AppColors.greyText,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'ETA: ${poi.estimatedTime}',
                  style: AppTextStyles.small.copyWith(
                    fontSize: 11,
                    color: AppColors.greyText,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onClose,
            child: const Icon(Icons.close, size: 18, color: AppColors.black),
          ),
        ],
      ),
    );
  }
}
