part of 'courses_cubit.dart';

enum CoursesStatus { initial, loading, success, failure }

class CoursesState {
  final CoursesStatus status;
  final List<Course> courses;
  final String? errorMessage;

  const CoursesState._({
    required this.status,
    this.courses = const [],
    this.errorMessage,
  });

  const CoursesState.initial() : this._(status: CoursesStatus.initial);
  const CoursesState.loading() : this._(status: CoursesStatus.loading);
  const CoursesState.success(List<Course> courses)
    : this._(status: CoursesStatus.success, courses: courses);
  const CoursesState.failure(String message)
    : this._(status: CoursesStatus.failure, errorMessage: message);
}
