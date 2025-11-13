import 'package:coursely/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomCirclarProgress extends StatelessWidget {
  final double? value;
  const CustomCirclarProgress({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      value: value,
      color: AppColors.darkgrey,
      backgroundColor: Colors.grey.withValues(alpha: 0.2),
      constraints: BoxConstraints(minHeight: 20, minWidth: 20),
    );
  }
}
