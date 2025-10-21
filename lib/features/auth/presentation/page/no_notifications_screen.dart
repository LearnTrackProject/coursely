import 'package:coursely/core/constants/app_images.dart';
import 'package:coursely/core/utils/app_colors.dart';
import 'package:coursely/core/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_svg/svg.dart';

class NoNotificationsScreen extends StatelessWidget {
  const NoNotificationsScreen({super.key});

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
              
              child: Image.asset(AppImages.nonotifcations),
            ),
            Gap(35),
            Text("No Notifictations yet!",
            style: TextStyles.textStyle16.copyWith(color: AppColors.secondaryColor,fontFamily: "Poppins",fontWeight: FontWeight.w500)),
            
            Text("We’ll nofify you once we have ",
            style: TextStyles.textStyle12.copyWith(color: AppColors.borderColor,fontFamily: "Poppins", fontWeight: FontWeight.w400)),
            Text("something for you",
            style: TextStyles.textStyle12.copyWith(color: AppColors.borderColor,fontFamily: "Poppins", fontWeight: FontWeight.w400)),
            Spacer(flex: 2,),
          ],
        ),
      ),
    );
  }
}

