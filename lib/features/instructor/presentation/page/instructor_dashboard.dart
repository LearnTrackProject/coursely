import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:coursely/core/utils/app_colors.dart';
import 'package:coursely/core/utils/responsive_size.dart';
import 'package:coursely/core/utils/text_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:coursely/core/constants/navigation.dart';
import 'package:coursely/core/constants/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../cubit/instructor_cubit.dart';
import 'package:go_router/go_router.dart';

class InstructorDashboard extends StatefulWidget {
  const InstructorDashboard({super.key});

  @override
  State<InstructorDashboard> createState() => _InstructorDashboardState();
}

class _InstructorDashboardState extends State<InstructorDashboard> {
  late final TextEditingController _nameController;
  late final TextEditingController _bioController;
  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _bioController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InstructorCubit>().loadInstructorProfile();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _showAddCourseDialog() {
    context.push(Routes.addCourse).then((_) {
      // Refresh list after returning
      context.read<InstructorCubit>().loadInstructorProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InstructorCubit, InstructorState>(
      builder: (context, state) {
        if (state.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.error != null) {
          return Scaffold(body: Center(child: Text('Error: ${state.error}')));
        }

        // sync controllers with state
        if (_nameController.text.isEmpty && state.name != null) {
          _nameController.text = state.name!;
        }
        if (_bioController.text.isEmpty && state.bio != null) {
          _bioController.text = state.bio!;
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.primaryColor,
            title: const Text('Instructor Dashboard'),
            centerTitle: true,
            elevation: 0,
            actions: [
              IconButton(
                tooltip: 'Logout',
                onPressed: () async {
                  // Sign out and clear local prefs, then navigate to welcome
                  try {
                    await FirebaseAuth.instance.signOut();
                  } catch (_) {}
                  try {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove('is_logged_in');
                    await prefs.remove('user_kind');
                  } catch (_) {}
                  Navigation.pushNamedandRemoveUntilTo(context, Routes.welcome);
                },
                icon: const Icon(Icons.logout),
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Profile card
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.darkgrey.withValues(alpha: 0.1),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Profile Information',
                            style: TextStyles.textStyle18.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Gap(16),
                          if (!_isEditMode) ...[
                            Text(
                              'Name',
                              style: TextStyles.textStyle12.copyWith(
                                color: AppColors.gryColor,
                              ),
                            ),
                            Text(
                              state.name ?? 'N/A',
                              style: TextStyles.textStyle16.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Gap(12),
                            Text(
                              'Email',
                              style: TextStyles.textStyle12.copyWith(
                                color: AppColors.gryColor,
                              ),
                            ),
                            Text(
                              state.email ?? 'N/A',
                              style: TextStyles.textStyle16.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Gap(12),
                            Text(
                              'Bio',
                              style: TextStyles.textStyle12.copyWith(
                                color: AppColors.gryColor,
                              ),
                            ),
                            Text(
                              state.bio ?? 'No bio',
                              style: TextStyles.textStyle14.copyWith(
                                color: AppColors.darkgrey,
                              ),
                            ),
                            Gap(16),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  setState(() => _isEditMode = true);
                                },
                                icon: const Icon(Icons.edit),
                                label: const Text('Edit Profile'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor,
                                ),
                              ),
                            ),
                          ] else ...[
                            TextField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                labelText: 'Name',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            Gap(12),
                            TextField(
                              controller: _bioController,
                              maxLines: 3,
                              decoration: InputDecoration(
                                labelText: 'Bio',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            Gap(16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() => _isEditMode = false);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey,
                                  ),
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: state.updating
                                      ? null
                                      : () async {
                                          await context
                                              .read<InstructorCubit>()
                                              .updateProfile(
                                                name: _nameController.text,
                                                bio: _bioController.text,
                                              );
                                          setState(() => _isEditMode = false);
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryColor,
                                  ),
                                  child: state.updating
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.white,
                                                ),
                                          ),
                                        )
                                      : const Text('Save'),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    Gap(24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Your Courses (${state.courses.length})',
                          style: TextStyles.textStyle18.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _showAddCourseDialog,
                          icon: Icon(
                            Icons.add,
                            size: ResponsiveSize.getIconSize(
                              context,
                              baseSize: 18,
                            ),
                          ),
                          label: const Text('Add Course'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Gap(12),
                    if (state.courses.isEmpty)
                      Center(
                        child: Text(
                          'No courses yet',
                          style: TextStyles.textStyle14.copyWith(
                            color: AppColors.gryColor,
                          ),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.courses.length,
                        separatorBuilder: (_, __) => Gap(12),
                        itemBuilder: (context, index) {
                          final course = state.courses[index];
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.gryColor.withValues(
                                  alpha: 0.2,
                                ),
                              ),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  course.title,
                                  style: TextStyles.textStyle16.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Gap(8),
                                Text(
                                  '${course.lessons.length} lessons',
                                  style: TextStyles.textStyle12.copyWith(
                                    color: AppColors.gryColor,
                                  ),
                                ),
                                Gap(8),
                                Text(
                                  'Price: \$${course.price.toStringAsFixed(0) ?? "TBA"}',
                                  style: TextStyles.textStyle14.copyWith(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Gap(12),
                              ],
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
