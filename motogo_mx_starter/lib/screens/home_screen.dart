import 'package:flutter/material.dart';
import '../services/lock_service.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12 ? 'Buenos días' : (hour < 19 ? 'Buenas tardes' : 'Buenas noches');

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(AppSpace.xl, AppSpace.lg, AppSpace.xl, AppSpace.xl),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(greeting, style: const TextStyle(color: AppTheme.textMuted, fontSize: 14)),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.two_wheeler, color: AppTheme.primaryYellow, size: 22),
                        const SizedBox(width: 6),
                        Text('MotoGo MX', style: Theme.of(context).textTheme.headlineSmall),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    const TextScaleToggleButton(),
                    const SizedBox(width: AppSpace.sm),
                    _RoundIconButton(
                      icon: Icons.lock_outline,
                      tooltip: 'Bloquear aplicación',
                      onPressed: () {
                        LockService.sessionUnlocked = false;
                        Navigator.of(context).pushReplacementNamed('/lock');
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSpace.xxl),
            // Primary CTA: answers "¿A dónde vas?" immediately.
            Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              child: InkWell(
                borderRadius: BorderRadius.circular(AppRadius.lg),
                onTap: () => Navigator.pushNamed(context, '/request'),
                child: Container(
                  padding: const EdgeInsets.all(AppSpace.xl),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceElevated,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    border: Border.all(color: AppTheme.primaryYellow.withOpacity(0.5), width: 1.5),
                    boxShadow: AppTheme.glow(AppTheme.primaryYellow),
                  ),
                  child: Row(
                    children: [
                      const GradientIconBadge(icon: Icons.search),
                      const SizedBox(width: AppSpace.lg),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('¿A dónde vas?', style: Theme.of(context).textTheme.titleLarge),
                            const SizedBox(height: 4),
                            const Text(
                              'Toca para pedir una moto',
                              style: TextStyle(color: AppTheme.textMuted, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: AppTheme.textMuted),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpace.xxl),
            const SectionHeader('Accesos rápidos'),
            const SizedBox(height: AppSpace.md),
            Row(
              children: [
                Expanded(
                  child: _QuickAction(
                    icon: Icons.history,
                    label: 'Mis viajes',
                    color: AppTheme.primaryYellow,
                    onTap: () => Navigator.pushNamed(context, '/history'),
                  ),
                ),
                const SizedBox(width: AppSpace.md),
                Expanded(
                  child: _QuickAction(
                    icon: Icons.account_balance_wallet_outlined,
                    label: 'Wallet',
                    color: AppTheme.success,
                    onTap: () => Navigator.pushNamed(context, '/wallet'),
                  ),
                ),
                const SizedBox(width: AppSpace.md),
                Expanded(
                  child: _QuickAction(
                    icon: Icons.radar,
                    label: 'Cerca de ti',
                    color: AppTheme.warning,
                    onTap: () => Navigator.pushNamed(context, '/nearby-drivers'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpace.xxxl),
            // Secondary entry points — not the customer-facing primary flow.
            const SectionHeader('Otros accesos'),
            const SizedBox(height: AppSpace.sm),
            _SecondaryLink(
              icon: Icons.badge_outlined,
              label: 'Modo conductor',
              onTap: () => Navigator.pushNamed(context, '/driver'),
            ),
            _SecondaryLink(
              icon: Icons.admin_panel_settings_outlined,
              label: 'Administrador',
              onTap: () => Navigator.pushNamed(context, '/admin'),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({required this.icon, required this.onPressed, this.tooltip});

  final IconData icon;
  final VoidCallback onPressed;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.surfaceMuted,
      shape: const CircleBorder(),
      child: IconButton(icon: Icon(icon), tooltip: tooltip, onPressed: onPressed),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.color,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.md),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpace.lg),
        decoration: BoxDecoration(
          color: AppTheme.surfaceMuted,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppTheme.divider),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: color.withOpacity(0.15), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: AppSpace.sm),
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _SecondaryLink extends StatelessWidget {
  const _SecondaryLink({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.md),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpace.sm),
        padding: const EdgeInsets.symmetric(horizontal: AppSpace.lg, vertical: AppSpace.md),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppTheme.textMuted),
            const SizedBox(width: AppSpace.md),
            Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600))),
            const Icon(Icons.chevron_right, size: 18, color: AppTheme.textMuted),
          ],
        ),
      ),
    );
  }
}
