import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:coursely/core/utils/app_colors.dart';
import 'package:coursely/core/utils/text_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:coursely/core/constants/navigation.dart';
import 'package:coursely/core/constants/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../cubit/instructor_cubit.dart';

class InstructorDashboard extends StatefulWidget {
  const InstructorDashboard({super.key});

  @override
  State<InstructorDashboard> createState() => _InstructorDashboardState();
}

class _InstructorDashboardState extends State<InstructorDashboard> {
  late final TextEditingController _nameController;
  late final TextEditingController _bioController;
  late final TextEditingController _courseTitle;
  late final TextEditingController _coursePrice;
  late final TextEditingController _courseCategory;
  late final TextEditingController _courseImageUrl;
  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _bioController = TextEditingController();
    _courseTitle = TextEditingController();
    _coursePrice = TextEditingController();
    _courseCategory = TextEditingController();
    _courseImageUrl = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InstructorCubit>().loadInstructorProfile();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _courseTitle.dispose();
    _coursePrice.dispose();
    _courseCategory.dispose();
    _courseImageUrl.dispose();
    super.dispose();
  }

  void _showAddCourseDialog() {
    _courseTitle.clear();
    _coursePrice.clear();
    _courseCategory.clear();
    _courseImageUrl.clear();

    // Save the cubit reference before showing dialog
    final cubit = context.read<InstructorCubit>();

    final List<TextEditingController> linkControllers = [];

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add New Course'),
        content: SingleChildScrollView(
          child: StatefulBuilder(
            builder: (context, setState) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _courseTitle,
                  decoration: InputDecoration(
                    labelText: 'Course Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                Gap(12),
                TextField(
                  controller: _coursePrice,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Price (\$)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                Gap(12),
                TextField(
                  controller: _courseCategory,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintText: 'e.g., Programming, Design',
                  ),
                ),
                Gap(12),
                TextField(
                  controller: _courseImageUrl,
                  decoration: InputDecoration(
                    labelText: 'Image URL (optional)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintText: 'https://example.com/image.jpg',
                  ),
                ),
                Gap(20),
                Divider(),
                Gap(12),
                Text(
                  'Course Video Links',
                  style: TextStyles.textStyle14.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gap(12),
                ...List.generate(
                  linkControllers.length,
                  (index) => Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: linkControllers[index],
                              decoration: InputDecoration(
                                labelText: 'Link ${index + 1}',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 8,
                                ),
                              ),
                            ),
                          ),
                          Gap(8),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                linkControllers.removeAt(index);
                              });
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      Gap(8),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      linkControllers.add(TextEditingController());
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Link'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor.withValues(
                      alpha: 0.7,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_courseTitle.text.isEmpty ||
                  _coursePrice.text.isEmpty ||
                  _courseCategory.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please fill all required fields'),
                  ),
                );
                return;
              }

              final price = double.tryParse(_coursePrice.text);
              if (price == null) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Invalid price')));
                return;
              }

              // Collect video links
              final videoLinks = linkControllers
                  .where((controller) => controller.text.isNotEmpty)
                  .map((controller) => controller.text)
                  .toList();

              await cubit.addCourse(
                title: _courseTitle.text,
                price: price,
                category: _courseCategory.text,
                imageUrl: _courseImageUrl.text.isNotEmpty
                    ? _courseImageUrl.text
                    : null,
                videoLinks: videoLinks,
              );

              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Course added successfully')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
            ),
            child: const Text('Add Course'),
          ),
        ],
      ),
    );
  }

  void _showManageVideosDialog(String courseId) {
    final List<TextEditingController> titleControllers = [];
    final List<TextEditingController> urlControllers = [];

    titleControllers.add(TextEditingController());
    urlControllers.add(TextEditingController());

    // Save cubit reference before showing dialog
    final cubit = context.read<InstructorCubit>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Video Lessons'),
        content: SingleChildScrollView(
          child: StatefulBuilder(
            builder: (context, setState) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...List.generate(
                  titleControllers.length,
                  (index) => Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Lesson ${index + 1}',
                                  style: TextStyles.textStyle12,
                                ),
                                Gap(4),
                                TextField(
                                  controller: titleControllers[index],
                                  decoration: InputDecoration(
                                    labelText: 'Lesson Title',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                  ),
                                ),
                                Gap(8),
                                TextField(
                                  controller: urlControllers[index],
                                  decoration: InputDecoration(
                                    labelText: 'Video URL',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Gap(8),
                          IconButton(
                            onPressed: () {
                              if (titleControllers.length > 1) {
                                setState(() {
                                  titleControllers.removeAt(index);
                                  urlControllers.removeAt(index);
                                });
                              }
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      Gap(12),
                    ],
                  ),
                ),
                // Add more button
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      titleControllers.add(TextEditingController());
                      urlControllers.add(TextEditingController());
                    });
                  },
                  icon: Icon(Icons.add),
                  label: Text('Add Another Lesson'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor.withValues(
                      alpha: 0.7,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              // Collect all lessons
              final lessons = <Map<String, String>>[];
              for (int i = 0; i < titleControllers.length; i++) {
                if (titleControllers[i].text.isNotEmpty &&
                    urlControllers[i].text.isNotEmpty) {
                  lessons.add({
                    'title': titleControllers[i].text,
                    'videoUrl': urlControllers[i].text,
                  });
                }
              }

              if (lessons.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please add at least one lesson'),
                  ),
                );
                return;
              }

              await cubit.addLessonsToCourse(
                courseId: courseId,
                lessons: lessons,
              );

              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Lessons added successfully')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
            ),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
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
                          icon: const Icon(Icons.add, size: 18),
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
                                  'Price: \$${course.price?.toStringAsFixed(0) ?? "TBA"}',
                                  style: TextStyles.textStyle14.copyWith(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Gap(12),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      _showManageVideosDialog(course.id!);
                                    },
                                    icon: const Icon(Icons.edit, size: 16),
                                    label: const Text('Manage Videos'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primaryColor
                                          .withValues(alpha: 0.7),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                    ),
                                  ),
                                ),
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
