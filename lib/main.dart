import 'package:coursely/core/constants/app_font.dart';
import 'package:coursely/core/constants/routes.dart';
import 'package:coursely/core/utils/app_colors.dart';
import 'package:coursely/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coursely/features/course/data/repo/course_repository.dart';
import 'package:coursely/features/home/presentation/cubit/home_cubit.dart';
import 'package:coursely/features/course/presentation/cubit/courses_cubit.dart';
import 'package:coursely/features/search/presentation/cubit/search_cubit.dart';
import 'package:coursely/features/message/presentation/cubit/messages_cubit.dart';
import 'package:coursely/features/message/data/message_repository.dart';
import 'package:coursely/features/account/presentation/cubit/account_cubit.dart';
import 'package:coursely/features/instructor/presentation/cubit/instructor_cubit.dart';
import 'package:coursely/core/cubit/theme_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const Coursely());
}

class Coursely extends StatefulWidget {
  const Coursely({super.key});

  @override
  State<Coursely> createState() => _CourselyState();
}

class _CourselyState extends State<Coursely> {
  @override
  Widget build(BuildContext context) {
    final repo = CourseRepository();

    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeCubit>(create: (_) => HomeCubit(repo)..loadFeatured()),
        BlocProvider<CoursesCubit>(
          create: (_) => CoursesCubit(repo)..fetchCourses(),
        ),
        BlocProvider<SearchCubit>(create: (_) => SearchCubit(repo)),
        BlocProvider<MessagesCubit>(
          create: (_) =>
              MessagesCubit(MessageRepository(), repo)..loadMessages(),
        ),
        BlocProvider<AccountCubit>(create: (_) => AccountCubit()),
        BlocProvider<InstructorCubit>(create: (_) => InstructorCubit(repo)),
        BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            themeMode: themeMode,
            theme: ThemeData(
              scaffoldBackgroundColor: AppColors.backGroundColor,
              inputDecorationTheme: InputDecorationTheme(
                prefixIconColor: AppColors.darkgrey.withValues(alpha: 0.3),
                suffixIconColor: AppColors.darkgrey.withValues(alpha: 0.3),
                hintStyle: TextStyle(
                  color: AppColors.darkgrey.withValues(alpha: 0.3),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    width: 1,
                    color: AppColors.borderColor,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    width: 1,
                    color: AppColors.borderColor,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(width: 1, color: Colors.red),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(width: 1, color: Colors.red),
                ),
                filled: true,
                fillColor: AppColors.backGroundColor,
              ),
              fontFamily: AppFont.poppins,
            ),
            darkTheme: ThemeData.dark().copyWith(
              scaffoldBackgroundColor: Colors.black,
            ),
            routerConfig: Routes.routes,
          );
        },
      ),
    );
  }
}
