import 'package:flutter/material.dart';

import '../config/pricing_config.dart';
import '../theme/app_theme.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final feePct = (PricingConfig.platformFeeRate * 100).toStringAsFixed(0);
    return Scaffold(
      appBar: AppBar(title: const Text('Administración')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpace.xl),
        children: [
          Card(
            child: ListTile(
              leading: const GradientIconBadge(icon: Icons.person_search, size: 44),
              title: const Text('Aprobaciones'),
              subtitle: const Text('Conductores y documentos pendientes'),
              trailing: const Icon(Icons.chevron_right, color: AppTheme.textMuted),
              onTap: () => Navigator.pushNamed(context, '/driver-approval'),
            ),
          ),
          Card(
            child: ListTile(
              leading: const GradientIconBadge(icon: Icons.route, size: 44),
              title: const Text('Viajes'),
              subtitle: const Text('Seguimiento, incidencias e historial'),
              trailing: const Icon(Icons.chevron_right, color: AppTheme.textMuted),
              onTap: () => Navigator.pushNamed(context, '/history'),
            ),
          ),
          Card(
            child: ListTile(
              leading: const GradientIconBadge(icon: Icons.percent, size: 44),
              title: const Text('Comisión / Corte de caja'),
              subtitle: Text('Regla actual: $feePct% — ver totales reales'),
              trailing: const Icon(Icons.chevron_right, color: AppTheme.textMuted),
              onTap: () => Navigator.pushNamed(context, '/corte-de-caja'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(color: AppTheme.error.withOpacity(0.15), shape: BoxShape.circle),
                child: const Icon(Icons.warning_amber, color: AppTheme.error),
              ),
              title: const Text('Seguridad'),
              subtitle: const Text('SOS, reportes y bloqueos'),
            ),
          ),
        ],
      ),
    );
  }
}
