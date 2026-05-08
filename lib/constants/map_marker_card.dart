import 'package:flutter/material.dart';
import 'package:kuala_exp/extension/context_extension.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../modules/map/model/map_marker_model.dart';

class MapMarkerCard extends StatelessWidget {
  final MapMarkerModel marker;
  final VoidCallback onTap;

  const MapMarkerCard({super.key, required this.marker, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: marker.top - (context.screenHeight * 0.015),
      left: marker.left - (context.screenWidth * 0.08),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          constraints: BoxConstraints(maxWidth: context.screenWidth * 0.30),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 10,
                backgroundColor: Colors.transparent,
                backgroundImage: marker.imageUrl.isNotEmpty
                    ? NetworkImage(marker.imageUrl)
                    : AssetImage(marker.imagePath) as ImageProvider,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      marker.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.small.copyWith(
                        fontSize: context.screenWidth * 0.022,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),
                    if (marker.subtitle.isNotEmpty)
                      Text(
                        marker.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.small.copyWith(
                          fontSize: context.screenWidth * 0.019,
                          color: AppColors.greyText,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
