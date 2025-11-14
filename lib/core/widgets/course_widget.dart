import 'package:coursely/core/constants/app_images.dart';
import 'package:coursely/core/utils/app_colors.dart';
import 'package:coursely/core/utils/text_styles.dart';
import 'package:coursely/core/widgets/custom_container.dart';
import 'package:coursely/features/course_details/screens/course_detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CourseWidget extends StatelessWidget {
  final String? title;
  final String? imageUrl;
  final double? price;
  final String? heroTag;
  final String? courseId;

  const CourseWidget({
    super.key,
    this.title,
    this.imageUrl,
    this.price,
    this.heroTag,
    this.courseId,
  });

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
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CourseDetailScreen(
                  title: title ?? 'Course',
                  imageUrl: imageUrl,
                  price: price,
                  heroTag: heroTag ?? title ?? 'course_image',
                  courseId: courseId,
                ),
              ),
            );
          },

          leading: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: (imageUrl != null && imageUrl!.startsWith('http'))
                ? Image.network(
                    imageUrl!,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    imageUrl ?? AppImages.image6,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
          ),
          title: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title ?? "Product Design v1.0",
                  style: TextStyles.textStyle14,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      CupertinoIcons.person_fill,
                      color: AppColors.gryColor,
                      size: 15,
                    ),
                    Gap(4),
                    Expanded(
                      child: Text(
                        "Robertson Connie",
                        style: TextStyles.textStyle12.copyWith(
                          color: AppColors.gryColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        price != null
                            ? "\$${price!.toStringAsFixed(0)}"
                            : "\$190",
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
