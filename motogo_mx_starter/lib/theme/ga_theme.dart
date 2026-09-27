import 'package:flutter/material.dart';

class GAColors {
  static const black = Color(0xFF050505);
  static const surface = Color(0xFF111111);
  static const surface2 = Color(0xFF181818);
  static const gold = Color(0xFFD4AF37);
  static const goldLight = Color(0xFFF1D36D);
  static const goldDark = Color(0xFF8E6F18);
  static const white = Color(0xFFF8F8F8);
  static const muted = Color(0xFFC9C9C9);
  static const line = Color(0xFF4A3B12);
  static const success = Color(0xFF67D391);
  static const warning = Color(0xFFF1C75B);
  static const danger = Color(0xFFFF6B6B);
}

class GATheme {
  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: GAColors.gold,
      brightness: Brightness.dark,
      primary: GAColors.gold,
      secondary: GAColors.goldLight,
      surface: GAColors.surface,
      error: GAColors.danger,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: GAColors.black,
      colorScheme: scheme,
      fontFamily: 'Roboto',
      textTheme: const TextTheme(
        displayLarge: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w900,
            color: GAColors.white,
            height: 1.05),
        headlineLarge: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w900,
            color: GAColors.white,
            height: 1.1),
        headlineMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: GAColors.white,
            height: 1.15),
        titleLarge: TextStyle(
            fontSize: 21, fontWeight: FontWeight.w800, color: GAColors.white),
        titleMedium: TextStyle(
            fontSize: 18, fontWeight: FontWeight.w700, color: GAColors.white),
        bodyLarge: TextStyle(fontSize: 17, color: GAColors.white, height: 1.45),
        bodyMedium:
            TextStyle(fontSize: 16, color: GAColors.muted, height: 1.45),
        labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: GAColors.black,
        foregroundColor: GAColors.white,
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
            fontSize: 21, fontWeight: FontWeight.w900, color: GAColors.white),
        iconTheme: IconThemeData(color: GAColors.goldLight, size: 28),
      ),
      cardTheme: CardThemeData(
        color: GAColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: GAColors.line),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: GAColors.goldLight,
          foregroundColor: GAColors.black,
          minimumSize: const Size.fromHeight(54),
          textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: GAColors.goldLight,
          minimumSize: const Size.fromHeight(52),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          side: const BorderSide(color: GAColors.gold, width: 1.4),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: GAColors.surface2,
        hintStyle: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 16),
        labelStyle: const TextStyle(color: GAColors.muted, fontSize: 16),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: GAColors.line)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: GAColors.line)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: GAColors.goldLight, width: 2)),
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: GAColors.surface,
        indicatorColor: Color(0x332D2410),
        height: 76,
        labelTextStyle: WidgetStatePropertyAll(
            TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
        iconTheme: WidgetStatePropertyAll(IconThemeData(size: 27)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: GAColors.surface,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: const BorderSide(color: GAColors.goldDark)),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: GAColors.surface2,
        contentTextStyle: const TextStyle(color: GAColors.white, fontSize: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        behavior: SnackBarBehavior.floating,
      ),
      dividerColor: GAColors.line,
    );
  }
}
