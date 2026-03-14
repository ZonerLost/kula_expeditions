import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color? color;
  final EdgeInsetsGeometry? margin;
  final Color? borderColor;

  const AppButton({
    super.key,
    required this.text,
    required this.onTap,
    this.color,
    this.margin,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: double.infinity,
      height: 44,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? AppColors.buttonGreen,
          foregroundColor: AppColors.black,
          elevation: 0,
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(
              color: borderColor ?? Colors.transparent,
            ),
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: AppTextStyles.button.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
            height: 1.0,
          ),
        ),
      ),
    );
  }
}