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
    bodyMedium: GoogleFonts.poppins(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: MyAppColors.blackColor,
    ),
    bodySmall: GoogleFonts.poppins(
      fontSize: 17,
      fontWeight: FontWeight.bold,
      color: MyAppColors.blackColor,
    ),
  ));
}
