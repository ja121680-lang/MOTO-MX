import 'package:flutter/material.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            const Card(
              child: ListTile(
                leading: Icon(Icons.route),
                title: Text('Viajes'),
                subtitle: Text('Seguimiento, incidencias e historial'),
              ),
            ),
            const Card(
              child: ListTile(
                leading: Icon(Icons.percent),
                title: Text('Comisión'),
                subtitle: Text('Regla actual: 8%'),
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
