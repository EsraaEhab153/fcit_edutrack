import 'package:fci_edutrack/style/my_app_colors.dart';
import 'package:flutter/material.dart';

class LoginWithUsScreen extends StatelessWidget {
  static const String routeName = 'home_screen';

  const LoginWithUsScreen({super.key});

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
          ElevatedButton(
            onPressed: () {},
            child: Text('سجل معنا'),
            style: ElevatedButton.styleFrom(
                fixedSize: Size(width * 0.5, height * 0.06),
                backgroundColor: MyAppColors.primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(width * 0.02))),
          ),
        ],
      ),
    );
  }
}
