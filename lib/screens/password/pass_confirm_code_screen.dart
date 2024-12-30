import 'package:fci_edutrack/modules/custom_button_widget.dart';
import 'package:fci_edutrack/modules/custom_confirmation_cell.dart';
import 'package:fci_edutrack/style/my_theme_data.dart';
import 'package:flutter/material.dart';

import '../../style/my_app_colors.dart';

class PasswordConfirmationCode extends StatelessWidget {
  static const String routeName = 'password_confirmation_code';

  const PasswordConfirmationCode({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_circle_left,
              color: MyAppColors.primaryColor,
              size: MediaQuery.of(context).size.height * 0.04,
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Image.asset(
                'assets/images/pss_confirmation_logo.png',
                width: MediaQuery.of(context).size.width * 0.82,
                height: MediaQuery.of(context).size.height * 0.41,
                fit: BoxFit.fill,
              ),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomConfirmationCell(),
                CustomConfirmationCell(),
                CustomConfirmationCell(),
                CustomConfirmationCell(),
                CustomConfirmationCell(),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            CustomButtonWidget(
              label: 'Confirm',
              buttonFunction: () {},
              buttonIcon: Icons.check_circle_outline,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Text(
              'Resend the Code',
              style: MyThemeData.lightModeStyle.textTheme.bodySmall,
            )
          ],
        ),
      ),
    );
  }
}
