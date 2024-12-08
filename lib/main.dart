import 'package:fci_edutrack/screens/camera_permission_screen.dart';
import 'package:fci_edutrack/screens/explain_screens.dart';
import 'package:fci_edutrack/screens/login_with_us_scr.dart';
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
        LoginWithUsScreen.routeName: (context) => const LoginWithUsScreen(),
        CameraPermissionScreen.routeName: (context) =>
            const CameraPermissionScreen(),
        ExplainScreens.routeName: (context) => ExplainScreens(),
      },
    );
  }
}
