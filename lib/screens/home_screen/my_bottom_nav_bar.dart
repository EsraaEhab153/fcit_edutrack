import 'package:fci_edutrack/screens/home_screen/QR_code/qr_scanner.dart';
import 'package:fci_edutrack/screens/home_screen/courses_screen.dart';
import 'package:fci_edutrack/screens/home_screen/drawer/my_drawer.dart';
import 'package:fci_edutrack/screens/home_screen/home_screen.dart';
import 'package:fci_edutrack/screens/home_screen/profiles/doctor_profile_screen.dart';
import 'package:fci_edutrack/screens/home_screen/profiles/student_profile_screen.dart';
import 'package:fci_edutrack/style/my_app_colors.dart';
import 'package:fci_edutrack/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';

class MyBottomNavBar extends StatefulWidget {
  static const String routeName = 'bottom_nav_bar';

  const MyBottomNavBar({super.key});

  @override
  State<MyBottomNavBar> createState() => _MyBottomNavBarState();
}

class _MyBottomNavBarState extends State<MyBottomNavBar> {
  int selectedIndex = 0;
  late String userRole;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userRole = ModalRoute.of(context)!.settings.arguments as String;
  }

  @override
  Widget build(BuildContext context) {
    String userRole = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: MyAppColors.primaryColor),
      ),
      drawer: const MyDrawer(),
      body: selectedScreen()[selectedIndex],
      backgroundColor: Provider.of<ThemeProvider>(context).isDark()
          ? MyAppColors.primaryDarkColor
          : MyAppColors.whiteColor,
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
                  icon: Icons.qr_code_2,
                  text: 'Attendance',
                  textStyle: TextStyle(
                      fontSize: 10,
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

  List<Widget> selectedScreen() {
    return [
      const HomeScreen(),
      const QrCodeScanner(),
      const CoursesScreen(),
      userRole == 'Doctor'
          ? const DoctorProfileScreen()
          : const StudentProfileScreen(),
    ];
  }
}
