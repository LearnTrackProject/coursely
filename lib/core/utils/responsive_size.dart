import 'package:flutter/material.dart';

class ResponsiveSize {
  /// Get responsive icon size based on screen width
  /// Small screens (< 360): base size
  /// Medium screens (360-600): base * 1.1
  /// Large screens (> 600): base * 1.2
  static double getIconSize(BuildContext context, {double baseSize = 24}) {
    final width = MediaQuery.of(context).size.width;

    if (width < 360) {
      return baseSize * 0.9;
    } else if (width < 600) {
      return baseSize;
    } else if (width < 900) {
      return baseSize * 1.1;
    } else {
      return baseSize * 1.2;
    }
  }

  /// Get responsive font size based on screen width
  static double getFontSize(BuildContext context, {double baseSize = 14}) {
    final width = MediaQuery.of(context).size.width;

    if (width < 360) {
      return baseSize * 0.9;
    } else if (width < 600) {
      return baseSize;
    } else if (width < 900) {
      return baseSize * 1.05;
    } else {
      return baseSize * 1.1;
    }
  }

  /// Get responsive padding based on screen width
  static double getPadding(BuildContext context, {double basePadding = 16}) {
    final width = MediaQuery.of(context).size.width;

    if (width < 360) {
      return basePadding * 0.8;
    } else if (width < 600) {
      return basePadding;
    } else if (width < 900) {
      return basePadding * 1.2;
    } else {
      return basePadding * 1.5;
    }
  }
}
