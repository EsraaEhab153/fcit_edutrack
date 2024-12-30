import 'package:fci_edutrack/style/my_app_colors.dart';
import 'package:flutter/material.dart';

import '../auth/register_screen.dart';
import '../modules/custom_button_widget.dart';

class RegisterAttendanceScreen extends StatelessWidget {
  static const String routeName = 'home_screen';

  const RegisterAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Container(
      color: MyAppColors.whiteColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            'assets/images/login_with_us.png',
            width: width * 0.8,
          ),
          CustomButtonWidget(
              label: 'سجل معنا',
              buttonFunction: () {
                Navigator.pushNamed(context, RegisterScreen.routeName);
              }),
        ],
      ),
    );
  }
}
