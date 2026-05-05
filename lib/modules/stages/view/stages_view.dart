import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_colors.dart';
import '../../../extension/context_extension.dart';
import '../../../widgets/stage_item_card.dart';
import '../../../widgets/stages_header.dart';
import '../controller/stages_controller.dart';

class StagesView extends GetView<StagesController> {
  const StagesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.screenWidth * 0.045,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: context.screenHeight * 0.012),
              const StagesHeader(),
              SizedBox(height: context.screenHeight * 0.02),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ListView.separated(
                    itemCount: controller.stages.length,
                    separatorBuilder: (_, __) =>
                        SizedBox(height: context.screenHeight * 0.014),
                    itemBuilder: (context, index) {
                      final stage = controller.stages[index];
                      return StageItemCard(
                        stage: stage,
                        onTap: () => controller.onStageTap(stage),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}