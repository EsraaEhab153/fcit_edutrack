import 'package:fci_edutrack/auth/login_screen.dart';
import 'package:fci_edutrack/style/my_theme_data.dart';
import 'package:flutter/material.dart';

import '../../modules/custom_text_formfield.dart';
import '../../style/my_app_colors.dart';

class ResetPasswordScreen extends StatelessWidget {
  static const String routeName = 'reset_password';

  final _formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  ResetPasswordScreen({super.key});

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
        child: Center(
          child: Column(
            children: [
              Text(
                'Reset Password',
                style: MyThemeData.lightModeStyle.textTheme.bodyMedium,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Image.asset(
                'assets/images/reset_password_logo.png',
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.41,
              ),
              Text(
                'Set a New Password',
                style: MyThemeData.lightModeStyle.textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.w300,
                ),
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.03),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      CustomTextFormField(
                        label: 'New Password',
                        preIcon: Icons.vpn_key_outlined,
                        sufIcon: Icons.visibility_off_outlined,
                        controller: passwordController,
                        validator: (text) {
                          if (text == null || text.trim().isEmpty) {
                            return 'Please Enter Password';
                          }
                          if (text.length < 6) {
                            return 'Password must be at least 6 chars.';
                          }
                          return null;
                        },
                        obscureText: true,
                      ),
                      CustomTextFormField(
                        label: 'Confirm Password',
                        preIcon: Icons.vpn_key_outlined,
                        sufIcon: Icons.visibility_off_outlined,
                        controller: confirmPasswordController,
                        validator: (text) {
                          if (text == null || text.trim().isEmpty) {
                            return 'Please Enter Confirm Password';
                          }
                          if (text != passwordController.text) {
                            return "The Confirm password doesn't match Password";
                          }
                          return null;
                        },
                        obscureText: true,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          updatePassword();
                          Navigator.pushReplacementNamed(
                              context, LoginScreen.routeName);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: MyAppColors.primaryColor,
                            padding: EdgeInsets.symmetric(
                                vertical:
                                    MediaQuery.of(context).size.height * 0.014,
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.02),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    MediaQuery.of(context).size.width *
                                        0.022))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Update Password',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(color: MyAppColors.whiteColor),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.007,
                            ),
                            const Icon(Icons.sync),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updatePassword() async {
    if (_formKey.currentState?.validate() == true) {}
  }
}
