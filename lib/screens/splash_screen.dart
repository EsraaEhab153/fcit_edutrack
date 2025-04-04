import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:fci_edutrack/auth/login_or_register_screen.dart';
import 'package:fci_edutrack/providers/auth_provider.dart';
import 'package:fci_edutrack/screens/explain_screens.dart';
import 'package:fci_edutrack/screens/home_screen/my_bottom_nav_bar.dart';
import 'package:fci_edutrack/style/my_app_colors.dart';
import 'package:fci_edutrack/themes/my_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

// class SplashScreen extends StatelessWidget {
//   static const String routeName = 'splash_screen';
//
//   const SplashScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Center(
//             child: AnimatedSplashScreen(
//               splash: Lottie.asset(
//                   'assets/animation/Animation - 1733514887695 (1).json',
//                   height: double.infinity,
//                   width: double.infinity,
//                   fit: BoxFit.cover),
//               nextScreen: const ExplainScreens(),
//               duration: 3000,
//               splashTransition: SplashTransition.fadeTransition,
//               pageTransitionType: PageTransitionType.fade,
//               splashIconSize: MediaQuery.of(context).size.height * 0.35,
//               backgroundColor: MyAppColors.whiteColor,
//             ),
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Image.asset(
//                 'assets/images/fci_logo.png',
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(
//                     vertical: MediaQuery.of(context).size.height * 0.07,
//                     horizontal: MediaQuery.of(context).size.width * 0.02),
//                 child: Text(
//                   'FCIT EduTrack',
//                   style: MyThemeData.lightModeStyle.textTheme.titleLarge,
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

class SplashScreen extends StatefulWidget {
  static const String routeName = 'splash_screen';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigation is handled by the AnimatedSplashScreen
  }

  @override
  Widget build(BuildContext context) {
    // Check if user is already logged in
    final authProvider = Provider.of<AuthProvider>(context);
    final navDestination = authProvider.isLoggedIn
        ? MyBottomNavBar.routeName
        : ExplainScreens.routeName;

    return AnimatedSplashScreen(
      backgroundColor: MyAppColors.primaryColor,
      duration: 3000,
      splash: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.height * 0.6,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: MyAppColors.primaryColor,
                borderRadius:
                    BorderRadius.circular(MediaQuery.of(context).size.width),
              ),
              child: Lottie.asset('assets/animation/welcome_animation.json'),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Text(
            'Welcome To\n FCIT Edutrack',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: MyAppColors.whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.width * 0.07),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
        ],
      ),
      nextScreen: authProvider.isLoading
          ? const _LoadingScreen()
          : _getNextScreen(navDestination),
      splashTransition: SplashTransition.fadeTransition,
    );
  }

  Widget _getNextScreen(String routeName) {
    switch (routeName) {
      case MyBottomNavBar.routeName:
        return const MyBottomNavBar();
      case ExplainScreens.routeName:
        return const ExplainScreens();
      default:
        return const LoginOrRegisterScreen();
    }
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyAppColors.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: Colors.white),
            const SizedBox(height: 20),
            Text(
              'Loading...',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Colors.white,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
