import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coursely/core/services/upload_service.dart';
import 'package:coursely/features/course/data/models/course.dart';
import 'package:coursely/features/course/data/models/lesson.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class AddCourseState {
  final bool loading;
  final String? error;
  final File? courseImage;
  final List<Lesson> lessons;
  final bool success;

  AddCourseState({
    this.loading = false,
    this.error,
    this.courseImage,
    this.lessons = const [],
    this.success = false,
  });

  AddCourseState copyWith({
    bool? loading,
    String? error,
    File? courseImage,
    List<Lesson>? lessons,
    bool? success,
  }) {
    return AddCourseState(
      loading: loading ?? this.loading,
      error: error,
      courseImage: courseImage ?? this.courseImage,
      lessons: lessons ?? this.lessons,
      success: success ?? this.success,
    );
  }
}

class AddCourseCubit extends Cubit<AddCourseState> {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  AddCourseCubit({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : firestore = firestore ?? FirebaseFirestore.instance,
      auth = auth ?? FirebaseAuth.instance,
      super(AddCourseState());

  Future<void> pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920, // Landscape preference
        maxHeight: 1080,
      );

      if (pickedFile != null) {
        emit(state.copyWith(courseImage: File(pickedFile.path)));
      }
    } catch (e) {
      emit(state.copyWith(error: 'Failed to pick image: $e'));
    }
  }

  void addLesson(Lesson lesson) {
    final updatedLessons = List<Lesson>.from(state.lessons)..add(lesson);
    emit(state.copyWith(lessons: updatedLessons));
  }

  void removeLesson(int index) {
    final updatedLessons = List<Lesson>.from(state.lessons)..removeAt(index);
    emit(state.copyWith(lessons: updatedLessons));
  }

  Future<void> submitCourse({
    required String title,
    required String description,
    required double price,
    required String category,
    required List<String> whatToLearn,
  }) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final user = auth.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      if (state.courseImage == null) {
        throw Exception('Please select a course image');
      }

      // 1. Upload Image to Cloudinary
      final imageUrl = await uploadImageToCloudinary(state.courseImage!);
      if (imageUrl == null) {
        throw Exception('Failed to upload image');
      }

      // 2. Create Course Object
      final courseRef = firestore.collection('courses').doc();
      final course = Course(
        id: courseRef.id,
        title: title,
        description: description,
        imageUrl: imageUrl,
        price: price,
        category: category,
        instructorId: user.uid,
        whatToLearn: whatToLearn,
        lessons: state.lessons,
      );

      // 3. Save to Firestore
      await courseRef.set(course.toMap());

      // 4. Update Instructor's course list (optional, but good for quick access)
      // Note: Ideally we just query courses by instructorId, but if we keep a list:
      await firestore.collection('instructor').doc(user.uid).update({
        'courses': FieldValue.arrayUnion([
          {'courseId': course.id, 'courseName': course.title},
        ]),
      });

      emit(state.copyWith(loading: false, success: true));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }
}
