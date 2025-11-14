import 'package:bloc/bloc.dart';
import '../../data/models/course.dart';
import '../../data/repo/course_repository.dart';

part 'courses_state.dart';

class CoursesCubit extends Cubit<CoursesState> {
  final CourseRepository repository;

  CoursesCubit(this.repository) : super(const CoursesState.initial());

  Future<void> fetchCourses() async {
    try {
      emit(const CoursesState.loading());
      final courses = await repository.fetchAllCourses();
      emit(CoursesState.success(courses));
    } catch (e) {
      emit(CoursesState.failure(e.toString()));
    }
  }
}
