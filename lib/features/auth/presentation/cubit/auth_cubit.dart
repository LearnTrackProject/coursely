import 'package:coursely/features/auth/data/models/user_type_enum.dart';
import 'package:coursely/features/auth/presentation/cubit/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  login() async {
    emit(AuthLoadingState());
    emit(AuthSuccessState());
  }

  register({required UserTypeEnum userType}) async {
    emit(AuthLoadingState());
    // register with firebase

    emit(AuthSuccessState());
  }
}
