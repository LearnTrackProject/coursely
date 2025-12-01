import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coursely/features/course/data/models/course.dart';
import 'package:coursely/features/course/data/repo/course_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:coursely/features/message/data/message_repository.dart';

class CourseDetailsState {
  final bool loading;
  final Course? course;
  final bool isEnrolled;
  final bool enrolling;
  final String? error;

  CourseDetailsState({
    this.loading = false,
    this.course,
    this.isEnrolled = false,
    this.enrolling = false,
    this.error,
  });

  CourseDetailsState copyWith({
    bool? loading,
    Course? course,
    bool? isEnrolled,
    bool? enrolling,
    String? error,
  }) {
    return CourseDetailsState(
      loading: loading ?? this.loading,
      course: course ?? this.course,
      isEnrolled: isEnrolled ?? this.isEnrolled,
      enrolling: enrolling ?? this.enrolling,
      error: error,
    );
  }
}

class CourseDetailsCubit extends Cubit<CourseDetailsState> {
  final CourseRepository courseRepository;
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  CourseDetailsCubit({
    required this.courseRepository,
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  }) : firestore = firestore ?? FirebaseFirestore.instance,
       auth = auth ?? FirebaseAuth.instance,
       super(CourseDetailsState());

  Future<void> loadCourseDetails(String courseId) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      // 1. Fetch Course
      final course = await courseRepository.fetchCourseById(courseId);
      if (course == null) {
        emit(state.copyWith(loading: false, error: 'Course not found'));
        return;
      }

      // 2. Check Enrollment
      bool isEnrolled = false;
      final uid = auth.currentUser?.uid;
      if (uid != null) {
        final doc = await firestore.collection('student').doc(uid).get();
        if (doc.exists && doc.data()?['enrolledCourses'] is List) {
          final enrolledCourses = doc.data()!['enrolledCourses'] as List;
          isEnrolled = enrolledCourses.contains(courseId);
        }
      }

      emit(
        state.copyWith(loading: false, course: course, isEnrolled: isEnrolled),
      );
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> enrollInCourse() async {
    if (state.course == null) return;
    emit(state.copyWith(enrolling: true, error: null));
    try {
      final uid = auth.currentUser?.uid;
      if (uid == null) {
        emit(state.copyWith(enrolling: false, error: 'Please login first'));
        return;
      }

      // Add to student's enrolledCourses
      await firestore.collection('student').doc(uid).set({
        'enrolledCourses': FieldValue.arrayUnion([state.course!.id]),
      }, SetOptions(merge: true));

      // Send notification
      await MessageRepository().sendNotification(
        userId: uid,
        title: 'Course Enrollment',
        body: 'You have successfully enrolled in ${state.course!.title}',
        courseId: state.course!.id,
      );

      emit(state.copyWith(enrolling: false, isEnrolled: true));
    } catch (e) {
      emit(state.copyWith(enrolling: false, error: e.toString()));
    }
  }
}
