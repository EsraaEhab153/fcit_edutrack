import 'package:fci_edutrack/auth/login_or_register_screen.dart';
import 'package:fci_edutrack/auth/login_screen.dart';
import 'package:fci_edutrack/auth/register_screen.dart';
import 'package:fci_edutrack/auth/auth_wrapper.dart'; // Import AuthWrapper
import 'package:fci_edutrack/providers/attendance_provider.dart';
import 'package:fci_edutrack/providers/auth_provider.dart';
import 'package:fci_edutrack/providers/course_provider.dart';
import 'package:fci_edutrack/screens/assignment/assignment_details.dart';
import 'package:fci_edutrack/screens/assignment/assignment_screen.dart';
import 'package:fci_edutrack/screens/camera_permission_screen.dart';
import 'package:fci_edutrack/screens/explain_screens.dart';
import 'package:fci_edutrack/screens/home_screen/my_bottom_nav_bar.dart';
import 'package:fci_edutrack/screens/home_screen/notifications_screen.dart';
import 'package:fci_edutrack/screens/password/forget_password_screen.dart';
import 'package:fci_edutrack/screens/password/pass_confirm_code_screen.dart';
import 'package:fci_edutrack/screens/password/reset_password_screen.dart';
import 'package:fci_edutrack/screens/professor_request_screen.dart';
import 'package:fci_edutrack/screens/register_attendance.dart';
import 'package:fci_edutrack/screens/settings_screen.dart'; // Keep settings import
import 'package:fci_edutrack/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:fci_edutrack/screens/attendance_history_screen.dart';
import 'package:fci_edutrack/screens/admin/professor_requests_screen.dart';
import 'package:fci_edutrack/screens/admin/course_management_screen.dart';
import 'package:fci_edutrack/screens/professor/quiz_management_screen.dart';
import 'package:fci_edutrack/screens/professor/attendance_recording_screen.dart';
import 'package:fci_edutrack/screens/admin/admin_home_screen.dart'; // Added import
import 'package:fci_edutrack/screens/professor/professor_home_screen.dart'; // Added import

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) =>
          AuthProvider()..initialize(), // Initialize AuthProvider here
    ),
    ChangeNotifierProvider(
      create: (context) => CourseProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => AttendanceProvider(),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  // Changed to StatelessWidget
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "FCIT EduTrack",
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).appTheme,
      initialRoute: AuthWrapper.routeName, // Start with AuthWrapper
      //initialRoute: MyBottomNavBar.routeName,
      routes: {
        AuthWrapper.routeName: (context) =>
            const AuthWrapper(), // Add AuthWrapper route
        RegisterAttendanceScreen.routeName: (context) => // Keep other routes
            const RegisterAttendanceScreen(),
        CameraPermissionScreen.routeName: (context) =>
            const CameraPermissionScreen(),
        ExplainScreens.routeName: (context) => const ExplainScreens(),
        RegisterScreen.routeName: (context) => const RegisterScreen(),
        LoginScreen.routeName: (context) => const LoginScreen(),
        ForgetPassword.routeName: (context) => ForgetPassword(),
        LoginOrRegisterScreen.routeName: (context) =>
            const LoginOrRegisterScreen(),
        PasswordConfirmationCode.routeName: (context) =>
            const PasswordConfirmationCode(),
        ResetPasswordScreen.routeName: (context) => ResetPasswordScreen(),
        MyBottomNavBar.routeName: (context) => const MyBottomNavBar(),
        NotificationsScreen.routeName: (context) => const NotificationsScreen(),
        AssignmentScreen.routeName: (context) => const AssignmentScreen(),
        AssignmentDetails.routeName: (context) => const AssignmentDetails(),
        SettingsScreen.routeName: (context) => const SettingsScreen(),
        'attendance_history': (context) => AttendanceHistoryScreen(),
        ProfessorRequestScreen.routeName: (context) =>
            const ProfessorRequestScreen(),
        ProfessorRequestsScreen.routeName: (context) =>
            const ProfessorRequestsScreen(),
        CourseManagementScreen.routeName: (context) =>
            const CourseManagementScreen(),
        QuizManagementScreen.routeName: (context) =>
            const QuizManagementScreen(),
        AdminHomeScreen.routeName: (context) =>
            const AdminHomeScreen(), // Added route
        ProfessorHomeScreen.routeName: (context) =>
            const ProfessorHomeScreen(), // Added route
      },
    );
  }
}
