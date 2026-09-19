import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

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
          final status = trip['status'] as String;
          final isCompleted = status == 'Completado';
          return Card(
            child: ListTile(
              leading: Icon(
                isCompleted ? Icons.check_circle_outline : Icons.cancel_outlined,
                color: isCompleted ? AppTheme.success : AppTheme.error,
              ),
              title: Text(trip['id'] as String),
              subtitle: Text('${trip['route']}'),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${(trip['fare'] as double).toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  StatusBadge(
                    label: status,
                    color: isCompleted ? AppTheme.success : AppTheme.error,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
