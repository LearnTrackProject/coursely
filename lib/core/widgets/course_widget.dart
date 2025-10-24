import 'package:coursely/core/constants/app_images.dart';
import 'package:coursely/core/utils/app_colors.dart';
import 'package:coursely/core/utils/text_styles.dart';
import 'package:coursely/core/widgets/custom_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CourseWidget extends StatelessWidget {
  const CourseWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, right: 5, left: 5),
      child: CustomContainer(
        height: 80,
        boxShadow: [
          BoxShadow(
            color: AppColors.darkgrey.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: Offset(0, 9),
            spreadRadius: 2,
          ),
        ],
        color: AppColors.backGroundColor,

        child: ListTile(
          onTap: () {},

          leading: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.asset(AppImages.image6),
          ),
          title: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Product Design v1.0", style: TextStyles.textStyle14),
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.person_fill,
                      color: AppColors.gryColor,
                      size: 15,
                    ),

                    Text(
                      "Robertson Connie",
                      style: TextStyles.textStyle12.copyWith(
                        color: AppColors.gryColor,
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    Text(
                      "\$190",
                      style: TextStyles.textStyle16.copyWith(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Gap(10),
                    CustomContainer(
                      padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                      color: AppColors.orange.withValues(alpha: 0.2),
                      child: Text(
                        "16 hours",
                        style: TextStyles.textStyle12.copyWith(
                          color: AppColors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CourseTypeWidget extends StatelessWidget {
  final String image1;
  final String image2;
  final Color color;

  const CourseTypeWidget({
    super.key,
    required this.media,
    required this.image1,
    required this.image2,
    required this.color,
  });

  final Size media;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      boxShadow: [
        BoxShadow(
          color: AppColors.darkgrey.withValues(alpha: 0.1),
          blurRadius: 20,
          offset: Offset(0, 9),
          spreadRadius: 2,
        ),
      ],
      width: 160,
      color: color,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            // height: 140,
            // width: 140,
            bottom: 0,
            left: -5,
            child: Image.asset(image1),
          ),
          Positioned(right: 0, bottom: 5, child: Image.asset(image2)),
        ],
      ),
    );
  }
}
