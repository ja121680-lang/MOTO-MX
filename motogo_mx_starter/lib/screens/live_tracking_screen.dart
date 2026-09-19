import 'dart:async';
import 'package:flutter/material.dart';
import '../models/location_point.dart';
import '../services/driver_location_service.dart';
import '../theme/app_theme.dart';

class LiveTrackingScreen extends StatefulWidget {
  const LiveTrackingScreen({super.key, this.tripId = 'demo-trip'});

  final String tripId;

  @override
  State<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen> {
  final service = DriverLocationService();
  StreamSubscription<LocationPoint>? subscription;
  LocationPoint? current;
  int updates = 0;
  bool isLive = false;

  @override
  void initState() {
    super.initState();
    final stream = service.watchTripLocation(
      widget.tripId,
      onModeKnown: (live) {
        if (!mounted) return;
        setState(() => isLive = live);
      },
    );
    subscription = stream.listen((point) {
      if (!mounted) return;
      setState(() {
        current = point;
        updates++;
      });
    });
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = current;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seguimiento en vivo'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: StatusBadge(
                label: isLive ? 'EN VIVO' : 'DEMO',
                color: isLive ? AppTheme.success : AppTheme.textMuted,
              ),
            ),
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
                            Text(
                              isLive
                                  ? 'Ubicación real recibida por Supabase Realtime. Aquí se sustituirá esta tarjeta por el mapa.'
                                  : 'Backend no configurado — mostrando una ruta simulada. Conecta SUPABASE_URL/SUPABASE_ANON_KEY para ver la ubicación real del conductor.',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
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
