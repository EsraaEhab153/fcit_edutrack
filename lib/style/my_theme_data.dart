import 'package:fci_edutrack/style/my_app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyThemeData {
  static final ThemeData lightModeStyle = ThemeData(
      textTheme: TextTheme(
    titleLarge: GoogleFonts.roboto(
      fontSize: 40,
      fontWeight: FontWeight.bold,
      color: MyAppColors.darkBlueColor,
    ),
  ));
}
