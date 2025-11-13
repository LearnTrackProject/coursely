import 'package:coursely/core/constants/app_images.dart';
import 'package:coursely/core/utils/app_colors.dart';
import 'package:coursely/core/utils/text_styles.dart';
import 'package:coursely/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/widgets/course_widget.dart';

class CoursePage extends StatelessWidget {
  const CoursePage({super.key});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return SafeArea(
      child: Scaffold(
        body: DefaultTabController(
          length: 3,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Course",
                      style: TextStyles.textStyle24.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Image.asset(AppImages.avatarImage),
                  ],
                ),
                Gap(17),
                CustomTextFormField(
                  suffixIcon: Icon(Icons.toggle_on_sharp),
                  preffixIcon: Icon(Icons.search),
                  hintText: "Find Course",
                  controller: TextEditingController(),
                ),
                Gap(40),
                Container(
                  clipBehavior: Clip.none,

                  width: double.infinity,
                  height: media.height * 0.09,
                  child: ListView(
                    clipBehavior: Clip.none,
                    scrollDirection: Axis.horizontal,
                    children: [
                      CourseTypeWidget(
                        media: media,
                        image1: AppImages.image4,
                        image2: AppImages.name5,
                        color: AppColors.lightBlue,
                      ),
                      Gap(20),
                      CourseTypeWidget(
                        media: media,
                        image1: AppImages.image5,
                        image2: AppImages.name4,
                        color: AppColors.softPink,
                      ),
                    ],
                  ),
                ),
                Gap(30),

                Text("Choice Your course", style: TextStyles.textStyle18),

                TabBar(
                  physics: NeverScrollableScrollPhysics(),

                  padding: EdgeInsets.only(
                    top: 10,
                    left: 0,
                    right: 40,
                    bottom: 10,
                  ),
                  automaticIndicatorColorAdjustment: false,
                  dividerHeight: 0,
                  indicatorPadding: EdgeInsets.all(8),

                  labelColor: AppColors.backGroundColor,
                  unselectedLabelColor: AppColors.gryColor,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: AppColors.primaryColor,
                  ),
                  tabs: [
                    Tab(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("All"),
                      ),
                    ),
                    Tab(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("Popular"),
                      ),
                    ),
                    Tab(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("News"),
                      ),
                    ),
                  ],
                ),

                Expanded(
                  child: TabBarView(
                    children: [
                      ListView.builder(
                        itemCount: 20,

                        itemBuilder: (context, index) {
                          return CourseWidget();
                        },
                      ),
                      ListView.builder(
                        itemCount: 20,

                        itemBuilder: (context, index) {
                          return CourseWidget();
                        },
                      ),
                      ListView.builder(
                        itemCount: 20,

                        itemBuilder: (context, index) {
                          return CourseWidget();
                        },
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
