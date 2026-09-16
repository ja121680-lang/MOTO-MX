import 'package:flutter/material.dart';
import '../services/driver_matching_service.dart';

class NearbyDriversScreen extends StatelessWidget {
  const NearbyDriversScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final drivers = const DriverMatchingService().nearbyDrivers();

    return Scaffold(
      appBar: AppBar(title: const Text('Conductores cercanos')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: drivers.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, index) {
          final d = drivers[index];
          return Card(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.two_wheeler)),
              title: Text('${d.name} · ${d.rating} ★'),
              subtitle: Text(
                '${d.distanceKm.toStringAsFixed(1)} km · ${d.etaMinutes} min\n'
                '${d.plate} · Econ. ${d.economicNumber} · ${d.unionName}',
              ),
            ),
          );
        },
      ),
    );
  }
}
