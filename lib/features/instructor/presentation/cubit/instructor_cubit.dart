import 'package:bloc/bloc.dart';
import '../../../course/data/models/course.dart';
import '../../../course/data/repo/course_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InstructorState {
  final String? name;
  final String? email;
  final String? bio;
  final List<Course> courses;
  final bool loading;
  final bool updating;
  final String? error;

  InstructorState({
    this.name,
    this.email,
    this.bio,
    this.courses = const [],
    this.loading = false,
    this.updating = false,
    this.error,
  });

  InstructorState copyWith({
    String? name,
    String? email,
    String? bio,
    List<Course>? courses,
    bool? loading,
    bool? updating,
    String? error,
  }) {
    return InstructorState(
      name: name ?? this.name,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      courses: courses ?? this.courses,
      loading: loading ?? this.loading,
      updating: updating ?? this.updating,
      error: error ?? this.error,
    );
  }
}

class InstructorCubit extends Cubit<InstructorState> {
  final CourseRepository courseRepository;
  final FirebaseFirestore firestore;

  InstructorCubit(this.courseRepository, {FirebaseFirestore? firestore})
    : firestore = firestore ?? FirebaseFirestore.instance,
      super(InstructorState());

  Future<void> loadInstructorProfile() async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
      if (uid.isEmpty) {
        emit(state.copyWith(loading: false, error: 'User not logged in'));
        return;
      }

      // Fetch instructor doc
      final instDoc = await firestore.collection('instructor').doc(uid).get();
      if (!instDoc.exists) {
        emit(
          state.copyWith(loading: false, error: 'Instructor profile not found'),
        );
        return;
      }

      final instData = instDoc.data();
      final name =
          instData?['name'] as String? ??
          FirebaseAuth.instance.currentUser?.displayName ??
          '';
      final email =
          instData?['email'] as String? ??
          FirebaseAuth.instance.currentUser?.email ??
          '';
      final bio = instData?['bio'] as String? ?? '';

      // Fetch instructor courses
      final courses = await courseRepository.fetchCoursesByInstructor(uid);

      emit(
        state.copyWith(
          loading: false,
          name: name,
          email: email,
          bio: bio,
          courses: courses,
        ),
      );
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> updateProfile({String? name, String? bio}) async {
    emit(state.copyWith(updating: true, error: null));
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
      if (uid.isEmpty) return;

      final updates = <String, dynamic>{};
      if (name != null && name.isNotEmpty) {
        updates['name'] = name;
        await FirebaseAuth.instance.currentUser?.updateDisplayName(name);
      }
      if (bio != null) {
        updates['bio'] = bio;
      }

      if (updates.isNotEmpty) {
        await firestore.collection('instructor').doc(uid).update(updates);
      }

      emit(
        state.copyWith(
          updating: false,
          name: name ?? state.name,
          bio: bio ?? state.bio,
        ),
      );
    } catch (e) {
      emit(state.copyWith(updating: false, error: e.toString()));
    }
  }


}
