import 'package:coursely/core/constants/app_images.dart';
import 'package:coursely/core/utils/app_colors.dart';
import 'package:coursely/core/utils/text_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coursely/features/home/presentation/cubit/home_cubit.dart';
import 'package:coursely/core/widgets/course_widget.dart';
import '../../../../core/widgets/custom_container.dart';
// import '../widgets/learn_plan_widget.dart';

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
      final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
      final homeCubit = context.read<HomeCubit>();
      // Load featured courses
      homeCubit.loadFeatured();
      // load enrolled courses for this user
      if (uid.isNotEmpty) {
        homeCubit.loadEnrolledForUser(uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            // Refresh featured courses and enrolled courses
            final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
            final homeCubit = context.read<HomeCubit>();
            await homeCubit.loadFeatured();
            if (uid.isNotEmpty) {
              await homeCubit.loadEnrolledForUser(uid);
            }
          },
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  color: AppColors.primaryColor,
                  height: media.height * 0.2,
                  width: double.infinity,
                ),
                Positioned(
                  top: media.height * 0.06,
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
                  top: media.height * 0.062,
                  child: Image.asset(AppImages.avatarImage),
                ),
                Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Gap(media.height * 0.12),
                      Container(
                        padding: EdgeInsets.all(15),
                        height: media.height * 0.13,
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
                                    color: AppColors.primaryColor,
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
                            Stack(
                              children: [
                                Container(
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: AppColors.gryColor.withValues(
                                      alpha: 0.2,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),

                                Container(
                                  width: media.width * progress,

                                  height: 8,
                                  decoration: BoxDecoration(
                                    gradient: AppColors.lightOrange,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Gap(20),
                      SizedBox(
                        width: double.infinity,
                        height: media.height * 0.18,
                        child: BlocBuilder<HomeCubit, HomeState>(
                          builder: (context, state) {
                            if (state.loading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (state.error != null) {
                              return Center(
                                child: Text('Error: ${state.error}'),
                              );
                            }
                            if (state.featured.isEmpty) {
                              return const Center(
                                child: Text('No featured courses'),
                              );
                            }

                            return ListView.separated(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.only(right: 12),
                              itemCount: state.featured.length,
                              separatorBuilder: (_, __) => const Gap(20),
                              itemBuilder: (context, index) {
                                final c = state.featured[index];
                                return SizedBox(
                                  width: media.width * 0.6,
                                  child: CourseWidget(
                                    title: c.title,
                                    imageUrl: c.imageUrl,
                                    price: c.price,
                                    heroTag: c.id,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      Gap(17),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Learning Plan",
                          style: TextStyles.textStyle18.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      Gap(12),

                      SizedBox(
                        height: media.height * 0.18,
                        child: BlocBuilder<HomeCubit, HomeState>(
                          builder: (context, state) {
                            if (state.enrolledLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (state.enrolled.isEmpty) {
                              return Center(
                                child: Text(
                                  'You are not enrolled yet',
                                  style: TextStyles.textStyle14.copyWith(
                                    color: AppColors.darkgrey,
                                  ),
                                ),
                              );
                            }

                            return ListView.separated(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.only(right: 12),
                              itemCount: state.enrolled.length,
                              separatorBuilder: (_, __) => const Gap(20),
                              itemBuilder: (context, index) {
                                final c = state.enrolled[index];
                                return SizedBox(
                                  width: media.width * 0.6,
                                  child: CourseWidget(
                                    title: c.title,
                                    imageUrl: c.imageUrl,
                                    price: c.price,
                                    heroTag: c.id,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      Gap(17),

                      CustomContainer(
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.darkgrey.withValues(alpha: 0.1),
                            blurRadius: 20,
                            offset: Offset(0, 9),
                            spreadRadius: 2,
                          ),
                        ],
                        width: double.infinity,
                        height: media.height * 0.15,
                        color: AppColors.lightPurple,
                        child: Stack(
                          children: [
                            Positioned(
                              right: 5,
                              top: media.height * 0.005,
                              child: Image.asset(
                                AppImages.image3,
                                height: 100,
                                width: 100,
                              ),
                            ),
                            Positioned(
                              left: 10,
                              top: media.height * 0.05,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Meetup",
                                    style: TextStyles.textStyle24.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.darkPurple,
                                    ),
                                  ),
                                  Text(
                                    "Off-line exchange of learning exeriance",
                                    style: TextStyles.textStyle14.copyWith(
                                      color: AppColors.darkPurple,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Gap(17),
                      CustomContainer(
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.darkgrey.withValues(alpha: 0.1),
                            blurRadius: 20,
                            offset: Offset(0, 9),
                            spreadRadius: 2,
                          ),
                        ],
                        width: double.infinity,
                        height: media.height * 0.15,
                        color: AppColors.lightSkyBlue,
                        child: Stack(
                          children: [
                            Positioned(
                              right: 10,
                              top: media.height * 0.001,
                              child: Image.asset(
                                AppImages.image1,
                                height: 100,
                                width: 100,
                              ),
                            ),
                            Positioned(
                              left: 10,
                              top: media.height * 0.05,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Join learners",
                                    style: TextStyles.textStyle24.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.secondaryColor,
                                    ),
                                  ),
                                  Text(
                                    "Share experiences and Grow together",
                                    style: TextStyles.textStyle14.copyWith(
                                      color: AppColors.darkgrey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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
