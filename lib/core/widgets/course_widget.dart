import 'package:coursely/core/constants/app_images.dart';
import 'package:coursely/core/utils/app_colors.dart';
import 'package:coursely/core/utils/responsive_size.dart';
import 'package:coursely/core/utils/text_styles.dart';
import 'package:coursely/core/constants/routes.dart';
import 'package:coursely/core/widgets/custom_container.dart';
import 'package:coursely/features/course_details/screens/course_detail_screen.dart';
import 'package:go_router/go_router.dart';
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
    return GestureDetector(
      onTap: () {
        context.push(
          Routes.courseDetailScreen,
          extra: {
            'title': title ?? 'Course',
            'imageUrl': imageUrl,
            'price': price,
            'heroTag': heroTag ?? title ?? 'course_image',
            'courseId': courseId,
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.backGroundColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.darkgrey.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: (imageUrl != null && imageUrl!.startsWith('http'))
                  ? Image.network(
                      imageUrl!,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        AppImages.image6,
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Image.asset(
                      imageUrl ?? AppImages.image6,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title ?? "Course Title",
                      style: TextStyles.textStyle14.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Gap(6),
                    Row(
                      children: [
                        Icon(
                          CupertinoIcons.person_fill,
                          color: AppColors.gryColor,
                          size: ResponsiveSize.getIconSize(
                            context,
                            baseSize: 14,
                          ),
                        ),
                        const Gap(4),
                        Expanded(
                          child: Text(
                            "Instructor Name", // Placeholder, ideally passed in
                            style: TextStyles.textStyle12.copyWith(
                              color: AppColors.gryColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          price != null
                              ? "\$${price!.toStringAsFixed(0)}"
                              : "Free",
                          style: TextStyles.textStyle16.copyWith(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.orange.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            "16h", // Placeholder
                            style: TextStyles.textStyle12.copyWith(
                              fontSize: 10,
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
          ],
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
