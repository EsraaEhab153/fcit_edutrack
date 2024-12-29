import 'package:fci_edutrack/style/my_theme_data.dart';
import 'package:flutter/material.dart';

import '../modules/custom_text_formfield.dart';
import '../style/my_app_colors.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = 'register_screen';

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController confirmPasswordController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyAppColors.whiteColor,
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
              size: MediaQuery.of(context).size.height * 0.03,
            )),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.03),
            child: Column(
              children: [
                Text(
                  'هيا بنا نبدا',
                  style:
                      MyThemeData.lightModeStyle.textTheme.titleLarge!.copyWith(
                    color: MyAppColors.blackColor,
                  ),
                ),
                Text(
                  'قم بالتسجيل لحضور سريع دون الحاجة الي قوائم ورقية',
                  textAlign: TextAlign.center,
                  style: MyThemeData.lightModeStyle.textTheme.bodyMedium!
                      .copyWith(color: MyAppColors.darkBlueColor),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                CustomTextFormField(
                  label: 'User Name',
                  preIcon: Icons.person_2_outlined,
                  controller: nameController,
                  validator: (text) {
                    if (text == null || text.trim().isEmpty) {
                      return 'Please Enter User Name';
                    }
                    return null;
                  },
                ),
                CustomTextFormField(
                  label: 'Email',
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
                CustomTextFormField(
                  label: 'Password',
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
                    register();
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
                      const Icon(Icons.add_card_outlined),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.007,
                      ),
                      Text(
                        'Create Account',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: MyAppColors.whiteColor),
                      ),
                    ],
                  ),
                ),
                Text(
                  'or',
                  style:
                      MyThemeData.lightModeStyle.textTheme.bodySmall!.copyWith(
                    color: MyAppColors.blackColor,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/google_logo.png',
                      width: MediaQuery.of(context).size.width * 0.06,
                      fit: BoxFit.fill,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.04,
                    ),
                    Image.asset(
                      'assets/images/facebook_logo.png',
                      width: MediaQuery.of(context).size.width * 0.06,
                      fit: BoxFit.fill,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'already have an account?',
                      style: MyThemeData.lightModeStyle.textTheme.bodySmall!
                          .copyWith(
                        fontSize: 12,
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Text(
                        'Login',
                        style: MyThemeData.lightModeStyle.textTheme.bodySmall!
                            .copyWith(
                          fontSize: 12,
                          color: MyAppColors.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void register() async {
    if (_formKey.currentState?.validate() == true) {}
  }
}
