import 'package:bloc/bloc.dart';
import '../../../course/data/models/course.dart';
import '../../../course/data/repo/course_repository.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final CourseRepository repository;

  SearchCubit(this.repository) : super(const SearchState());

  Future<void> search(String q) async {
    final query = q.trim();
    if (query.isEmpty) {
      emit(state.copyWith(query: '', results: []));
      return;
    }
    emit(state.copyWith(status: SearchStatus.loading, query: query));
    try {
      final res = await repository.searchCourses(query);
      emit(state.copyWith(status: SearchStatus.success, results: res));
    } catch (e) {
      emit(state.copyWith(status: SearchStatus.failure, error: e.toString()));
    }
  }
}
