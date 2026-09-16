import 'package:flutter/material.dart';

class DriverApprovalScreen extends StatefulWidget {
  const DriverApprovalScreen({super.key});

  @override
  State<DriverApprovalScreen> createState() => _DriverApprovalScreenState();
}

class _DriverApprovalScreenState extends State<DriverApprovalScreen> {
  String status = 'Pendiente';

  final docs = <Map<String, String>>[
    {'name': 'Identificación oficial', 'status': 'Pendiente'},
    {'name': 'Licencia', 'status': 'Pendiente'},
    {'name': 'Tarjeta de circulación', 'status': 'Pendiente'},
    {'name': 'Comprobante de domicilio', 'status': 'Pendiente'},
    {'name': 'Foto de la moto', 'status': 'Pendiente'},
  ];

  bool get allApproved => docs.every((d) => d['status'] == 'Aprobado');

  void updateDoc(int index, String newStatus) {
    setState(() => docs[index]['status'] = newStatus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Revisión de conductor')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Card(
            child: ListTile(
              leading: CircleAvatar(child: Icon(Icons.person)),
              title: Text('Conductor demo'),
              subtitle: Text('Moto · placa demo · sindicato demo'),
            ),
          ),
          const SizedBox(height: 8),
          ...List.generate(docs.length, (index) {
            final doc = docs[index];
            return Card(
              child: ListTile(
                title: Text(doc['name']!),
                subtitle: Text('Estado: ${doc['status']}'),
                trailing: PopupMenuButton<String>(
                  onSelected: (v) => updateDoc(index, v),
                  itemBuilder: (_) => const [
                    PopupMenuItem(
                      value: 'Aprobado',
                      child: Text('Aprobar'),
                    ),
                    PopupMenuItem(
                      value: 'Rechazado',
                      child: Text('Rechazar'),
                    ),
                    PopupMenuItem(
                      value: 'Pendiente',
                      child: Text('Pendiente'),
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: allApproved
                ? () => setState(() => status = 'Aprobado')
                : null,
            icon: const Icon(Icons.verified),
            label: const Text('Aprobar conductor'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => setState(() => status = 'Rechazado'),
            icon: const Icon(Icons.block),
            label: const Text('Rechazar conductor'),
          ),
          const SizedBox(height: 12),
          Text(
            'Estado final: $status',
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
