import 'package:flutter/material.dart';

import '../config/pricing_config.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final feePct = (PricingConfig.platformFeeRate * 100).toStringAsFixed(0);
    return Scaffold(
      appBar: AppBar(title: const Text('Administración')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.person_search),
                title: const Text('Aprobaciones'),
                subtitle: const Text('Conductores y documentos pendientes'),
                onTap: () => Navigator.pushNamed(context, '/driver-approval'),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.route),
                title: const Text('Viajes'),
                subtitle: const Text('Seguimiento, incidencias e historial'),
                onTap: () => Navigator.pushNamed(context, '/history'),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.percent),
                title: const Text('Comisión / Corte de caja'),
                subtitle: Text('Regla actual: $feePct% — ver totales reales'),
                onTap: () => Navigator.pushNamed(context, '/corte-de-caja'),
              ),
            ),
            const Card(
              child: ListTile(
                leading: Icon(Icons.warning_amber),
                title: Text('Seguridad'),
                subtitle: Text('SOS, reportes y bloqueos'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
