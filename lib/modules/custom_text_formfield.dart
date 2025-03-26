import 'package:fci_edutrack/style/my_app_colors.dart';
import 'package:fci_edutrack/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

typedef Validator = String? Function(String?);

class CustomTextFormField extends StatelessWidget {
  String label;
  TextEditingController controller;
  TextInputType keyboardType;
  IconData preIcon;
  IconData? sufIcon;

  Validator validator;
  bool obscureText;

  CustomTextFormField(
      {super.key,
      required this.label,
      required this.controller,
      this.keyboardType = TextInputType.text,
      required this.validator,
      required this.preIcon,
      this.sufIcon,
      this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
      child: TextFormField(
        decoration: InputDecoration(
          label: Text(label, style: Theme.of(context).textTheme.bodyMedium),
          border: OutlineInputBorder(
              borderSide: const BorderSide(
                color: MyAppColors.primaryColor,
              ),
              borderRadius: BorderRadius.all(
                  Radius.circular(MediaQuery.of(context).size.width * 0.022))),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: MyAppColors.primaryColor,
              ),
              borderRadius: BorderRadius.all(
                  Radius.circular(MediaQuery.of(context).size.width * 0.022))),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: MyAppColors.primaryColor,
              ),
              borderRadius: BorderRadius.all(
                  Radius.circular(MediaQuery.of(context).size.width * 0.04))),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.width * 0.022),
              borderSide: const BorderSide(color: MyAppColors.redColor)),
          prefixIcon: Icon(
            preIcon,
            color: Provider.of<ThemeProvider>(context).isDark()
                ? MyAppColors.lightBlueColor
                : MyAppColors.blackColor,
          ),
          suffixIcon: IconButton(
            onPressed: () {},
            icon: Icon(sufIcon),
            color: Provider.of<ThemeProvider>(context).isDark()
                ? MyAppColors.lightBlueColor
                : MyAppColors.blackColor,
          ),
        ),
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        obscureText: obscureText,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
