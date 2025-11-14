import 'package:coursely/core/utils/app_colors.dart';
import 'package:coursely/features/account/presentation/page/account_page.dart';
import 'package:coursely/features/course/presentation/page/course_page.dart';
import 'package:coursely/features/home/presentation/page/home_screen.dart';
import 'package:coursely/features/message/presentation/pages/message_page.dart';
import 'package:coursely/features/search/presentation/view/search_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:coursely/features/course/data/repo/course_repository.dart';
import 'package:coursely/features/course/presentation/cubit/courses_cubit.dart';
import 'package:coursely/features/home/presentation/cubit/home_cubit.dart';
import 'package:coursely/features/message/presentation/cubit/messages_cubit.dart';
import 'package:coursely/features/account/presentation/cubit/account_cubit.dart';
import 'package:coursely/features/message/data/message_repository.dart';
import 'package:coursely/features/search/presentation/cubit/search_cubit.dart';
import 'package:coursely/features/instructor/presentation/cubit/instructor_cubit.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Widget> screens = [];
  int currentIndex = 0;
  @override
  void initState() {
    screens = [
      HomeScreen(),
      CoursePage(),
      SearchPage(),
      MessagePage(),
      AccountScreen(),
    ];
    super.initState();
  }

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
      ],
      child: Scaffold(
        body: screens[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,

          selectedItemColor: AppColors.primaryColor,
          unselectedItemColor: AppColors.darkgrey.withValues(alpha: 0.4),
          onTap: (index) {
            currentIndex = index;
            setState(() {});
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: "home",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.book), label: "course"),
            BottomNavigationBarItem(
              icon: Icon(Icons.search, color: AppColors.primaryColor),
              label: "search",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              label: "Message",
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person_fill),
              label: "Account",
            ),
          ],
        ),
      ),
    );
  }
}
