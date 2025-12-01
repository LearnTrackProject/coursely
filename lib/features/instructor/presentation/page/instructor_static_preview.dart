import 'package:coursely/core/utils/text_styles.dart';
import 'package:coursely/core/utils/app_colors.dart';
import 'package:coursely/core/utils/responsive_size.dart';
import 'package:flutter/material.dart';

class InstructorStaticPreview extends StatelessWidget {
  const InstructorStaticPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instructor Preview'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 36,
                  backgroundImage: AssetImage(
                    'assets/images/avatar_placeholder.png',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Dr. Ahmed Hossam', style: TextStyles.textStyle18),
                      SizedBox(height: 6),
                      Text(
                        'Senior Flutter Instructor • 12 courses',
                        style: TextStyles.textStyle12,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text('My Courses', style: TextStyles.textStyle16),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: [
                  _courseCard(
                    'Flutter for Beginners',
                    'assets/images/course_placeholder.png',
                    120,
                    context,
                  ),
                  _courseCard(
                    'Advanced State Management',
                    'assets/images/course_placeholder.png',
                    180,
                    context,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _courseCard(
    String title,
    String image,
    int price,
    BuildContext context,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(image, width: 96, height: 56, fit: BoxFit.cover),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyles.textStyle14.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '\$price EGP',
                        style: TextStyles.textStyle12.copyWith(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.more_vert),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              children: [
                _lessonChip('Intro', context),
                _lessonChip('Widgets', context),
                _lessonChip('State Management', context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _lessonChip(String title, BuildContext context) {
    return Chip(
      label: Text(title),
      avatar: Icon(
        Icons.play_arrow,
        size: ResponsiveSize.getIconSize(context, baseSize: 16),
      ),
    );
  }
}
