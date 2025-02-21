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
    titleMedium: GoogleFonts.roboto(
      fontSize: 21,
      fontWeight: FontWeight.bold,
      color: MyAppColors.darkBlueColor,
    ),
    bodyLarge: GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: MyAppColors.blackColor,
    ),
    bodyMedium: GoogleFonts.poppins(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: MyAppColors.blackColor,
    ),
    bodySmall: GoogleFonts.poppins(
      fontSize: 10,
      fontWeight: FontWeight.bold,
      color: MyAppColors.blackColor,
    ),
  ));
}
