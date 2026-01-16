import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const kGreen = Color(0xFF22C55E);
const kGreenDark = Color(0xFF16A34A);
const kBackground = Color(0xFFF6F8F6);
const kTextDark = Color(0xFF0F172A);
const kTextMuted = Color(0xFF6B7280);
const kBorder = Color(0xFFE2E8F0);
const kShadow = Color(0x14000000);
const kDanger = Color(0xFFF87171);
const kBlack = Color(0xFF0B0B0B);

ThemeData buildAppTheme() {
  final base = ThemeData(useMaterial3: true);
  final baseTextTheme = GoogleFonts.manropeTextTheme(base.textTheme);
  return base.copyWith(
    colorScheme: ColorScheme.fromSeed(
      seedColor: kGreen,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: kBackground,
    appBarTheme: AppBarTheme(
      backgroundColor: kBackground,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.manrope(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: kTextDark,
        letterSpacing: -0.2,
      ),
      iconTheme: const IconThemeData(color: kTextDark),
    ),
    textTheme: baseTextTheme.copyWith(
      headlineSmall: baseTextTheme.headlineSmall?.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.4,
        color: kTextDark,
      ),
      titleLarge: baseTextTheme.titleLarge?.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
        color: kTextDark,
      ),
      titleMedium: baseTextTheme.titleMedium?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.1,
        color: kTextDark,
      ),
      bodyMedium: baseTextTheme.bodyMedium?.copyWith(
        fontSize: 14,
        color: kTextMuted,
      ),
      bodySmall: baseTextTheme.bodySmall?.copyWith(
        fontSize: 12,
        color: kTextMuted,
      ),
    ),
  );
}

BoxDecoration cardDecoration({double radius = 18, Color color = Colors.white}) {
  return BoxDecoration(
    color: color,
    borderRadius: BorderRadius.circular(radius),
    boxShadow: const [
      BoxShadow(
        color: kShadow,
        blurRadius: 16,
        offset: Offset(0, 6),
      ),
    ],
  );
}

InputDecoration appInputDecoration({
  required String hint,
  IconData? icon,
  Widget? suffix,
}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: kTextMuted),
    prefixIcon: icon != null ? Icon(icon, color: kTextMuted) : null,
    suffixIcon: suffix,
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: kBorder),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: kBorder),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: kGreen),
    ),
  );
}
