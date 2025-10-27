import 'package:flutter/material.dart';
import 'package:coursely/core/utils/app_colors.dart';

class PriceRangeSlider extends StatelessWidget {
  final double min;
  final double max;
  final RangeValues values;
  final ValueChanged<RangeValues> onChanged;

  const PriceRangeSlider({
    super.key,
    required this.min,
    required this.max,
    required this.values,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final divisions = ((max - min) ~/ 10).clamp(1, 100);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RangeSlider(
          min: min,
          max: max,
          values: values,
          divisions: divisions,
          labels: RangeLabels(
            '\$${values.start.round()}',
            '\$${values.end.round()}',
          ),
          onChanged: onChanged,
          activeColor: AppColors.primaryColor,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '\$${values.start.round()}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            Text(
              '\$${values.end.round()}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }
}
