import 'dart:async';
import 'package:flutter/material.dart';
import '../models/location_point.dart';
import '../services/mock_location_service.dart';
import '../theme/app_theme.dart';

class LiveTrackingScreen extends StatefulWidget {
  const LiveTrackingScreen({super.key});

  @override
  State<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen> {
  final service = MockLocationService();
  StreamSubscription<LocationPoint>? subscription;
  LocationPoint? current;
  int updates = 0;

  @override
  void initState() {
    super.initState();
    subscription = service.stream.listen((point) {
      if (!mounted) return;
      setState(() {
        current = point;
        updates++;
      });
    });
    service.start();
  }

  @override
  void dispose() {
    subscription?.cancel();
    service.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = current;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seguimiento en vivo'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(child: StatusBadge(label: 'EN CAMINO', color: AppTheme.success)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Card(
                child: Center(
                  child: p == null
                      ? const CircularProgressIndicator(color: AppTheme.primaryYellow)
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.two_wheeler, size: 64, color: AppTheme.primaryYellow),
                            const SizedBox(height: 12),
                            Text(
                              'Lat: ${p.lat.toStringAsFixed(5)}\n'
                              'Lng: ${p.lng.toStringAsFixed(5)}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: AppTheme.textMuted),
                            ),
                            const SizedBox(height: 8),
                            Text('Actualizaciones: $updates', style: const TextStyle(color: AppTheme.textMuted)),
                            const SizedBox(height: 16),
                            const Text(
                              'Aquí se sustituirá esta tarjeta por el mapa real.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
                            ),
                          ],
                        ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const CircleAvatar(radius: 26, child: Icon(Icons.person)),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Conductor demo · 4.9 ★', style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 2),
                          Text('Moto demo · Placa ABC-123', style: TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        Text('ETA', style: TextStyle(color: AppTheme.textMuted, fontSize: 11)),
                        Text('4 min', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryYellow)),
                      ],
                    ),
                    const SizedBox(width: 10),
                    IconButton.filled(
                      onPressed: () {},
                      icon: const Icon(Icons.call, size: 18),
                      tooltip: 'Llamar al conductor',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              style: FilledButton.styleFrom(backgroundColor: AppTheme.error),
              onPressed: () {},
              icon: const Icon(Icons.sos),
              label: const Text('SOS'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.share_location),
              label: const Text('Compartir viaje'),
            ),
          ],
        ),
      ),
    );
  }
}
