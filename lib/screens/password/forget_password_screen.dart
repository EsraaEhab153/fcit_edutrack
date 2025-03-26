import 'package:fci_edutrack/modules/custom_text_formfield.dart';
import 'package:fci_edutrack/screens/password/pass_confirm_code_screen.dart';
import 'package:fci_edutrack/themes/my_theme_data.dart';
import 'package:flutter/material.dart';

import '../../style/my_app_colors.dart';

class ForgetPassword extends StatelessWidget {
  static const String routeName = 'forget_password';
  final _formKey = GlobalKey<FormState>();

  ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
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
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.013),
            child: Column(
              children: [
                Text(
                  'Forget Password',
                  style: MyThemeData.lightModeStyle.textTheme.bodyMedium,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                Image.asset(
                  'assets/images/forget_password_photo.png',
                  width: MediaQuery.of(context).size.width * 0.82,
                  height: MediaQuery.of(context).size.height * 0.37,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                CustomTextFormField(
                  label: 'Enter Your Email',
                  preIcon: Icons.email_outlined,
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (text) {
                    if (text == null || text.trim().isEmpty) {
                      return 'Please Enter Email';
                    }
                    final bool emailValid = RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(text);
                    if (!emailValid) {
                      return 'Please Enter Valid Email';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                ElevatedButton(
                  onPressed: () {
                    login(context);
                    //##### edit this navigator later
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: MyAppColors.primaryColor,
                      padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.014,
                          horizontal: MediaQuery.of(context).size.width * 0.02),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              MediaQuery.of(context).size.width * 0.022))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.lock_outline),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.007,
                      ),
                      Text(
                        'Reset Password',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: MyAppColors.whiteColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void login(BuildContext context) async {
    if (_formKey.currentState?.validate() == true) {
      Navigator.pushReplacementNamed(
          context, PasswordConfirmationCode.routeName);
    }
  }
}
