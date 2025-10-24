import 'package:coursely/core/utils/app_colors.dart';
import 'package:coursely/core/utils/text_styles.dart';
import 'package:coursely/core/widgets/course_widget.dart';
import 'package:coursely/core/widgets/custom_container.dart';
import 'package:coursely/core/widgets/custom_text_field.dart';
import 'package:coursely/core/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Icon(Icons.dark_mode),
              ),
              Gap(20),
              CustomTextFormField(
                hintText: "product Desin",
                preffixIcon: Icon(Icons.search),

                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.close),
                    Gap(20),
                    Icon(Icons.filter_alt_outlined),
                    Gap(20),
                  ],
                ),

                controller: TextEditingController(text: "product design"),
              ),
              Gap(17),
              Row(
                children: [
                  ...[
                    {"title": "visual identity", "flex": 2},
                    {"title": "painting", "flex": 1},
                    {"title": "coding", "flex": 1},
                    {"title": "Writing", "flex": 1},
                  ].map(
                    (json) => Expanded(
                      flex: json["flex"] as int,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: CustomContainer(
                          height: 40,
                          color: AppColors.textformfill,
                          child: Center(
                            child: Text(
                              json["title"] as String,
                              style: TextStyles.textStyle12.copyWith(
                                color: AppColors.darkgrey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Gap(17),

              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "Results",
                  style: TextStyles.textStyle20.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              Expanded(
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, i) => CourseWidget(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
