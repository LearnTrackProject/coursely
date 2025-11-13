
import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
 final Widget? child;
final  double? width;
 final double? height;
 final Color? color;
 final List<BoxShadow>? boxShadow;
 final EdgeInsetsGeometry? padding;
  const CustomContainer({
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
