import 'package:coursely/core/constants/app_images.dart';
import 'package:coursely/core/utils/app_colors.dart';
import 'package:coursely/core/utils/text_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coursely/features/home/presentation/cubit/home_cubit.dart';
import 'package:coursely/core/widgets/course_widget.dart';
import 'package:coursely/core/constants/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:coursely/core/cubit/theme_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double progress = 0.4;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final homeCubit = context.read<HomeCubit>();
    // Load all data
    await Future.wait([
      homeCubit.loadFeatured(),
      homeCubit.loadAllCourses(),
      if (uid.isNotEmpty) homeCubit.loadEnrolledForUser(uid),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: _loadData,
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,

                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  height: media.height * 0.1,
                  width: double.infinity,
                ),
                Positioned(
                  top: media.height * 0.01,
                  left: media.width * 0.06,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        FirebaseAuth.instance.currentUser?.displayName ?? "",
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
                  right: media.width * 0.05,
                  top: media.height * 0.02,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          context.read<ThemeCubit>().toggleTheme();
                        },
                        icon: Icon(
                          context.watch<ThemeCubit>().state == ThemeMode.dark
                              ? Icons.light_mode
                              : Icons.dark_mode,
                          color: AppColors.backGroundColor,
                        ),
                      ),
                      Image.asset(AppImages.avatarImage),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Gap(media.height * 0.02),
                      BlocBuilder<HomeCubit, HomeState>(
                        builder: (context, state) {
                          final lastEnrolled = state.enrolled.isNotEmpty
                              ? state.enrolled.first
                              : null;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Gap(media.height * 0.12),

                              // Last Enrolled / Welcome Card
                              Container(
                                padding: const EdgeInsets.all(15),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppColors.backGroundColor,
                                  border: Border.all(
                                    color: AppColors.gryColor.withValues(
                                      alpha: 0.5,
                                    ),
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: lastEnrolled != null
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Continue Learning",
                                            style: TextStyles.textStyle12
                                                .copyWith(
                                                  color: AppColors.primaryColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          const Gap(10),
                                          Row(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.network(
                                                  lastEnrolled.imageUrl,
                                                  width: 60,
                                                  height: 60,
                                                  fit: BoxFit.cover,
                                                  errorBuilder:
                                                      (
                                                        context,
                                                        error,
                                                        stackTrace,
                                                      ) => Image.asset(
                                                        AppImages.image6,
                                                        width: 60,
                                                        height: 60,
                                                        fit: BoxFit.cover,
                                                      ),
                                                ),
                                              ),
                                              const Gap(15),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      lastEnrolled.title,
                                                      style: TextStyles
                                                          .textStyle16
                                                          .copyWith(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    const Gap(5),
                                                    Text(
                                                      "Click to resume",
                                                      style: TextStyles
                                                          .textStyle12
                                                          .copyWith(
                                                            color: AppColors
                                                                .gryColor,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  context.push(
                                                    Routes.courseDetailScreen,
                                                    extra: {
                                                      'title':
                                                          lastEnrolled.title,
                                                      'imageUrl':
                                                          lastEnrolled.imageUrl,
                                                      'price':
                                                          lastEnrolled.price,
                                                      'heroTag':
                                                          lastEnrolled.id,
                                                      'courseId':
                                                          lastEnrolled.id,
                                                    },
                                                  );
                                                },
                                                icon: const Icon(
                                                  Icons.play_circle_fill,
                                                  color: AppColors.primaryColor,
                                                  size: 40,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Welcome to Coursely!",
                                            style: TextStyles.textStyle16
                                                .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          const Gap(5),
                                          Text(
                                            "Start your learning journey today.",
                                            style: TextStyles.textStyle14
                                                .copyWith(
                                                  color: AppColors.gryColor,
                                                ),
                                          ),
                                        ],
                                      ),
                              ),

                              const Gap(25),

                              // All Courses Section
                              Text(
                                "All Courses",
                                style: TextStyles.textStyle18.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Gap(15),
                              SizedBox(
                                height:
                                    240, // Increased height for vertical card layout
                                child: state.loading
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : state.allCourses.isEmpty
                                    ? const Center(
                                        child: Text("No courses available"),
                                      )
                                    : ListView.separated(
                                        scrollDirection: Axis.horizontal,
                                        padding: const EdgeInsets.only(
                                          right: 12,
                                          bottom: 10,
                                        ),
                                        itemCount: state.allCourses.length,
                                        separatorBuilder: (_, __) =>
                                            const Gap(15),
                                        itemBuilder: (context, index) {
                                          final c = state.allCourses[index];
                                          return SizedBox(
                                            width: 200, // Fixed width for card
                                            child: CourseWidget(
                                              title: c.title,
                                              imageUrl: c.imageUrl,
                                              price: c.price,
                                              heroTag: 'all_${c.id}',
                                              courseId: c.id,
                                            ),
                                          );
                                        },
                                      ),
                              ),

                              const Gap(10),

                              // Featured Section (Popular)
                              Text(
                                "Popular Courses",
                                style: TextStyles.textStyle18.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Gap(15),
                              SizedBox(
                                height: 240,
                                child: state.loading
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : state.featured.isEmpty
                                    ? const Center(
                                        child: Text('No featured courses'),
                                      )
                                    : ListView.separated(
                                        scrollDirection: Axis.horizontal,
                                        padding: const EdgeInsets.only(
                                          right: 12,
                                          bottom: 10,
                                        ),
                                        itemCount: state.featured.length,
                                        separatorBuilder: (_, __) =>
                                            const Gap(15),
                                        itemBuilder: (context, index) {
                                          final c = state.featured[index];
                                          return SizedBox(
                                            width: 200,
                                            child: CourseWidget(
                                              title: c.title,
                                              imageUrl: c.imageUrl,
                                              price: c.price,
                                              heroTag: 'feat_${c.id}',
                                              courseId: c.id,
                                            ),
                                          );
                                        },
                                      ),
                              ),

                              const Gap(10),

                              // Learning Plan (Enrolled)
                              Text(
                                "My Learning Plan",
                                style: TextStyles.textStyle18.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Gap(15),
                              SizedBox(
                                height: 240,
                                child: state.enrolledLoading
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : state.enrolled.isEmpty
                                    ? Center(
                                        child: Text(
                                          'You are not enrolled in any courses yet',
                                          style: TextStyles.textStyle14
                                              .copyWith(
                                                color: AppColors.darkgrey,
                                              ),
                                        ),
                                      )
                                    : ListView.separated(
                                        scrollDirection: Axis.horizontal,
                                        padding: const EdgeInsets.only(
                                          right: 12,
                                          bottom: 10,
                                        ),
                                        itemCount: state.enrolled.length,
                                        separatorBuilder: (_, __) =>
                                            const Gap(15),
                                        itemBuilder: (context, index) {
                                          final c = state.enrolled[index];
                                          return SizedBox(
                                            width: 200,
                                            child: CourseWidget(
                                              title: c.title,
                                              imageUrl: c.imageUrl,
                                              price: c.price,
                                              heroTag: 'enrolled_${c.id}',
                                              courseId: c.id,
                                            ),
                                          );
                                        },
                                      ),
                              ),

                              const Gap(20),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                // position,
              ],
            ),
          ),
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

      decoration: BoxDecoration(
        color: Color(0xffCDECFE),

        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 10,
            bottom: 10,
            child: Image.asset(AppImages.onboarding1, height: 100, width: 100),
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
