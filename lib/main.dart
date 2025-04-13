import 'package:fci_edutrack/auth/login_or_register_screen.dart';
import 'package:fci_edutrack/auth/login_screen.dart';
import 'package:fci_edutrack/auth/register_screen.dart';
import 'package:fci_edutrack/screens/assignment/assignment_details.dart';
import 'package:fci_edutrack/screens/assignment/assignment_screen.dart';
import 'package:fci_edutrack/screens/camera_permission_screen.dart';
import 'package:fci_edutrack/screens/explain_screens.dart';
import 'package:fci_edutrack/screens/home_screen/my_bottom_nav_bar.dart';
import 'package:fci_edutrack/screens/home_screen/notifications_screen.dart';
import 'package:fci_edutrack/screens/home_screen/profiles/doctor_profile_screen.dart';
import 'package:fci_edutrack/screens/home_screen/profiles/student_profile_screen.dart';
import 'package:fci_edutrack/screens/password/forget_password_screen.dart';
import 'package:fci_edutrack/screens/password/pass_confirm_code_screen.dart';
import 'package:fci_edutrack/screens/password/reset_password_screen.dart';
import 'package:fci_edutrack/screens/register_attendance.dart';
import 'package:fci_edutrack/screens/settings_screen.dart';
import 'package:fci_edutrack/screens/splash_screen.dart';
import 'package:fci_edutrack/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
    )
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "FCIT EduTrack",
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).appTheme,
      initialRoute: SplashScreen.routeName,
      //initialRoute: MyBottomNavBar.routeName,
      routes: {
        SplashScreen.routeName: (context) => const SplashScreen(),
        RegisterAttendanceScreen.routeName: (context) =>
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
        DoctorProfileScreen.routeName: (context) => const DoctorProfileScreen(),
        StudentProfileScreen.routeName: (context) =>
            const StudentProfileScreen(),
      },
    );
  }
}
