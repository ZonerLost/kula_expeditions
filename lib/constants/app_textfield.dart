// app_textfield.dart

import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class AppTextField extends StatelessWidget {
  final String title;
  final TextEditingController controller;

  final Widget? suffix;
  final VoidCallback? onTap;
  final bool readOnly;
  final TextInputType? keyboardType;

  const AppTextField({
    super.key,
    required this.title,
    required this.controller,
    this.suffix,
    this.onTap,
    this.readOnly = false,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// Title
        Text(
          title,
          style: AppTextStyles.title.copyWith(
            fontSize: 14,
          ),
        ),

        const SizedBox(height: 6),

        /// Input
        TextField(
          controller: controller,
          readOnly: readOnly,
          keyboardType: keyboardType,
          onTap: onTap,

          style: AppTextStyles.body.copyWith(
            fontSize: 13,
            color: AppColors.black,
          ),

          decoration: InputDecoration(

            suffixIcon: suffix,

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 14,
            ),

            filled: true,
            fillColor: AppColors.white,

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                color: Color(0xffdcdcdc),
              ),
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                color: Color(0xffdcdcdc),
              ),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                color: Color(0xffdcdcdc),
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }
}