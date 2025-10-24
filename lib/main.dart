import 'package:coursely/core/constants/app_font.dart';
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.backGroundColor,
        inputDecorationTheme: InputDecorationTheme(
          prefixIconColor: AppColors.darkgrey.withValues(alpha: 0.3),
          suffixIconColor: AppColors.darkgrey.withValues(alpha: 0.3),
          hintStyle: TextStyle(
            color: AppColors.darkgrey.withValues(alpha: 0.3),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(width: 1, color: AppColors.borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(width: 1, color: AppColors.borderColor),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(width: 1, color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(width: 1, color: Colors.red),
          ),
          filled: true,
          fillColor: AppColors.backGroundColor,
        ),
        fontFamily: AppFont.poppins,
      ),
      routerConfig: Routes.routes,
    );
  }
}
