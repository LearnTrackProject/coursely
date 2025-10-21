import 'package:coursely/core/utils/app_colors.dart';
import 'package:coursely/features/home/presentation/page/home_screen.dart';
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
      Center(child: Text("screen2")),
      Center(child: Text("screen3")),
      Center(child: Text("screen4")),
      Center(child: Text("screen5")),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "home"),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "course"),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: AppColors.primaryColor),
            label: "search",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: "Message"),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_fill),
            label: "Account",
          ),
        ],
      ),
    );
  }
}
