import 'package:flutter/material.dart';

class TripHistoryScreen extends StatelessWidget {
  const TripHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final trips = [
      {
        'id': 'MGX-1048',
        'route': 'Centro → Región 92',
        'fare': 90.0,
        'status': 'Completado',
      },
      {
        'id': 'MGX-1047',
        'route': 'Av. Tulum → Mercado 28',
        'fare': 64.0,
        'status': 'Completado',
      },
      {
        'id': 'MGX-1046',
        'route': 'SM 20 → Terminal',
        'fare': 110.0,
        'status': 'Cancelado',
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Historial de viajes')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: trips.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, index) {
          final trip = trips[index];
          return Card(
            child: ListTile(
              title: Text('${trip['id']} · ${trip['status']}'),
              subtitle: Text('${trip['route']}'),
              trailing: Text('\$${(trip['fare'] as double).toStringAsFixed(2)}'),
            ),
          );
        },
      ),
    );
  }
}
