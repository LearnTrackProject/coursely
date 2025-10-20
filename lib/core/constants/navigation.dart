import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Navigation {
  static pushReplacementNamed(
    BuildContext context,
    String screenPage, [
    Object? extra,
  ]) {
    context.pushReplacement(screenPage);
  }

  static pushNamedTo(
    BuildContext context,
    String screenPage, [
    Object? extra,

    // Future<dynamic> Function(Object?)? onset, .then(onset!)
  ]) {
    context.push(screenPage, extra: extra);
  }

  static pushNamedandRemoveUntilTo(
    BuildContext context,
    String screenPage, [
    Object? extra,
  ]) {
    context.go(screenPage, extra: extra);
  }

  static pop(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    }
  }
}
