import 'package:flutter/material.dart';

/// Single source of truth for MotoGo MX's design system — dark, energetic,
/// built for legibility outdoors (drivers checking the screen mid-ride).
class AppTheme {
  static const Color primaryYellow = Color(0xFFFFC800);
  static const Color accentRed = Color(0xFFEF4444);
  static const Color background = Color(0xFF0F1115);
  static const Color surface = Color(0xFF1A1D24);
  static const Color surfaceMuted = Color(0xFF23262E);
  static const Color textLight = Color(0xFFF5F5F7);
  static const Color textMuted = Color(0xFF9AA0AC);
  static const Color success = Color(0xFF22C55E);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color divider = Color(0xFF2E323C);

  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryYellow,
      brightness: Brightness.dark,
      surface: surface,
    ).copyWith(primary: primaryYellow, error: error);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: textLight,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: textLight,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardTheme(
        color: surface,
        elevation: 0,
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: divider),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primaryYellow,
          foregroundColor: Colors.black,
          disabledBackgroundColor: divider,
          disabledForegroundColor: textMuted,
          minimumSize: const Size.fromHeight(54),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textLight,
          minimumSize: const Size.fromHeight(54),
          side: const BorderSide(color: divider),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: primaryYellow),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceMuted,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primaryYellow, width: 1.5),
        ),
        labelStyle: const TextStyle(color: textMuted),
        hintStyle: const TextStyle(color: textMuted),
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: primaryYellow,
        textColor: textLight,
      ),
      dividerTheme: const DividerThemeData(color: divider, thickness: 1),
      sliderTheme: SliderThemeData(
        activeTrackColor: primaryYellow,
        thumbColor: primaryYellow,
        inactiveTrackColor: divider,
        valueIndicatorColor: surfaceMuted,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? primaryYellow : textMuted,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? primaryYellow.withOpacity(0.4)
              : divider,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: surfaceMuted,
        contentTextStyle: const TextStyle(color: textLight),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      textTheme: const TextTheme(
        headlineSmall: TextStyle(fontWeight: FontWeight.bold, color: textLight),
        titleLarge: TextStyle(fontWeight: FontWeight.bold, color: textLight),
        titleMedium: TextStyle(fontWeight: FontWeight.w600, color: textLight),
        bodyMedium: TextStyle(color: textLight),
        bodySmall: TextStyle(color: textMuted),
      ),
    );
  }
}

/// Small rounded status pill used across matching/tracking/wallet screens.
class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w700),
      ),
    );
  }
}
