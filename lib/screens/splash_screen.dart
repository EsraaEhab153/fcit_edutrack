import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:fci_edutrack/screens/explain_screens.dart';
import 'package:fci_edutrack/style/my_app_colors.dart';
import 'package:fci_edutrack/style/my_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

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

class SplashScreen extends StatelessWidget {
  static const String routeName = 'splash_screen';

  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Stack(
            children: [
              Center(
                child: AnimatedSplashScreen(
                  splash: Lottie.asset(
                    'assets/animation/Animation - 1733514887695 (1).json',
                    height: constraints.maxHeight * 0.5,
                    width: constraints.maxWidth * 0.5,
                    fit: BoxFit.contain,
                  ),
                  nextScreen: const ExplainScreens(),
                  duration: 3000,
                  splashTransition: SplashTransition.fadeTransition,
                  pageTransitionType: PageTransitionType.fade,
                  splashIconSize: constraints.maxHeight * 0.35,
                  backgroundColor: MyAppColors.whiteColor,
                ),
              ),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.only(top: constraints.maxHeight * 0.02),
                      child: Image.asset(
                        'assets/images/fci_logo.png',
                        height:
                            constraints.maxHeight * 0.1, // Make logo responsive
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: constraints.maxHeight * 0.05,
                        horizontal: constraints.maxWidth * 0.05,
                      ),
                      child: Text(
                        'FCIT EduTrack',
                        style: MyThemeData.lightModeStyle.textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
