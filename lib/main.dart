import 'package:coursely/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Coursely());
}

class Coursely extends StatelessWidget {
  const Coursely({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.backGroundColor,
        appBarTheme: AppBarTheme(
        backgroundColor: AppColors.backGroundColor,),),
    );
  }
}
