part of 'search_cubit.dart';

enum SearchStatus { initial, loading, success, failure }

class SearchState {
  final SearchStatus status;
  final String query;
  final List<Course> results;
  final String? error;

  const SearchState({
    this.status = SearchStatus.initial,
    this.query = '',
    this.results = const [],
    this.error,
  });

  SearchState copyWith({
    SearchStatus? status,
    String? query,
    List<Course>? results,
    String? error,
  }) {
    return SearchState(
      status: status ?? this.status,
      query: query ?? this.query,
      results: results ?? this.results,
      error: error ?? this.error,
    );
  }
}
