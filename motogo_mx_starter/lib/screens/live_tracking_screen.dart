import 'dart:async';
import 'package:flutter/material.dart';
import '../models/location_point.dart';
import '../services/mock_location_service.dart';

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
      appBar: AppBar(title: const Text('Seguimiento en vivo')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Card(
                child: Center(
                  child: p == null
                      ? const CircularProgressIndicator()
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.two_wheeler, size: 64),
                            const SizedBox(height: 12),
                            Text(
                              'Lat: ${p.lat.toStringAsFixed(5)}\n'
                              'Lng: ${p.lng.toStringAsFixed(5)}',
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text('Actualizaciones: $updates'),
                            const SizedBox(height: 16),
                            const Text(
                              'Aquí se sustituirá esta tarjeta por el mapa real.',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
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
