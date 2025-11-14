import 'package:bloc/bloc.dart';
import '../../../course/data/models/course.dart';
import '../../../course/data/repo/course_repository.dart';

class HomeState {
  final List<Course> featured;
  final List<Course> enrolled;
  final bool loading;
  final bool enrolledLoading;
  final String? error;

  HomeState({
    this.featured = const [],
    this.enrolled = const [],
    this.loading = false,
    this.enrolledLoading = false,
    this.error,
  });

  HomeState copyWith({
    List<Course>? featured,
    List<Course>? enrolled,
    bool? loading,
    bool? enrolledLoading,
    String? error,
  }) {
    return HomeState(
      featured: featured ?? this.featured,
      enrolled: enrolled ?? this.enrolled,
      loading: loading ?? this.loading,
      enrolledLoading: enrolledLoading ?? this.enrolledLoading,
      error: error ?? this.error,
    );
  }
}

class HomeCubit extends Cubit<HomeState> {
  final CourseRepository repository;

  HomeCubit(this.repository) : super(HomeState());

  Future<void> loadFeatured({int limit = 4}) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final data = await repository.fetchFeatured(limit: limit);
      emit(state.copyWith(featured: data, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> loadEnrolledForUser(String uid) async {
    if (uid.isEmpty) return;
    emit(state.copyWith(enrolledLoading: true));
    try {
      final courses = await repository.fetchEnrolledCoursesForUser(uid);
      emit(state.copyWith(enrolled: courses, enrolledLoading: false));
    } catch (e) {
      emit(state.copyWith(enrolledLoading: false, error: e.toString()));
    }
  }
}
