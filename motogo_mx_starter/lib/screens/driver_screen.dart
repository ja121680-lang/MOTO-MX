import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class DriverScreen extends StatefulWidget {
  const DriverScreen({super.key});

  @override
  State<DriverScreen> createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {
  bool online = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Conductor')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: online ? AppTheme.success.withOpacity(0.12) : AppTheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: online ? AppTheme.success : AppTheme.divider),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: online ? AppTheme.success : AppTheme.surfaceMuted,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      online ? Icons.check : Icons.pause,
                      color: online ? Colors.black : AppTheme.textMuted,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          online ? 'Disponible' : 'Fuera de línea',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const Text('Estado para recibir solicitudes', style: TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                      ],
                    ),
                  ),
                  Switch(value: online, onChanged: (v) => setState(() => online = v)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/driver-registration'),
              icon: const Icon(Icons.app_registration),
              label: const Text('Completar registro de conductor'),
            ),
            const SizedBox(height: 20),
            const Text('Accesos rápidos', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.textMuted)),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const Icon(Icons.account_balance_wallet),
                title: const Text('Wallet'),
                subtitle: const Text('Saldo, comisiones y retiros'),
                trailing: const Icon(Icons.chevron_right, color: AppTheme.textMuted),
                onTap: () => Navigator.pushNamed(context, '/wallet'),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.workspace_premium, color: Color(0xFF60D6F0)),
                title: const Text('Nivel Diamond'),
                subtitle: const Text('Beneficios y requisitos'),
                trailing: const Icon(Icons.chevron_right, color: AppTheme.textMuted),
                onTap: () => Navigator.pushNamed(context, '/diamond'),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.history),
                title: const Text('Historial'),
                subtitle: const Text('Viajes y movimientos'),
                trailing: const Icon(Icons.chevron_right, color: AppTheme.textMuted),
                onTap: () => Navigator.pushNamed(context, '/history'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
