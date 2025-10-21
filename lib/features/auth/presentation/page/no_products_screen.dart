import 'package:coursely/core/constants/app_images.dart';
import 'package:coursely/core/utils/app_colors.dart';
import 'package:coursely/core/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_svg/svg.dart';

class NoProductsScreen extends StatelessWidget {
  const NoProductsScreen({super.key});

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
              
              child: Image.asset(AppImages.noproducts),
            ),
            Gap(35),
            Text("No products",
            style: TextStyles.textStyle16.copyWith(color: AppColors.secondaryColor,fontFamily: "Poppins",fontWeight: FontWeight.w500)),
            
            Text("You don't have any products yet!",
            style: TextStyles.textStyle12.copyWith(color: AppColors.borderColor,fontFamily: "Poppins", fontWeight: FontWeight.w400)),
            Spacer(flex: 2,),
          ],
        ),
      ),
    );
    }
    }