import 'package:coursely/core/utils/app_colors.dart';
import 'package:coursely/core/widgets/course_widget.dart';
import 'package:coursely/features/course/data/repo/course_repository.dart';
import 'package:coursely/features/my_courses/presentation/cubit/my_courses_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyCoursesScreen extends StatelessWidget {
  const MyCoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyCoursesCubit(CourseRepository())
        ..loadEnrolledCourses(FirebaseAuth.instance.currentUser?.uid ?? ''),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'My Courses',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocBuilder<MyCoursesCubit, MyCoursesState>(
          builder: (context, state) {
            if (state.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.error != null) {
              return Center(child: Text('Error: ${state.error}'));
            }
            if (state.courses.isEmpty) {
              return const Center(child: Text('You are not enrolled in any courses yet.'));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.courses.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final course = state.courses[index];
                return CourseWidget(
                  title: course.title,
                  imageUrl: course.imageUrl,
                  price: course.price,
                  heroTag: 'my_course_${course.id}',
                  courseId: course.id,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
