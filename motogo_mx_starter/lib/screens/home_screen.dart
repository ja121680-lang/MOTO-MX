import 'package:flutter/material.dart';
import '../services/lock_service.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.two_wheeler, color: AppTheme.primaryYellow),
            const SizedBox(width: 8),
            const Text('MotoGo MX'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.lock_outline),
            tooltip: 'Bloquear aplicación',
            onPressed: () {
              LockService.sessionUnlocked = false;
              Navigator.of(context).pushReplacementNamed('/lock');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Primary CTA: answers "¿A dónde vas?" immediately.
              Material(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => Navigator.pushNamed(context, '/request'),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.primaryYellow, width: 1.5),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            color: AppTheme.primaryYellow,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.search, color: Colors.black),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '¿A dónde vas?',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
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
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _QuickAction(
                      icon: Icons.history,
                      label: 'Mis viajes',
                      onTap: () => Navigator.pushNamed(context, '/history'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _QuickAction(
                      icon: Icons.account_balance_wallet_outlined,
                      label: 'Wallet',
                      onTap: () => Navigator.pushNamed(context, '/wallet'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _QuickAction(
                      icon: Icons.radar,
                      label: 'Cerca de ti',
                      onTap: () => Navigator.pushNamed(context, '/nearby-drivers'),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Secondary entry points — not the customer-facing primary flow.
              const Divider(),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () => Navigator.pushNamed(context, '/driver'),
                      icon: const Icon(Icons.badge_outlined, size: 18),
                      label: const Text('Modo conductor'),
                    ),
                  ),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () => Navigator.pushNamed(context, '/admin'),
                      icon: const Icon(Icons.admin_panel_settings_outlined, size: 18),
                      label: const Text('Administrador'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: AppTheme.surfaceMuted,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppTheme.primaryYellow, size: 24),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
