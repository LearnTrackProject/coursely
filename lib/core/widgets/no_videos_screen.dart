import 'package:coursely/core/constants/app_images.dart';
import 'package:coursely/core/utils/app_colors.dart';
import 'package:coursely/core/utils/text_styles.dart';
import 'package:coursely/core/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_svg/svg.dart';

class NoVideosScreen extends StatefulWidget {
  const NoVideosScreen({super.key});

  @override
  State<NoVideosScreen> createState() => _NoVideosScreenState();
}

class _NoVideosScreenState extends State<NoVideosScreen> {
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
              child: SvgPicture.asset(AppImages.facebookSvg),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(flex: 1),
            Container(child: Image.asset(AppImages.novideos)),
            Gap(30),
            Text(
              "No videos!",
              style: TextStyles.textStyle16.copyWith(
                color: AppColors.secondaryColor,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w500,
              ),
            ),

            Text(
              "Here is no video you want at the",
              style: TextStyles.textStyle12.copyWith(
                color: AppColors.borderColor,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              "moment",
              style: TextStyles.textStyle12.copyWith(
                color: AppColors.borderColor,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w400,
              ),
            ),
            Gap(23),
            MainButton(text: "Search more", onPressed: () {}),
            Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
