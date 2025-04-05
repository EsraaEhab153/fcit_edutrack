import 'package:fci_edutrack/screens/home_screen/QR_code/qr_scanner.dart';
import 'package:fci_edutrack/screens/home_screen/courses_screen.dart';
import 'package:fci_edutrack/screens/home_screen/drawer/my_drawer.dart';
import 'package:fci_edutrack/screens/home_screen/home_screen.dart';
import 'package:fci_edutrack/screens/home_screen/profiles/student_profile_screen.dart';
import 'package:fci_edutrack/style/my_app_colors.dart';
import 'package:fci_edutrack/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:fci_edutrack/providers/auth_provider.dart';
import 'package:fci_edutrack/screens/admin/professor_requests_screen.dart';
import 'package:fci_edutrack/screens/admin/course_management_screen.dart';
import 'package:fci_edutrack/screens/professor/quiz_management_screen.dart';
import 'package:fci_edutrack/screens/professor/attendance_recording_screen.dart';

class MyBottomNavBar extends StatefulWidget {
  static const String routeName = 'bottom_nav_bar';

  // Static reference to the current state
  static _MyBottomNavBarState? of(BuildContext context) {
    return context.findAncestorStateOfType<_MyBottomNavBarState>();
  }

  const MyBottomNavBar({super.key});

  @override
  State<MyBottomNavBar> createState() => _MyBottomNavBarState();
}

class _MyBottomNavBarState extends State<MyBottomNavBar> {
  int selectedIndex = 0;
  DateTime? lastBackPressTime;
  bool isAdmin = false;
  bool isProfessor = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkUserRole();
  }

  Future<void> _checkUserRole() async {
    setState(() {
      isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      isAdmin = await authProvider.isAdmin();
      isProfessor = await authProvider.isProfessor();

      print(
          "MyBottomNavBar - User Roles: Admin=$isAdmin, Professor=$isProfessor");
    } catch (e) {
      print("Error checking user role: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Method to change the selected tab
  void changeTab(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Handle back button press with double-back to exit behavior
        final now = DateTime.now();
        if (lastBackPressTime == null ||
            now.difference(lastBackPressTime!) > const Duration(seconds: 2)) {
          // First back press, show toast
          lastBackPressTime = now;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Press back again to exit'),
              duration: Duration(seconds: 2),
            ),
          );
          return false;
        }
        return true; // Allow app to exit
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: MyAppColors.primaryColor),
          title: isAdmin
              ? const Text('Admin Dashboard',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: MyAppColors.primaryColor))
              : isProfessor
                  ? const Text('Professor Dashboard',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: MyAppColors.primaryColor))
                  : null,
        ),
        drawer: const MyDrawer(),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : _getScreens()[selectedIndex],
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
                tabs: _getNavTabs()),
          ),
        ),
      ),
    );
  }

  List<GButton> _getNavTabs() {
    if (isAdmin) {
      return const [
        GButton(
          icon: Icons.dashboard,
          text: 'Dashboard',
        ),
        GButton(
          icon: Icons.person_add,
          text: 'Requests',
        ),
        GButton(
          icon: Icons.school,
          text: 'Courses',
        ),
        GButton(
          icon: Icons.person,
          text: 'Profile',
        ),
      ];
    } else if (isProfessor) {
      return const [
        GButton(
          icon: Icons.home,
          text: 'Home',
        ),
        GButton(
          icon: Icons.class_,
          text: 'Classes',
        ),
        GButton(
          icon: Icons.quiz,
          text: 'Quizzes',
        ),
        GButton(
          icon: Icons.person,
          text: 'Profile',
        ),
      ];
    } else {
      return const [
        GButton(
          icon: Icons.home,
          text: 'Home',
        ),
        GButton(
          icon: Icons.qr_code_2,
          text: 'Attendance',
        ),
        GButton(
          icon: Icons.school,
          text: 'Courses',
        ),
        GButton(
          icon: Icons.person,
          text: 'Profile',
        ),
      ];
    }
  }

  List<Widget> _getScreens() {
    if (isAdmin) {
      return [
        const HomeScreen(),
        const ProfessorRequestsScreen(),
        const CourseManagementScreen(),
        const StudentProfileScreen(),
      ];
    } else if (isProfessor) {
      return [
        const HomeScreen(),
        const AttendanceRecordingScreen(),
        const QuizManagementScreen(),
        const StudentProfileScreen(),
      ];
    } else {
      return [
        const HomeScreen(),
        const QrCodeScanner(),
        const CoursesScreen(),
        const StudentProfileScreen(),
      ];
    }
  }
}
