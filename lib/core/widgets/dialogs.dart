import 'package:flutter/material.dart';

showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const Center(child: CircularProgressIndicator()),
  );}