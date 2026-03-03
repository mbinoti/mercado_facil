import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Centraliza a configuracao visual global do aplicativo.
///
/// Hoje a classe expoe apenas o tema claro, com base no seed verde da marca
/// e tipografia Nunito Sans aplicada aos principais estilos de texto.
class AppTheme {
  static const seedColor = Color(0xFF0CB05A);
  static const scaffoldColor = Color(0xFFF3F3EE);
  static const appBarForegroundColor = Color(0xFF141414);

  /// Monta o `ThemeData` padrao usado pelo `MaterialApp`.
  static ThemeData lightTheme({
    TargetPlatform platform = TargetPlatform.android,
  }) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.light,
      surface: const Color(0xFFF5F5F0),
    );

    final baseTheme = ThemeData(
      platform: platform,
      useMaterial3: true,
      colorScheme: colorScheme,
    );
    final baseTextTheme = baseTheme.textTheme;
    final textTheme = GoogleFonts.nunitoSansTextTheme(baseTextTheme).copyWith(
      headlineMedium: GoogleFonts.nunitoSans(
        textStyle: baseTextTheme.headlineMedium,
        fontSize: 26,
        fontWeight: FontWeight.w900,
        color: const Color(0xFF141414),
      ),
      titleLarge: GoogleFonts.nunitoSans(
        textStyle: baseTextTheme.titleLarge,
        fontSize: 21,
        fontWeight: FontWeight.w800,
        color: const Color(0xFF171717),
      ),
      titleMedium: GoogleFonts.nunitoSans(
        textStyle: baseTextTheme.titleMedium,
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: const Color(0xFF171717),
      ),
      bodyLarge: GoogleFonts.nunitoSans(
        textStyle: baseTextTheme.bodyLarge,
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF232323),
      ),
      bodyMedium: GoogleFonts.nunitoSans(
        textStyle: baseTextTheme.bodyMedium,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF5F655B),
      ),
      bodySmall: GoogleFonts.nunitoSans(
        textStyle: baseTextTheme.bodySmall,
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF7B8176),
      ),
      labelLarge: GoogleFonts.nunitoSans(
        textStyle: baseTextTheme.labelLarge,
        fontSize: 13,
        fontWeight: FontWeight.w800,
        color: seedColor,
      ),
    );

    return baseTheme.copyWith(
      scaffoldBackgroundColor: scaffoldColor,
      textTheme: textTheme,
      cupertinoOverrideTheme: cupertinoTheme(),
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: appBarForegroundColor,
      ),
    );
  }

  /// Tema base usado pelos widgets Cupertino no iOS.
  static CupertinoThemeData cupertinoTheme() {
    const baseTheme = CupertinoThemeData(brightness: Brightness.light);
    final baseTextTheme = baseTheme.textTheme;
    final baseTextStyle = GoogleFonts.nunitoSans(
      textStyle: baseTextTheme.textStyle,
      color: appBarForegroundColor,
      fontSize: 15,
      fontWeight: FontWeight.w700,
    );

    return CupertinoThemeData(
      brightness: Brightness.light,
      primaryColor: seedColor,
      scaffoldBackgroundColor: scaffoldColor,
      barBackgroundColor: scaffoldColor.withValues(alpha: 0.94),
      textTheme: CupertinoTextThemeData(
        textStyle: baseTextStyle,
        navTitleTextStyle: GoogleFonts.nunitoSans(
          textStyle: baseTextTheme.navTitleTextStyle,
          fontSize: 17,
          fontWeight: FontWeight.w800,
          color: appBarForegroundColor,
        ),
        navLargeTitleTextStyle: GoogleFonts.nunitoSans(
          textStyle: baseTextTheme.navLargeTitleTextStyle,
          fontSize: 32,
          fontWeight: FontWeight.w900,
          color: appBarForegroundColor,
        ),
      ),
    );
  }
}
