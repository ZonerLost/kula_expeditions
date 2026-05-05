import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_imges.dart';
import '../../../constants/app_text_styles.dart';
import '../../../extension/context_extension.dart';
import '../controller/stage_detail_controller.dart';

class StageDetailView extends GetView<StageDetailController> {
  const StageDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final stage = controller.stageDetail;

    return Scaffold(
      backgroundColor: const Color(0xFF4A4A4A),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.screenWidth * 0.04,
                  vertical: context.screenHeight * 0.012,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: Get.back,
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 18,
                        color: AppColors.white,
                      ),
                    ),
                    SizedBox(width: context.screenWidth * 0.02),
                    Expanded(
                      child: Text(
                        stage.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.title.copyWith(
                          fontSize: 16,
                          color: AppColors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: context.screenWidth * 0.04,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      stage.image,
                      width: double.infinity,
                      height: context.screenHeight * 0.23,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.screenWidth * 0.045,
                        vertical: context.screenHeight * 0.02,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  stage.title,
                                  style: AppTextStyles.title.copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.black,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: controller.openPdf,
                                child: SvgPicture.asset(
                                  AppImages.save_file,
                                  width: 18,
                                  height: 18,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: context.screenHeight * 0.01),
                          Text(
                            stage.subtitle,
                            style: AppTextStyles.body.copyWith(
                              fontSize: 13,
                              color: AppColors.greyText,
                              height: 1.35,
                            ),
                          ),
                          SizedBox(height: context.screenHeight * 0.025),

                          _InfoBlock(title: 'Distance:', value: stage.distance),
                          _InfoBlock(
                            title: 'Estimated Duration:',
                            value: stage.estimatedDuration,
                          ),
                          _InfoBlock(
                            title: 'Highest Point:',
                            value: stage.highestPoint,
                          ),

                          Text(
                            'Difficulty:',
                            style: AppTextStyles.title.copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.black,
                            ),
                          ),
                          SizedBox(height: context.screenHeight * 0.008),
                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 4,
                                backgroundColor: Color(0xFFF4C542),
                              ),
                              SizedBox(width: context.screenWidth * 0.02),
                              Text(
                                stage.difficulty,
                                style: AppTextStyles.body.copyWith(
                                  fontSize: 13,
                                  color: AppColors.black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: context.screenHeight * 0.025),

                          _SectionText(
                            title: 'What to Expect:',
                            content: stage.description,
                          ),
                          _SectionText(
                            title: 'Water & Camps:',
                            content: stage.waterAndCamps,
                          ),
                          _SectionText(
                            title: 'Important Notes:',
                            content: stage.importantNotes,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: context.screenHeight * 0.03),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoBlock extends StatelessWidget {
  final String title;
  final String value;

  const _InfoBlock({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.screenHeight * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.title.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
          SizedBox(height: context.screenHeight * 0.006),
          Text(
            value,
            style: AppTextStyles.body.copyWith(
              fontSize: 13,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionText extends StatelessWidget {
  final String title;
  final String content;

  const _SectionText({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.screenHeight * 0.022),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.title.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
          SizedBox(height: context.screenHeight * 0.008),
          Text(
            content,
            style: AppTextStyles.body.copyWith(
              fontSize: 13,
              color: AppColors.greyText,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}
