import 'package:flutter/material.dart';

import '../services/text_scale_service.dart';

/// GA APP STANDARD 2026 — shared spacing scale.
class AppSpace {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
}

/// GA APP STANDARD 2026 — shared corner-radius scale.
class AppRadius {
  static const double sm = 10;
  static const double md = 16;
  static const double lg = 22;
  static const double pill = 999;
}

/// GA APP STANDARD 2026.
/// Black + GA gold + white. Semantic status colors stay independent so
/// safety/success/error states remain immediately recognizable.
class AppTheme {
  // GA APP STANDARD 2026 — MotoGo MX obligatory palette (Paquete 01).
  static const Color primaryYellow = Color(0xFFD4AF37); // Oro principal
  static const Color primaryYellowDeep = Color(0xFFB8922A); // Oro, tono presionado/gradiente
  static const Color goldLight = Color(0xFFF4D77A); // Oro claro para detalle
  static const Color accentRed = Color(0xFFD92D20); // Error/SOS
  static const Color background = Color(0xFF0B0B0B);
  static const Color surface = Color(0xFF161616);
  static const Color surfaceElevated = Color(0xFF1E1E1E);
  static const Color surfaceMuted = Color(0xFF161616);
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color textMuted = Color(0xFFC9C9C9);
  static const Color success = Color(0xFF2EAD68);
  static const Color error = Color(0xFFD92D20);
  static const Color warning = Color(0xFFF59E0B);
  static const Color divider = Color(0xFF2A2A2A);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryYellow, primaryYellowDeep],
  );

  static List<BoxShadow> glow(Color color, {double opacity = 0.20}) => [
        BoxShadow(
          color: color.withValues(alpha: opacity),
          blurRadius: 24,
          offset: const Offset(0, 10),
        ),
      ];

  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.36),
          blurRadius: 18,
          offset: const Offset(0, 8),
        ),
      ];

  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryYellow,
      brightness: Brightness.dark,
      surface: surface,
    ).copyWith(
      primary: primaryYellow,
      onPrimary: Colors.black,
      secondary: primaryYellowDeep,
      onSecondary: Colors.black,
      surface: surface,
      onSurface: textLight,
      error: error,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      canvasColor: background,
      dividerColor: divider,
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: textLight,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: textLight,
          fontSize: 19,
          fontWeight: FontWeight.w800,
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceElevated,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: const EdgeInsets.only(bottom: AppSpace.md),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: const BorderSide(color: divider),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primaryYellow,
          foregroundColor: Colors.black,
          disabledBackgroundColor: divider,
          disabledForegroundColor: textMuted,
          minimumSize: const Size.fromHeight(56),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryYellow,
          foregroundColor: Colors.black,
          disabledBackgroundColor: divider,
          disabledForegroundColor: textMuted,
          minimumSize: const Size.fromHeight(56),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textLight,
          minimumSize: const Size.fromHeight(56),
          side: const BorderSide(color: primaryYellow),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
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
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: primaryYellow, width: 1.7),
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
          (states) => states.contains(WidgetState.selected) ? Colors.black : textMuted,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? primaryYellow
              : divider,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: surfaceMuted,
        contentTextStyle: const TextStyle(color: textLight),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surfaceElevated,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: const BorderSide(color: divider),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primaryYellow,
        unselectedItemColor: textMuted,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: primaryYellow.withValues(alpha: .18),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            color: states.contains(WidgetState.selected) ? primaryYellow : textMuted,
            fontWeight: states.contains(WidgetState.selected) ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
      textTheme: const TextTheme(
        displaySmall: TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: textLight, letterSpacing: -0.5),
        headlineMedium: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: textLight, letterSpacing: -0.5),
        headlineSmall: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: textLight),
        titleLarge: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: textLight),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textLight),
        bodyLarge: TextStyle(fontSize: 17, color: textLight),
        bodyMedium: TextStyle(fontSize: 15.5, color: textLight),
        bodySmall: TextStyle(fontSize: 13.5, color: textMuted),
        labelLarge: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: textLight),
      ),
    );
  }
}

class GradientIconBadge extends StatelessWidget {
  const GradientIconBadge({
    super.key,
    required this.icon,
    this.size = 48,
    this.iconColor = Colors.black,
    this.gradient = AppTheme.primaryGradient,
  });

  final IconData icon;
  final double size;
  final Color iconColor;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: gradient,
        shape: BoxShape.circle,
        boxShadow: AppTheme.glow(AppTheme.primaryYellow),
      ),
      child: Icon(icon, color: iconColor, size: size * 0.46),
    );
  }
}

class TextScaleToggleButton extends StatelessWidget {
  const TextScaleToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: TextScaleController.instance,
      builder: (context, _) {
        final label = TextScaleController.instance.label;
        return Material(
          color: AppTheme.surfaceMuted,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => TextScaleController.instance.cycle(),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Tooltip(
                message: 'Tamaño de letra: $label. Toca para cambiar.',
                child: const Text(
                  'Aa',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textLight,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader(this.text, {super.key, this.trailing});

  final String text;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text.toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppTheme.textMuted,
            letterSpacing: 0.8,
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w700),
      ),
    );
  }
}
