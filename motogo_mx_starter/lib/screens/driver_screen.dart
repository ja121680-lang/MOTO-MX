import 'package:flutter/material.dart';

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
            FilledButton.icon(
              onPressed: () =>
                  Navigator.pushNamed(context, '/driver-registration'),
              icon: const Icon(Icons.app_registration),
              label: const Text('Completar registro de conductor'),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              value: online,
              onChanged: (v) => setState(() => online = v),
              title: Text(online ? 'Disponible' : 'Fuera de línea'),
              subtitle: const Text('Estado para recibir solicitudes'),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.account_balance_wallet),
                title: const Text('Wallet'),
                subtitle: const Text('Saldo, comisiones y retiros'),
                onTap: () => Navigator.pushNamed(context, '/wallet'),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.workspace_premium),
                title: const Text('Nivel Diamond'),
                subtitle: const Text('Beneficios y requisitos'),
                onTap: () => Navigator.pushNamed(context, '/diamond'),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.history),
                title: const Text('Historial'),
                subtitle: const Text('Viajes y movimientos'),
                onTap: () => Navigator.pushNamed(context, '/history'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
