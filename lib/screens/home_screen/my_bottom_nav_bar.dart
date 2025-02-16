import 'package:fci_edutrack/screens/home_screen/courses_screen.dart';
import 'package:fci_edutrack/screens/home_screen/home_screen.dart';
import 'package:fci_edutrack/screens/home_screen/profile_screen.dart';
import 'package:fci_edutrack/style/my_app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'notifications_screen.dart';

class MyBottomNavBar extends StatefulWidget {
  static const String routeName = 'home_screen';

  MyBottomNavBar({super.key});

  @override
  State<MyBottomNavBar> createState() => _MyBottomNavBarState();
}

class _MyBottomNavBarState extends State<MyBottomNavBar> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: selectedScreen[selectedIndex],
      backgroundColor: MyAppColors.whiteColor,
      bottomNavigationBar: Container(
        color: MyAppColors.primaryColor,
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
          child: GNav(
              onTabChange: (index) {
                selectedIndex = index;
                setState(() {});
              },
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.height * 0.024),
              backgroundColor: MyAppColors.primaryColor,
              color: Colors.white,
              activeColor: Colors.white,
              gap: 8,
              tabBackgroundColor: MyAppColors.secondaryBlueColor,
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.notifications,
                  text: 'Notification',
                  textStyle: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                GButton(
                  icon: Icons.school,
                  text: 'Courses',
                ),
                GButton(
                  icon: Icons.person,
                  text: 'Profile',
                ),
              ]),
        ),
      ),
    );
  }

  List<Widget> selectedScreen = [
    const HomeScreen(),
    const NotificationsScreen(),
    const CoursesScreen(),
    const ProfileScreen()
  ];
}
