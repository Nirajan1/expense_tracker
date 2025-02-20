import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: Color(0xFF003366),
    scaffoldBackgroundColor: Color(0xFFF8F8FF),
    textTheme: TextTheme(
      // Display Styles (Large, Medium, Small)
      displayLarge: GoogleFonts.poppins(fontSize: 57, fontWeight: FontWeight.w400, color: Color(0xFF212121)),
      displayMedium: GoogleFonts.poppins(fontSize: 45, fontWeight: FontWeight.w400, color: Color(0xFF212121)),
      displaySmall: GoogleFonts.poppins(fontSize: 36, fontWeight: FontWeight.w400, color: Color(0xFF212121)),

      // Headline Styles (Large, Medium, Small)
      headlineLarge: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF212121)),
      headlineMedium: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.w600, color: Color(0xFF212121)),
      headlineSmall: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w500, color: Color(0xFF212121)),

      // Title Styles (Large, Medium, Small)
      titleLarge: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w500, color: Color(0xFF212121)),
      titleMedium: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w500, color: Color(0xFF212121)),
      titleSmall: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w400, color: Color(0xFF212121)),

      // Body Styles (Large, Medium, Small)
      bodyLarge: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xFF212121)),
      bodyMedium: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xFF212121)),
      bodySmall: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w300, color: Color(0xFF212121)),

      // Label Styles (Large, Medium, Small)
      labelLarge: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF212121)),
      labelMedium: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w400, color: Color(0xFF212121)),
      labelSmall: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w300, color: Color(0xFF212121)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF003366),
        textStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
      ),
    ),
    datePickerTheme: DatePickerThemeData(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      backgroundColor: Colors.white,
      headerBackgroundColor: Color(0xFF003366),
      headerForegroundColor: Colors.white,
      inputDecorationTheme: InputDecorationTheme(),
    ),
    dropdownMenuTheme: DropdownMenuThemeData(),
  );
}
