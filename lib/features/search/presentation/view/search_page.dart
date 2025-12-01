import 'package:coursely/core/constants/navigation.dart';
import 'package:coursely/core/utils/app_colors.dart';
import 'package:coursely/core/utils/text_styles.dart';
import 'package:coursely/core/widgets/course_widget.dart';
import 'package:coursely/core/widgets/custom_container.dart';
import 'package:coursely/core/widgets/custom_text_field.dart';
import 'package:coursely/core/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coursely/features/search/presentation/cubit/search_cubit.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(() {
      final q = _controller.text.trim();
      context.read<SearchCubit>().search(q);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            // Refresh search if there's a query
            final q = _controller.text.trim();
            if (q.isNotEmpty) {
              await context.read<SearchCubit>().search(q);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Icon(Icons.dark_mode),
                ),
                Gap(20),
                CustomTextFormField(
                  hintText: "product Design",
                  preffixIcon: Icon(Icons.search),

                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // search action
                      IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          final q = _controller.text.trim();
                          context.read<SearchCubit>().search(q);
                        },
                      ),
                      Gap(8),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          _controller.clear();
                          context.read<SearchCubit>().search('');
                        },
                      ),
                      Gap(8),
                      IconButton(
                        icon: Icon(Icons.filter_alt_outlined),
                        onPressed: () {
                          showModalBottomSheet(
                            backgroundColor: AppColors.backGroundColor,
                            context: context,
                            isScrollControlled: true,
                            builder: (_) {
                              return CustomButtonSheet();
                            },
                          );
                        },
                      ),
                      Gap(8),
                    ],
                  ),

                  controller: _controller,
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
                  child: BlocBuilder<SearchCubit, SearchState>(
                    builder: (context, state) {
                      if (state.status == SearchStatus.loading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state.status == SearchStatus.failure) {
                        return Center(child: Text('Error: ${state.error}'));
                      }
                      if (state.results.isEmpty) {
                        return Center(child: Text('No results'));
                      }
                      return ListView.separated(
                        itemCount: state.results.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, i) {
                          final c = state.results[i];
                          return CourseWidget(
                            title: c.title,
                            imageUrl: c.imageUrl,
                            price: c.price,
                            heroTag: c.id,
                          );
                        },
                      );
                    },
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

class CustomButtonSheet extends StatefulWidget {
  const CustomButtonSheet({super.key});

  @override
  State<CustomButtonSheet> createState() => _CustomButtonSheetState();
}

class _CustomButtonSheetState extends State<CustomButtonSheet> {
  double x = 0;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigation.pop(context);
                    },
                    icon: Icon(Icons.close),
                  ),
                  Spacer(flex: 1),
                  Text("Search Filter", style: TextStyles.textStyle18),
                  Spacer(flex: 1),
                ],
              ),
              Text("Categories", style: TextStyles.textStyle14),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomElevatetButton(
                    title: "Design",
                    toDo: () {
                      print("mohamed");
                    },
                  ),
                  CustomElevatetButton(
                    title: "Painting",
                    toDo: () {
                      print("hossam");
                    },
                  ),
                  CustomElevatetButton(
                    title: "Coding",

                    toDo: () {
                      print("hossam");
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomElevatetButton(
                    title: "Music",
                    toDo: () {
                      print("mohamed");
                    },
                  ),
                  CustomElevatetButton(
                    title: "Visual Identiy",
                    toDo: () {
                      print("hossam");
                    },
                  ),
                  CustomElevatetButton(
                    title: "Mathimatics",

                    toDo: () {
                      print("hossam");
                    },
                  ),
                ],
              ),
              Gap(20),

              Text("price", style: TextStyles.textStyle16),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 4,
                  activeTrackColor: AppColors.primaryColor,
                  inactiveTrackColor: AppColors.primaryColor.withOpacity(0.15),
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 12,
                  ),
                  overlayShape: const RoundSliderOverlayShape(
                    overlayRadius: 22,
                  ),
                  valueIndicatorColor: AppColors.primaryColor,
                  valueIndicatorTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RangeSlider(
                      min: x,
                      max: 1000,
                      values: RangeValues(x, 1000),
                      divisions: ((1000 - x) ~/ 10).clamp(1, 100),
                      labels: RangeLabels(
                        '\$${x.round()}',
                        '\$${1000.round()}',
                      ),
                      onChanged: (r) {
                        x = r.start;
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 6),
                  ],
                ),
              ),

              Text("Duration", style: TextStyles.textStyle14),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomElevatetButton(
                    title: "3-8 Hours",
                    toDo: () {
                      print("mohamed");
                    },
                  ),
                  CustomElevatetButton(
                    title: "8-14 Hours",
                    toDo: () {
                      print("hossam");
                    },
                  ),
                  CustomElevatetButton(
                    title: "14-20 Hours",

                    toDo: () {
                      print("hossam");
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomElevatetButton(
                    title: "20-24 Hours",
                    toDo: () {
                      print("mohamed");
                    },
                  ),
                  CustomElevatetButton(
                    title: "24-30 Hours",
                    toDo: () {
                      print("hossam");
                    },
                  ),
                ],
              ),
              Gap(20),

              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: MainButton(
                      height: 50,
                      bgColor: AppColors.backGroundColor,
                      borderColor: AppColors.primaryColor,
                      textColor: AppColors.primaryColor,
                      text: "Clear",
                      onPressed: () {},
                    ),
                  ),
                  Gap(10),
                  Expanded(
                    flex: 2,
                    child: MainButton(
                      height: 50,
                      text: "Apply Filter",
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomElevatetButton extends StatefulWidget {
  final String title;
  final Function toDo;

  const CustomElevatetButton({
    super.key,
    required this.toDo,
    required this.title,
  });

  @override
  State<CustomElevatetButton> createState() => _CustomElevatetButtonState();
}

class _CustomElevatetButtonState extends State<CustomElevatetButton> {
  bool isenable = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 12, 0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),

          backgroundColor: isenable
              ? AppColors.primaryColor
              : AppColors.backGroundColor,
        ),

        onPressed: () {
          isenable = !isenable;

          if (isenable) {
            widget.toDo();
          }
          setState(() {});
        },

        child: Text(
          widget.title,
          style: TextStyles.textStyle12.copyWith(
            color: isenable ? AppColors.backGroundColor : AppColors.gryColor,
          ),
        ),
      ),
    );
  }
}
