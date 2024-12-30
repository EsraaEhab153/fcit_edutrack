import 'package:fci_edutrack/auth/login_or_register_screen.dart';
import 'package:fci_edutrack/auth/login_screen.dart';
import 'package:fci_edutrack/auth/register_screen.dart';
import 'package:fci_edutrack/screens/camera_permission_screen.dart';
import 'package:fci_edutrack/screens/explain_screens.dart';
import 'package:fci_edutrack/screens/password/forget_password_screen.dart';
import 'package:fci_edutrack/screens/password/pass_confirm_code_screen.dart';
import 'package:fci_edutrack/screens/register_attendance.dart';
import 'package:fci_edutrack/screens/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "FCIT EduTrack",
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.routeName,
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
      },
    );
  }
}
