import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
// Auth imports
import 'package:fci_edutrack/auth/login_or_register_screen.dart';
import 'package:fci_edutrack/auth/login_screen.dart';
import 'package:fci_edutrack/auth/register_screen.dart';
import 'package:fci_edutrack/auth/auth_wrapper.dart';
// Provider imports
import 'package:fci_edutrack/providers/attendance_provider.dart';
import 'package:fci_edutrack/providers/auth_provider.dart';
import 'package:fci_edutrack/providers/course_provider.dart';
import 'package:fci_edutrack/providers/assignment_provider.dart';
import 'package:fci_edutrack/providers/quiz_provider.dart';
// Theme imports
import 'package:fci_edutrack/themes/theme_provider.dart';
// Screen imports - Admin
import 'package:fci_edutrack/screens/admin/professor_requests_screen.dart';
import 'package:fci_edutrack/screens/admin/course_management_screen.dart';
import 'package:fci_edutrack/screens/admin/admin_home_screen.dart';
// Screen imports - Professor
import 'package:fci_edutrack/screens/professor/quiz_management_screen.dart';
import 'package:fci_edutrack/screens/professor/quiz_creation_screen.dart';
import 'package:fci_edutrack/screens/professor/professor_home_screen.dart';
import 'package:fci_edutrack/screens/professor/quiz_drafts_screen.dart';
// Screen imports - Student
import 'package:fci_edutrack/screens/student/student_quiz_list_screen.dart';
// Screen imports - General
import 'package:fci_edutrack/screens/assignment/assignment_details.dart';
import 'package:fci_edutrack/screens/assignment/assignment_screen.dart';
import 'package:fci_edutrack/screens/assignment/assignment_create_screen.dart';
import 'package:fci_edutrack/screens/assignment/assignment_submission_screen.dart';
import 'package:fci_edutrack/screens/assignment/assignment_submissions_screen.dart';
import 'package:fci_edutrack/screens/assignment/assignment_grading_screen.dart';
import 'package:fci_edutrack/screens/assignment/assignment_drafts_screen.dart';
import 'package:fci_edutrack/models/assignment_model.dart';
import 'package:fci_edutrack/screens/camera_permission_screen.dart';
import 'package:fci_edutrack/screens/explain_screens.dart';
import 'package:fci_edutrack/screens/home_screen/my_bottom_nav_bar.dart';
import 'package:fci_edutrack/screens/home_screen/notifications_screen.dart';
import 'package:fci_edutrack/screens/password/forget_password_screen.dart';
import 'package:fci_edutrack/screens/password/pass_confirm_code_screen.dart';
import 'package:fci_edutrack/screens/password/reset_password_screen.dart';
import 'package:fci_edutrack/screens/password/change_password_screen.dart';
import 'package:fci_edutrack/screens/professor_request_screen.dart';
import 'package:fci_edutrack/screens/register_attendance.dart';
import 'package:fci_edutrack/screens/settings_screen.dart';
import 'package:fci_edutrack/screens/attendance_history_screen.dart';

Future<void> main() async {
  // Make main async
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
      create: (context) => AssignmentProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => AttendanceProvider(),
    ),
    // QuizProvider needs CourseProvider for fetching student quizzes
    ChangeNotifierProxyProvider<CourseProvider, QuizProvider>(
      create: (context) => QuizProvider(), // Initial creation
      update: (context, courseProvider, previousQuizProvider) {
        // Update QuizProvider with the latest CourseProvider instance
        previousQuizProvider?.updateCourseProvider(courseProvider);
        return previousQuizProvider ??
            QuizProvider(); // Return existing or new instance
      },
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
      routes: {
        // Auth routes
        AuthWrapper.routeName: (context) => const AuthWrapper(),
        LoginScreen.routeName: (context) => const LoginScreen(),
        RegisterScreen.routeName: (context) => const RegisterScreen(),
        LoginOrRegisterScreen.routeName: (context) =>
            const LoginOrRegisterScreen(),

        // Password management routes
        ForgetPassword.routeName: (context) => ForgetPassword(),
        PasswordConfirmationCode.routeName: (context) =>
            const PasswordConfirmationCode(),
        ResetPasswordScreen.routeName: (context) => ResetPasswordScreen(),
        ChangePasswordScreen.routeName: (context) =>
            const ChangePasswordScreen(),

        // Main navigation routes
        MyBottomNavBar.routeName: (context) => const MyBottomNavBar(),
        NotificationsScreen.routeName: (context) => const NotificationsScreen(),
        SettingsScreen.routeName: (context) => const SettingsScreen(),

        // Attendance routes
        RegisterAttendanceScreen.routeName: (context) =>
            const RegisterAttendanceScreen(),
        CameraPermissionScreen.routeName: (context) =>
            const CameraPermissionScreen(),
        'attendance_history': (context) => const AttendanceHistoryScreen(),

        // Assignment routes
        AssignmentScreen.routeName: (context) => const AssignmentScreen(),
        AssignmentDetails.routeName: (context) => const AssignmentDetails(),
        AssignmentCreateScreen.routeName: (context) =>
            const AssignmentCreateScreen(),
        AssignmentDraftsScreen.routeName: (context) =>
            const AssignmentDraftsScreen(),
        AssignmentSubmissionScreen.routeName: (context) {
          final arguments = ModalRoute.of(context)?.settings.arguments;

          if (arguments is Assignment) {
            return AssignmentSubmissionScreen(assignment: arguments);
          } else if (arguments is Map<String, dynamic>) {
            return AssignmentSubmissionScreen(
              assignment: arguments['assignment'],
              existingSubmission: arguments['existingSubmission'],
            );
          } else {
            return AssignmentSubmissionScreen(
              assignment: Assignment(
                id: 0,
                title: 'Error',
                description: 'Invalid arguments',
                dueDate: '',
                maxPoints: 0,
              ),
            );
          }
        },
        AssignmentSubmissionsScreen.routeName: (context) =>
            AssignmentSubmissionsScreen(
                assignmentId:
                    ModalRoute.of(context)!.settings.arguments as int),
        AssignmentGradingScreen.routeName: (context) => AssignmentGradingScreen(
            submission: ModalRoute.of(context)!.settings.arguments
                as AssignmentSubmission),

        // Professor routes
        ProfessorRequestScreen.routeName: (context) =>
            const ProfessorRequestScreen(),
        ProfessorHomeScreen.routeName: (context) => const ProfessorHomeScreen(),

        // Admin routes
        AdminHomeScreen.routeName: (context) => const AdminHomeScreen(),
        ProfessorRequestsScreen.routeName: (context) =>
            const ProfessorRequestsScreen(),
        CourseManagementScreen.routeName: (context) =>
            const CourseManagementScreen(),

        // Quiz routes
        QuizManagementScreen.routeName: (context) =>
            const QuizManagementScreen(),
        QuizCreationScreen.routeName: (context) => const QuizCreationScreen(),
        QuizDraftsScreen.routeName: (context) => const QuizDraftsScreen(),
        StudentQuizListScreen.routeName: (context) =>
            const StudentQuizListScreen(),

        // Misc routes
        ExplainScreens.routeName: (context) => const ExplainScreens(),
      },
    );
  }
}
