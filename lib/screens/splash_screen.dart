import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:fci_edutrack/screens/login_with_us_scr.dart';
import 'package:fci_edutrack/style/my_app_colors.dart';
import 'package:fci_edutrack/style/my_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatelessWidget {
  static const String routeName = 'splash_screen';

  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: AnimatedSplashScreen(
              splash: Lottie.asset(
                  'assets/animation/Animation - 1733514887695 (1).json',
                  height: double.infinity,
                  width: double.infinity,
                  fit: BoxFit.cover),
              nextScreen: LoginWithUsScreen(),
              duration: 6000,
              splashTransition: SplashTransition.fadeTransition,
              pageTransitionType: PageTransitionType.fade,
              splashIconSize: MediaQuery.of(context).size.height * 0.35,
              backgroundColor: MyAppColors.whiteColor,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/images/fci_logo.png',
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.07,
                    horizontal: MediaQuery.of(context).size.width * 0.02),
                child: Text(
                  'FCIT EduTrack',
                  style: MyThemeData.lightModeStyle.textTheme.titleLarge,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
