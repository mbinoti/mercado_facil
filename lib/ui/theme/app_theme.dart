import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData lightTheme() {
    const seedColor = Color(0xFF0CB05A);

    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.light,
      surface: const Color(0xFFF5F5F0),
    );

    final textTheme = GoogleFonts.nunitoSansTextTheme().copyWith(
      headlineMedium: GoogleFonts.nunitoSans(
        fontSize: 26,
        fontWeight: FontWeight.w900,
        color: const Color(0xFF141414),
      ),
      titleLarge: GoogleFonts.nunitoSans(
        fontSize: 21,
        fontWeight: FontWeight.w800,
        color: const Color(0xFF171717),
      ),
      titleMedium: GoogleFonts.nunitoSans(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: const Color(0xFF171717),
      ),
      bodyLarge: GoogleFonts.nunitoSans(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF232323),
      ),
      bodyMedium: GoogleFonts.nunitoSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF5F655B),
      ),
      bodySmall: GoogleFonts.nunitoSans(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF7B8176),
      ),
      labelLarge: GoogleFonts.nunitoSans(
        fontSize: 13,
        fontWeight: FontWeight.w800,
        color: seedColor,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFFF3F3EE),
      textTheme: textTheme,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }
}
