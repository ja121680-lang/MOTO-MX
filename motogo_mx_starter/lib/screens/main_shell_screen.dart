import 'package:flutter/material.dart';

import '../l10n/app_strings.dart';
import '../theme/app_theme.dart';
import 'activity_screen.dart';
import 'home_screen.dart';
import 'my_trips_screen.dart';
import 'profile_screen.dart';

/// Real passenger navigation — four sections, each a genuine destination
/// with its own content (Paquete 01, "Navegación base"). Replaces the old
/// `/home` route that opened [HomeScreen] directly with no way to reach
/// trips, activity or profile except ad-hoc buttons.
class MainShellScreen extends StatefulWidget {
  const MainShellScreen({super.key});

  /// Lets another screen (e.g. after submitting a rating) send the user to
  /// a specific tab instead of just popping back to whatever was on top.
  static final ValueNotifier<int> requestedTab = ValueNotifier<int>(0);

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int index = 0;

  static const _screens = [
    HomeScreen(),
    MyTripsScreen(),
    ActivityScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    MainShellScreen.requestedTab.addListener(_onRequestedTab);
  }

  @override
  void dispose() {
    MainShellScreen.requestedTab.removeListener(_onRequestedTab);
    super.dispose();
  }

  void _onRequestedTab() {
    if (!mounted) return;
    setState(() => index = MainShellScreen.requestedTab.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: index, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) => setState(() => index = value),
        backgroundColor: AppTheme.surface,
        indicatorColor: AppTheme.primaryYellow.withValues(alpha: 0.18),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home, color: AppTheme.primaryYellow),
            label: S.t('Inicio'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.receipt_long_outlined),
            selectedIcon: const Icon(Icons.receipt_long, color: AppTheme.primaryYellow),
            label: S.t('Mis viajes'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.notifications_outlined),
            selectedIcon: const Icon(Icons.notifications, color: AppTheme.primaryYellow),
            label: S.t('Actividad'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person, color: AppTheme.primaryYellow),
            label: S.t('Perfil'),
          ),
        ],
      ),
    );
  }
}
