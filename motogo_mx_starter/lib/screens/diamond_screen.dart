import 'package:flutter/material.dart';
import '../services/diamond_service.dart';

class DiamondScreen extends StatelessWidget {
  const DiamondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const service = DiamondService();
    const trips = 134;
    const rating = 4.91;
    const cancellation = 0.05;
    final qualified = service.qualifies(
      completedTrips: trips,
      rating: rating,
      cancellationRate: cancellation,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Diamond')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.workspace_premium, size: 42),
              title: Text(qualified ? 'Diamond activo' : 'En progreso'),
              subtitle: const Text(
                'Nivel de confianza y beneficios del conductor.',
              ),
            ),
          ),
          Card(
            child: Column(
              children: [
                ListTile(
                  title: const Text('Viajes completados'),
                  trailing: Text('$trips'),
                ),
                ListTile(
                  title: const Text('Calificación'),
                  trailing: Text('$rating ★'),
                ),
                ListTile(
                  title: const Text('Cancelaciones'),
                  trailing:
                      Text('${(cancellation * 100).toStringAsFixed(1)}%'),
                ),
              ],
            ),
          ),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Criterios demo: 100 viajes, calificación mínima 4.8 y cancelación máxima 8%.',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
