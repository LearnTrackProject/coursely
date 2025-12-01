import 'package:bloc/bloc.dart';
import 'package:coursely/features/course/data/models/course.dart';
import 'package:coursely/features/course/data/repo/course_repository.dart';

class MyCoursesState {
  final bool loading;
  final List<Course> courses;
  final String? error;

  MyCoursesState({
    this.loading = false,
    this.courses = const [],
    this.error,
  });

  MyCoursesState copyWith({
    bool? loading,
    List<Course>? courses,
    String? error,
  }) {
    return MyCoursesState(
      loading: loading ?? this.loading,
      courses: courses ?? this.courses,
      error: error,
    );
  }
}

class MyCoursesCubit extends Cubit<MyCoursesState> {
  final CourseRepository repository;

  MyCoursesCubit(this.repository) : super(MyCoursesState());

  Future<void> loadEnrolledCourses(String uid) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final courses = await repository.fetchEnrolledCoursesForUser(uid);
      emit(state.copyWith(loading: false, courses: courses));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }
}
