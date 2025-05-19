import 'package:fci_edutrack/auth/login_screen.dart'; // Import LoginScreen for navigation
import 'package:fci_edutrack/providers/auth_provider.dart'; // Import AuthProvider
import 'package:fci_edutrack/screens/assignment/assignment_screen.dart'; // Placeholder for assignment management
import 'package:fci_edutrack/screens/home_screen/courses_screen.dart'; // For enrolling/viewing courses
import 'package:fci_edutrack/screens/home_screen/profiles/student_profile_screen.dart';
import 'package:fci_edutrack/screens/professor/professor_attendance_management.dart'; // Import the correct screen
import 'package:fci_edutrack/screens/professor/quiz_management_screen.dart'; // Placeholder for quiz management
import 'package:fci_edutrack/style/my_app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider
// TODO: Implement actual screens for professor features

class ProfessorHomeScreen extends StatefulWidget {
  static const String routeName = 'professor_home_screen';

  const ProfessorHomeScreen({super.key});

  @override
  State<ProfessorHomeScreen> createState() => _ProfessorHomeScreenState();
}

class _ProfessorHomeScreenState extends State<ProfessorHomeScreen> {
  int _selectedIndex = 0;

  // Define the screens for the professor
  // Replace placeholders with actual implemented screens later
  final List<Widget> _screens = [
    const CoursesScreen(), // For enrolling/viewing courses
    const ProfessorAttendanceManagementScreen(), // Use the management screen here
    const QuizManagementScreen(), // Placeholder for quizzes
    const AssignmentScreen(), // Placeholder for assignments
  ];

  final List<BottomNavigationBarItem> _navItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.school_outlined), // Changed icon
      label: 'Courses',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.timer_outlined), // Changed icon
      label: 'Attendance',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.quiz_outlined), // Changed icon
      label: 'Quizzes',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.assignment_outlined), // Changed icon
      label: 'Assignments',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider =
        Provider.of<AuthProvider>(context, listen: false); // Get AuthProvider

    return Scaffold(
      appBar: AppBar(
        title: const Text('Professor Dashboard',
            style: TextStyle(fontSize: 20)), // Adjust font size
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft:
                Radius.circular(MediaQuery.of(context).size.width * 0.1),
            bottomRight:
                Radius.circular(MediaQuery.of(context).size.width * 0.1),
          ),
        ),
        backgroundColor: MyAppColors.primaryColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StudentProfileScreen()),
            );
          },
          icon: Icon(Icons.person),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              await authProvider.logout();
              // Navigate back to login screen after logout
              Navigator.of(context).pushNamedAndRemoveUntil(
                  LoginScreen.routeName, // Use LoginScreen.routeName
                  (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
      body: IndexedStack(
        // Use IndexedStack to keep state of screens
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: MyAppColors.primaryColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(MediaQuery.of(context).size.width * 0.1),
            topRight: Radius.circular(MediaQuery.of(context).size.width * 0.1),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: List.generate(4, (index) {
            IconData icon;
            String label;

            switch (index) {
              case 0:
                icon = Icons.school_outlined;
                label = 'Courses';
                break;
              case 1:
                icon = Icons.timer_outlined;
                label = 'Attendance';
                break;
              case 2:
                icon = Icons.quiz_outlined;
                label = 'Quizzes';
                break;
              default:
                icon = Icons.assignment_outlined;
                label = 'Assignments';
            }

            bool isSelected = _selectedIndex == index;

            return BottomNavigationBarItem(
              label: label,
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: isSelected
                    ? const BoxDecoration(
                        color: Colors.white, //circle background color
                        shape: BoxShape.circle,
                      )
                    : null,
                child: Icon(
                  icon,
                  color: isSelected
                      ? MyAppColors.primaryColor
                      : MyAppColors.whiteColor,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
