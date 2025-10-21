import 'package:coursely/core/constants/app_font.dart';
import 'package:coursely/core/constants/routes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Coursely());
}

class Coursely extends StatelessWidget {
  const Coursely({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: AppFont.poppins),
      routerConfig: Routes.routes,
    );
  }
}
