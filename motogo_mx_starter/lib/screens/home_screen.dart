import 'package:flutter/material.dart';

import '../l10n/app_strings.dart';
import '../theme/app_theme.dart';

/// Passenger home (Paquete 01). Replaces the old technical menu
/// ("Pedir una moto" / "Modo conductor" / "Panel administrador" /
/// "Ver conductores cercanos") with a real ride-hailing home: a single,
/// obvious way to say where you're going. A person should understand in
/// under 3 seconds that they can request a mototaxi here.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? S.t('Buenos días')
        : (hour < 19 ? S.t('Buenas tardes') : S.t('Buenas noches'));

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
                    Text('$greeting · ${S.t('MotoGo MX')}',
                        style: const TextStyle(color: AppTheme.textMuted, fontSize: 13)),
                    const SizedBox(height: 4),
                    Text(S.t('¿A dónde vamos?'), style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.place_outlined, size: 15, color: AppTheme.textMuted),
                        const SizedBox(width: 4),
                        Text(
                          S.t('Ubicación por confirmar'),
                          style: const TextStyle(color: AppTheme.textMuted, fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
                const TextScaleToggleButton(),
              ],
            ),
            const SizedBox(height: AppSpace.xxl),
            // Primary CTA — the one thing this screen is for.
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
                    border: Border.all(color: AppTheme.primaryYellow.withValues(alpha: 0.5), width: 1.5),
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
                            Text(S.t('¿A dónde quieres ir?'), style: Theme.of(context).textTheme.titleLarge),
                            const SizedBox(height: 4),
                            Text(
                              S.t('Toca para elegir tu destino'),
                              style: const TextStyle(color: AppTheme.textMuted, fontSize: 13),
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
            const SizedBox(height: AppSpace.md),
            TextButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/request'),
              icon: const Icon(Icons.map_outlined, size: 18),
              label: Text(S.t('Elegir en mapa')),
            ),
            const SizedBox(height: AppSpace.xl),
            // Compact safety card — trust signals up front, always visible.
            Container(
              padding: const EdgeInsets.all(AppSpace.lg),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppTheme.divider),
              ),
              child: Row(
                children: [
                  const Icon(Icons.shield_outlined, color: AppTheme.goldLight, size: 22),
                  const SizedBox(width: AppSpace.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(S.t('Tu seguridad primero'),
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                        const SizedBox(height: 2),
                        Text(
                          S.t('Conductores validados · PIN de inicio · Botón SOS'),
                          style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
