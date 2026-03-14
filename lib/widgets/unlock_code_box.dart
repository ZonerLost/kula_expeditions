import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';

class UnlockCodeBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;

  const UnlockCodeBox({
    super.key,
    required this.controller,
    this.focusNode,
    this.nextFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        maxLength: 4,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.text,
        style: AppTextStyles.body.copyWith(
          fontSize: 16,
          color: AppColors.black,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          counterText: "",
          hintText: "XXXX",
          hintStyle: AppTextStyles.body.copyWith(
            fontSize: 14,
            color: AppColors.greyText,
          ),
          filled: true,
          fillColor: AppColors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.lightBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.lightBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.lightBorder),
          ),
        ),
        onChanged: (value) {
          if (value.length == 4 && nextFocusNode != null) {
            FocusScope.of(context).requestFocus(nextFocusNode);
          }
        },
      ),
    );
  }
}