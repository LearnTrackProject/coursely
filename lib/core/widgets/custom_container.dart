import 'package:coursely/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  Widget? child;
  double? width;
  double? height;
  Color? color;
  List<BoxShadow>? boxShadow;
  EdgeInsetsGeometry? padding;
  CustomContainer({
    super.key,
    this.padding,

    this.boxShadow,
    this.color,
    this.child,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,

      padding: padding,
      width: width,
      decoration: BoxDecoration(
        boxShadow: boxShadow,
        color: color,

        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }
}
