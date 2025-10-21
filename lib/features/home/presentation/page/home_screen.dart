import 'package:coursely/core/constants/app_images.dart';
import 'package:coursely/core/utils/app_colors.dart';
import 'package:coursely/core/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              color: AppColors.primaryColor,
              height: 150,
              width: double.infinity,
            ),
            Positioned(
              top: 50,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hi, Kristin",
                    style: TextStyles.textStyle24.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.backGroundColor,
                    ),
                  ),
                  Text(
                    "let's start learning",
                    style: TextStyles.textStyle14.copyWith(
                      fontWeight: FontWeight.w400,
                      color: AppColors.backGroundColor,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 20,
              top: 50,
              child: Image.asset(AppImages.avatarImage),
            ),
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Gap(95),
                  Container(
                    padding: EdgeInsets.all(15),
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.backGroundColor,
                      border: Border.all(
                        color: AppColors.gryColor.withValues(alpha: 0.5),
                      ),

                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Learned today",
                              style: TextStyles.textStyle12.copyWith(
                                color: AppColors.gryColor,
                              ),
                            ),
                            Text(
                              "My courses",
                              style: TextStyles.textStyle12.copyWith(
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ],
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "46min",
                                style: TextStyles.textStyle24.copyWith(
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: "/60min",
                                style: TextStyles.textStyle14.copyWith(
                                  color: AppColors.darkgrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Gap(10),
                        LinearProgressIndicator(
                          value: 0.5,

                          valueColor: AlwaysStoppedAnimation(AppColors.orange),
                        ),
                      ],
                    ),
                  ),
                  Gap(20),

                  SizedBox(
                    width: double.infinity,
                    height: 150,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [HomeWidget(), Gap(20), HomeWidget()],
                    ),
                  ),
                ],
              ),
            ),
            // position,
          ],
        ),
      ),
    );
  }
}

class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      height: 150,

      decoration: BoxDecoration(
        color: Color(0xffCDECFE),

        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 10,
            top: 0,
            child: Image.asset(AppImages.onboarding1, height: 120, width: 120),
          ),
          Text(
            "what do you want to learn today",
            style: TextStyles.textStyle18.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          Positioned(
            left: 10,
            bottom: 10,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.fromLTRB(15, 18, 15, 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(10),
                ),
                backgroundColor: AppColors.orange,
                foregroundColor: AppColors.backGroundColor,
              ),
              onPressed: () {},
              child: Text(
                "Get Started",
                style: TextStyles.textStyle16.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
