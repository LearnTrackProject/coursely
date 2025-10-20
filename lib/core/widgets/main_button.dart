
import 'package:coursely/core/utils/app_colors.dart';
import 'package:coursely/core/utils/text_styles.dart';
import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  const MainButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width = double.infinity,
    this.height = 50,
    this.bgColor = AppColors.primaryColor,
    this.borderColor,
    this.textColor = AppColors.backGroundColor,
  });

  final String text;
  final Function() onPressed;
  final double width;
  final double height;
  final Color bgColor;
  final Color textColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyles.textStyle16.copyWith(color: textColor),
        ),
      ),
    );
  }
}
