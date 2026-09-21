import 'package:flutter/material.dart';
import '../services/driver_matching_service.dart';
import '../theme/app_theme.dart';

class NearbyDriversScreen extends StatelessWidget {
  const NearbyDriversScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final drivers = const DriverMatchingService().nearbyDrivers();

    return Scaffold(
      appBar: AppBar(title: const Text('Conductores cercanos')),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSpace.lg),
        itemCount: drivers.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpace.sm),
        itemBuilder: (_, index) {
          final d = drivers[index];
          return Card(
            child: ListTile(
              leading: const GradientIconBadge(icon: Icons.two_wheeler, size: 44),
              title: Text('${d.name} · ${d.rating} ★', style: const TextStyle(fontWeight: FontWeight.w600)),
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
