import 'package:coursely/core/constants/app_images.dart';
import 'package:coursely/core/utils/app_colors.dart';
import 'package:coursely/core/utils/text_styles.dart';
import 'package:coursely/features/auth/presentation/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_svg/svg.dart';

class NoNetworkScreen extends StatefulWidget {
  const NoNetworkScreen({super.key});

  @override
  State<NoNetworkScreen> createState() => _NoNetworkScreenState();
}

class _NoNetworkScreenState extends State<NoNetworkScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: SvgPicture.asset(AppImages.lefteyeSvg),
            )
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(flex: 1,),
            Container(
              
              child: Image.asset(AppImages.nonetwork),
            ),
            Gap(35),
            Text("No Network!",
            style: TextStyles.textStyle16.copyWith(color: AppColors.secondaryColor,fontFamily: "Poppins",fontWeight: FontWeight.w500)),
            
            Text("Please check your internet",
            style: TextStyles.textStyle12.copyWith(color: AppColors.borderColor,fontFamily: "Poppins", fontWeight: FontWeight.w400)),
            Text("connection and try again",
            style: TextStyles.textStyle12.copyWith(color: AppColors.borderColor,fontFamily: "Poppins", fontWeight: FontWeight.w400)),
            Gap(23),
            MainButton(text: "Try again",
            onPressed: (){}),
            Spacer(flex: 2,),
          ],
        ),
      ),
    );
  }
}