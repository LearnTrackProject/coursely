import 'package:coursely/features/auth/data/models/instructor.dart';
import 'package:coursely/features/auth/data/models/user_type_enum.dart';
import 'package:coursely/features/auth/data/student.dart';
import 'package:coursely/features/auth/presentation/cubit/auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var userKind;

  Future<void> register({required UserTypeEnum userType}) async {
    try {
      emit(AuthLoadingState());

      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text,
          );
      User? user = credential.user;
      credential.user?.updateDisplayName(nameController.text);
      final uid = credential.user?.uid;
      if (userType == UserTypeEnum.student) {
        Student student = Student(
          name: user?.displayName,
          email: emailController.text,
          uid: uid,
          userKind: "student",
        );
        FirebaseFirestore.instance
            .collection("student")
            .doc(uid)
            .set(student.toJson());
      } else {
        Instructor instructor = Instructor(
          uid: uid,
          email: emailController.text,
          userKind: "instructor",
        );
        FirebaseFirestore.instance
            .collection("instructor")
            .doc(uid)
            .set(instructor.toJson());
      }
      emit(AuthSuccessState());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(AuthErrorState("The password provided is too weak."));
      } else if (e.code == 'email-already-in-use') {
        emit(AuthErrorState("The account already exists for that email."));
      } else {
        emit(AuthErrorState('error please try again'));
      }
    } catch (e) {
      emit(AuthErrorState("somethings error please try again later"));
    }
  }

  Future<void> login({required UserTypeEnum userType}) async {
    try {
      emit(AuthLoadingState());
      final cretential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      final user = cretential.user;

      final uid = user?.uid;
      if (userType == UserTypeEnum.student) {
        FirebaseAuth.instance.currentUser?.updatePhotoURL("student");
      } else {
        //using updatePhotoUrl as a role
        FirebaseAuth.instance.currentUser?.updatePhotoURL("instructor");
      }
      // persist login flag locally
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('is_logged_in', true);
        await prefs.setString(
          'user_kind',
          userType == UserTypeEnum.student ? 'student' : 'instructor',
        );
      } catch (_) {}
      emit(AuthSuccessState());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(AuthErrorState('No user found for that email.'));
      } else if (e.code == 'wrong-password') {
        emit(AuthErrorState('Wrong password provided for that user.'));
      } else {
        emit(AuthErrorState('error please try again'));
      }
    } catch (e) {
      emit(AuthErrorState("error please try again"));
    }
  }

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('is_logged_in');
        await prefs.remove('user_kind');
      } catch (_) {}
      emit(AuthInitial());
    } catch (e) {
      emit(AuthErrorState('Logout failed'));
    }
  }
}
