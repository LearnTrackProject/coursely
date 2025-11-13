import 'package:coursely/core/utils/app_colors.dart';
import 'package:coursely/core/utils/text_styles.dart';
import 'package:flutter/material.dart';

class CustomRichText extends StatelessWidget {
  final String text1;
  final String text2;
  const CustomRichText({super.key, required this.text1, required this.text2});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: text1,
            style: TextStyles.textStyle20.copyWith(color: Colors.black),
          ),
          TextSpan(
            text: text2,
            style: TextStyles.textStyle18.copyWith(color: AppColors.darkgrey),
          ),
        ],
      ),
    );
  }
}
