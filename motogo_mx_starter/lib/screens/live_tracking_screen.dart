import 'dart:async';
import 'package:flutter/material.dart';

import '../data/demo_driver_fixture.dart';
import '../l10n/app_strings.dart';
import '../models/location_point.dart';
import '../models/sos_event.dart';
import '../services/driver_location_service.dart';
import '../services/sos_event_service.dart';
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

  Future<void> _sos() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(S.t('¿Activar SOS?')),
        content: Text(
          S.t('Se notificará a tu contacto de emergencia y a soporte. Solo úsalo en una emergencia real.'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: Text(S.t('Cancelar'))),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppTheme.error),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(S.t('Sí, activar SOS')),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await SosEventService().log(role: SosRole.passenger, tripId: widget.tripId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppTheme.error,
          content: Text(
            S.t('SOS activado (función simulada) — integración real con contacto de emergencia pendiente.'),
          ),
        ),
      );
    }
  }

  void _share() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          S.t('Función de compartir viaje en desarrollo — pronto podrás enviar un enlace en tiempo real.'),
        ),
      ),
    );
  }

  void _chat() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(S.t('Chat en tiempo real próximamente.'))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = current;
    return Scaffold(
      appBar: AppBar(
        title: Text(S.t('Seguimiento en vivo')),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: StatusBadge(
                label: isLive ? S.t('EN VIVO') : S.t('DEMO'),
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
            StatusBadge(label: S.t('Viaje en curso').toUpperCase(), color: AppTheme.success),
            const SizedBox(height: 12),
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
                            Text('${S.t('Actualizaciones')}: $updates',
                                style: const TextStyle(color: AppTheme.textMuted)),
                            const SizedBox(height: 16),
                            Text(
                              isLive
                                  ? S.t(
                                      'Ubicación real recibida por Supabase Realtime. Aquí se sustituirá esta tarjeta por el mapa.',
                                    )
                                  : S.t(
                                      'Ubicación simulada — backend no configurado. Conecta SUPABASE_URL/SUPABASE_ANON_KEY para ver la ubicación real del conductor.',
                                    ),
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
                        children: [
                          Text('${DemoDriverFixture.name} · ${DemoDriverFixture.rating} ★',
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 2),
                          Text(
                            '${DemoDriverFixture.motorcycle} · ${DemoDriverFixture.maskedPlate} · '
                            '${S.t('Económico')} ${DemoDriverFixture.economicNumber}',
                            style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(S.t('ETA'), style: const TextStyle(color: AppTheme.textMuted, fontSize: 11)),
                        const Text('4 min',
                            style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryYellow)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.call, size: 16),
                    label: Text(S.t('Llamar'), style: const TextStyle(fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _chat,
                    icon: const Icon(Icons.chat_bubble_outline, size: 16),
                    label: Text(S.t('Chat (pronto)'), style: const TextStyle(fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _share,
                    icon: const Icon(Icons.share_location, size: 16),
                    label: Text(S.t('Compartir'), style: const TextStyle(fontSize: 12)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              style: FilledButton.styleFrom(backgroundColor: AppTheme.error),
              onPressed: _sos,
              icon: const Icon(Icons.sos),
              label: Text(S.t('SOS')),
            ),
          ],
        ),
      ),
    );
  }
}
