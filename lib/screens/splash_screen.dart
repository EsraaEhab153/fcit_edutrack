import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:fci_edutrack/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../style/my_app_colors.dart';

class SplashScreen extends StatelessWidget {
  static const String routeName = 'splash_screen';

  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                MyAppColors.blueColor,
                MyAppColors.lightBlueColor,
                MyAppColors.whiteColor
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        AnimatedSplashScreen(
          splash: Center(
            child: Image.asset(
              'assets/images/splash_logo.png',
            ),
          ),
          nextScreen: const HomeScreen(),
          duration: 5000,
          backgroundColor: Colors.transparent,
          pageTransitionType: PageTransitionType.bottomToTop,
          animationDuration: const Duration(seconds: 1),
          splashIconSize: MediaQuery.of(context).size.height * 0.7,
          splashTransition: SplashTransition.fadeTransition,
        ),
      ],
    );
  }
}
