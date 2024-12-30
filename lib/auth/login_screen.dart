import 'package:fci_edutrack/auth/register_screen.dart';
import 'package:fci_edutrack/screens/password/forget_password_screen.dart';
import 'package:fci_edutrack/style/my_theme_data.dart';
import 'package:flutter/material.dart';

import '../modules/custom_text_formfield.dart';
import '../style/my_app_colors.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'login_screen';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<LoginScreen> {
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
              size: MediaQuery.of(context).size.height * 0.04,
            )),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.03),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                InkWell(
                  onTap: () {
                    Navigator.pushReplacementNamed(
                        context, ForgetPassword.routeName);
                  },
                  child: const Text('forget password ?'),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                ElevatedButton(
                  onPressed: () {
                    login();
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
                      Text(
                        'Login',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: MyAppColors.whiteColor),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.007,
                      ),
                      const Icon(Icons.login),
                    ],
                  ),
                ),
                Center(
                  child: Text(
                    'or',
                    style: MyThemeData.lightModeStyle.textTheme.bodySmall!
                        .copyWith(
                      color: MyAppColors.blackColor,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/google_logo.png',
                      width: MediaQuery.of(context).size.width * 0.05,
                      fit: BoxFit.fill,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.04,
                    ),
                    Image.asset(
                      'assets/images/facebook_logo.png',
                      width: MediaQuery.of(context).size.width * 0.05,
                      fit: BoxFit.fill,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: MyThemeData.lightModeStyle.textTheme.bodySmall!
                          .copyWith(
                        fontSize: 12,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacementNamed(
                            context, RegisterScreen.routeName);
                      },
                      child: Text(
                        ' Register',
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

  void login() async {
    if (_formKey.currentState?.validate() == true) {}
  }
}
