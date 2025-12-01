import 'package:coursely/core/utils/app_colors.dart';
import 'package:coursely/features/account/presentation/page/account_page.dart';
import 'package:coursely/features/course/presentation/page/course_page.dart';
import 'package:coursely/features/home/presentation/page/home_screen.dart';
import 'package:coursely/features/message/presentation/pages/message_page.dart';
import 'package:coursely/features/search/presentation/view/search_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      CoursePage(
        onSearchTap: () {
          setState(() {
            currentIndex = 2;
          });
        },
      ),
      SearchPage(),
      MessagePage(),
      AccountScreen(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: screens[currentIndex]),
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
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "home"),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "course"),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: AppColors.primaryColor),
            label: "search",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "Notification",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_fill),
            label: "Account",
          ),
        ],
      ),
    );
  }
}
