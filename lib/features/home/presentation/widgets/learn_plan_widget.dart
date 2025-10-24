import 'package:coursely/core/utils/text_styles.dart';
import 'package:coursely/core/widgets/custom_circlar_progress.dart';
import 'package:coursely/features/home/presentation/page/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';

import '../../../../core/widgets/custom_rich_text.dart';

class LearnPlanWidget extends StatelessWidget {
  final String titleCourse;
  final double courseValue;
  final String grade;
  final String total;
  const LearnPlanWidget({
    super.key,
    required this.titleCourse,
    required this.grade,
    required this.total,
    required this.courseValue,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomCirclarProgress(value: courseValue),
        Gap(10),
        Text(
          titleCourse,
          style: TextStyles.textStyle14.copyWith(fontWeight: FontWeight.w500),
        ),
        Spacer(),
        CustomRichText(text1: grade, text2: "/ $total"),
      ],
    );
  }
}
