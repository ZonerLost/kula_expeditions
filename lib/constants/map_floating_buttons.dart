import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kuala_exp/extension/context_extension.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_imges.dart';

class MapFloatingButtons extends StatelessWidget {
  final VoidCallback onLocationTap;
  final VoidCallback onDirectionTap;

  const MapFloatingButtons({
    super.key,
    required this.onLocationTap,
    required this.onDirectionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Positioned(
        //   bottom: context.screenHeight * 0.14,
        //   left: context.screenWidth * 0.39,
        //   child: GestureDetector(
        //     onTap: onLocationTap,
        //     child: Container(
        //       width: context.screenWidth * 0.16,
        //       height: context.screenWidth * 0.16,
        //       decoration: const BoxDecoration(
        //         color: AppColors.floatingButtonBg,
        //         shape: BoxShape.circle,
        //       ),
        //       child: Center(
        //         child: SvgPicture.asset(
        //           AppImages.pinPoint,
        //           height: context.screenWidth * 0.06,
        //           width: context.screenWidth * 0.06,
        //           colorFilter: const ColorFilter.mode(
        //             AppColors.floatingButtonIcon,
        //             BlendMode.srcIn,
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        Positioned(
          right: context.screenWidth * 0.04,
          bottom: context.screenHeight * 0.07,
          child: Column(
            children: [
              // GestureDetector(
              //   onTap: onDirectionTap,
              //   child: Container(
              //     width: context.screenWidth * 0.08,
              //     height: context.screenWidth * 0.08,
              //     decoration: const BoxDecoration(
              //       color: AppColors.white,
              //       shape: BoxShape.circle,
              //       boxShadow: [
              //         BoxShadow(
              //           color: Color(0x14000000),
              //           blurRadius: 8,
              //           offset: Offset(0, 2),
              //         ),
              //       ],
              //     ),
              //     child: Center(
              //       child: Image.asset(
              //         AppImages.orangeNavigator,
              //         height: 14,
              //         width: 14,
              //         fit: BoxFit.contain,
              //       ),
              //     ),
              //   ),
              // ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: onLocationTap,
                child: Container(
                  width: context.screenWidth * 0.10,
                  height: context.screenWidth * 0.10,
                  decoration: const BoxDecoration(
                    color: AppColors.floatingButtonBg,

                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      AppImages.pinPoint,
                      height: 18,
                      width: 18,
                      colorFilter: const ColorFilter.mode(
                        AppColors.floatingButtonIcon,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
