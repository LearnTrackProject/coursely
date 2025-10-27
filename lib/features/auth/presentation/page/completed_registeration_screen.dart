import 'package:coursely/core/constants/app_images.dart';
import 'package:coursely/core/constants/navigation.dart';
import 'package:coursely/core/constants/routes.dart';
import 'package:coursely/core/utils/app_colors.dart';
import 'package:coursely/core/utils/text_styles.dart';
import 'package:coursely/core/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

class CompletedRegisterationScreen extends StatelessWidget {
  const CompletedRegisterationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkgrey,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(15),
            ),
            backgroundColor: AppColors.backGroundColor,
            elevation: 16,
            child: Container(
              padding: EdgeInsets.only(
                right: 16,
                left: 16,
                top: 48,
                bottom: 36,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(AppImages.rightSvg, width: 64),
                  Gap(19),
                  Text(
                    'Success',
                    style: TextStyles.textStyle16.copyWith(
                      color: AppColors.secondaryColor,
                    ),
                  ),
                  Gap(9),
                  Text(
                    'Congratulations, you have\ncompleted your registration!',
                    style: TextStyles.textStyle12.copyWith(
                      color: AppColors.gryColor,
                    ),
                  ),
                  Gap(15),
                  MainButton(
                    text: 'Done',
                    onPressed: () {
                      Navigation.pushNamedandRemoveUntilTo(
                        context,
                        Routes.mainScreen,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
