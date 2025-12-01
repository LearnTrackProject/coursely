import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../message/data/message_repository.dart';
import '../../../message/data/models/announcement.dart';
import '../../../course/data/repo/course_repository.dart';
import '../../../course/data/models/course.dart';

class MessagesState {
  final List<Announcement> announcements;
  final bool loading;
  final bool isInstructor;
  final List<Course> instructorCourses;
  final String? error;

  MessagesState({
    this.announcements = const [],
    this.loading = false,
    this.isInstructor = false,
    this.instructorCourses = const [],
    this.error,
  });

  MessagesState copyWith({
    List<Announcement>? announcements,
    bool? loading,
    bool? isInstructor,
    List<Course>? instructorCourses,
    String? error,
  }) {
    return MessagesState(
      announcements: announcements ?? this.announcements,
      loading: loading ?? this.loading,
      isInstructor: isInstructor ?? this.isInstructor,
      instructorCourses: instructorCourses ?? this.instructorCourses,
      error: error ?? this.error,
    );
  }
}

class MessagesCubit extends Cubit<MessagesState> {
  final MessageRepository repository;
  final CourseRepository courseRepository;

  MessagesCubit(this.repository, this.courseRepository)
    : super(MessagesState());

  Future<void> loadMessages() async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
      if (uid.isEmpty) {
        emit(state.copyWith(loading: false, announcements: []));
        return;
      }
      final isInst = await repository.isInstructor(uid);
      List<Course> instCourses = [];
      if (isInst) {
        instCourses = await courseRepository.fetchCoursesByInstructor(uid);
      }

      // Fetch notifications instead of announcements
      final anns = await repository.fetchNotifications(uid);

      emit(
        state.copyWith(
          loading: false,
          announcements: anns,
          isInstructor: isInst,
          instructorCourses: instCourses,
        ),
      );
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> sendAnnouncement({
    required String courseId,
    required String title,
    required String body,
    String? videoUrl,
  }) async {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (uid.isEmpty) return;
    emit(state.copyWith(loading: true));
    try {
      await repository.sendAnnouncement(
        instructorId: uid,
        courseId: courseId,
        title: title,
        body: body,
        videoUrl: videoUrl,
      );
      await loadMessages();
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }
}
