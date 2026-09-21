import 'package:flutter/material.dart';

import '../services/text_scale_service.dart';

/// GA APP STANDARD 2026 — spacing scale shared across every screen so
/// paddings/gaps stop being ad-hoc magic numbers.
class AppSpace {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
}

/// GA APP STANDARD 2026 — corner-radius scale. Small controls get [sm],
/// cards/inputs get [md], hero/primary surfaces get [lg].
class AppRadius {
  static const double sm = 10;
  static const double md = 16;
  static const double lg = 22;
  static const double pill = 999;
}

/// Single source of truth for MotoGo MX's design system — dark, energetic,
/// built for legibility outdoors (drivers checking the screen mid-ride).
class AppTheme {
  static const Color primaryYellow = Color(0xFFFFC800);
  static const Color primaryYellowDeep = Color(0xFFE6A800);
  static const Color accentRed = Color(0xFFEF4444);
  static const Color background = Color(0xFF0D0F13);
  static const Color surface = Color(0xFF1A1D24);
  static const Color surfaceElevated = Color(0xFF21242C);
  static const Color surfaceMuted = Color(0xFF23262E);
  static const Color textLight = Color(0xFFF5F5F7);
  static const Color textMuted = Color(0xFF9AA0AC);
  static const Color success = Color(0xFF22C55E);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color divider = Color(0xFF2E323C);

  /// Warm gradient for the app's primary calls-to-action — replaces flat
  /// yellow fills on the highest-priority buttons/hero cards.
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryYellow, primaryYellowDeep],
  );

  /// Soft glow used behind elevated hero surfaces (cards, primary CTA) so
  /// dark-mode UI still reads as "lifted" instead of flat borders only.
  static List<BoxShadow> glow(Color color, {double opacity = 0.18}) => [
        BoxShadow(color: color.withOpacity(opacity), blurRadius: 24, offset: const Offset(0, 10)),
      ];

  static List<BoxShadow> get cardShadow => [
        BoxShadow(color: Colors.black.withOpacity(0.28), blurRadius: 16, offset: const Offset(0, 6)),
      ];

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
          fontSize: 19,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardTheme(
        color: surfaceElevated,
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
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textLight,
          minimumSize: const Size.fromHeight(56),
          side: const BorderSide(color: divider),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
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
        displaySmall: TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: textLight, letterSpacing: -0.5),
        headlineMedium: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: textLight, letterSpacing: -0.5),
        headlineSmall: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: textLight),
        titleLarge: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: textLight),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textLight),
        bodyLarge: TextStyle(fontSize: 17, color: textLight),
        bodyMedium: TextStyle(fontSize: 15.5, color: textLight),
        bodySmall: TextStyle(fontSize: 13.5, color: textMuted),
        labelLarge: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: textLight),
      ),
    );
  }
}

/// Circular icon badge with the primary gradient — the consistent way to
/// present a leading icon on hero cards, KPI tiles and list rows across the
/// GA APP STANDARD 2026 system.
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
      decoration: BoxDecoration(gradient: gradient, shape: BoxShape.circle),
      child: Icon(icon, color: iconColor, size: size * 0.46),
    );
  }
}

/// Round "Aa" button that lets the user cycle the app's text size
/// (Normal → Grande → Muy grande, persisted). Belongs next to any screen's
/// primary app-bar actions so the control is always reachable.
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
                  style: TextStyle(fontWeight: FontWeight.w800, color: AppTheme.textLight, fontSize: 15),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Uppercase, letter-spaced eyebrow label used to introduce a section —
/// replaces bare bold `Text` so every screen groups content the same way.
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
