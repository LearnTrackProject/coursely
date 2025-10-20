import 'package:coursely/core/utils/app_font.dart';
import 'package:coursely/core/constants/routes.dart';
import 'package:coursely/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Coursely());
}

class Coursely extends StatelessWidget {
  const Coursely({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: Routes.routes,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.backGroundColor,
        appBarTheme: AppBarTheme(
          surfaceTintColor: Colors.transparent,
          backgroundColor: AppColors.backGroundColor,
        ),
        fontFamily: AppFont.poppins,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: AppColors.secondaryColor),
        ),
      ),
    );
  }
}
