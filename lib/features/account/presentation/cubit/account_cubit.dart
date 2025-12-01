import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coursely/features/auth/data/student.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AccountState {
  final Student? student;
  final bool loading;
  final String? error;

  AccountState({this.student, this.loading = false, this.error});

  AccountState copyWith({Student? student, bool? loading, String? error}) {
    return AccountState(
      student: student ?? this.student,
      loading: loading ?? this.loading,
      error: error ?? this.error,
    );
  }
}

class AccountCubit extends Cubit<AccountState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AccountCubit() : super(AccountState()) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    emit(state.copyWith(loading: true));
    try {
      final uid = _auth.currentUser?.uid;
      if (uid != null) {
        final doc = await _firestore.collection('student').doc(uid).get();
        if (doc.exists) {
          final student = Student.fromJson(doc.data()!);
          emit(state.copyWith(student: student, loading: false));
        } else {
          emit(state.copyWith(loading: false, error: "Profile not found"));
        }
      } else {
        emit(state.copyWith(loading: false, error: "User not logged in"));
      }
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> updateProfile({
    String? name,
    String? profession,
    String? bio,
    String? phone,
    File? imageFile,
  }) async {
    emit(state.copyWith(loading: true));
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return;

      String? imageUrl;
      if (imageFile != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('profile_images')
            .child('$uid.jpg');
        await ref.putFile(imageFile);
        imageUrl = await ref.getDownloadURL();
      }

      final Map<String, dynamic> updates = {};
      if (name != null) updates['name'] = name;
      if (profession != null) updates['profession'] = profession;
      if (bio != null) updates['bio'] = bio;
      if (phone != null) updates['phone'] = phone;
      if (imageUrl != null) updates['image'] = imageUrl;

      await _firestore.collection('student').doc(uid).update(updates);

      // Update local state
      final currentStudent = state.student;
      if (currentStudent != null) {
        final updatedStudent = Student(
          uid: currentStudent.uid,
          email: currentStudent.email,
          userKind: currentStudent.userKind,
          enrolledCourses: currentStudent.enrolledCourses,
          name: name ?? currentStudent.name,
          profession: profession ?? currentStudent.profession,
          bio: bio ?? currentStudent.bio,
          phone: phone ?? currentStudent.phone,
          imageUrl: imageUrl ?? currentStudent.imageUrl,
          city: currentStudent.city,
          age: currentStudent.age,
          gender: currentStudent.gender,
        );
        emit(state.copyWith(student: updatedStudent, loading: false));
      } else {
        // Reload if state was empty
        await loadProfile();
      }
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }
}
