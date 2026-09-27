import 'dart:async';
import 'package:flutter/material.dart';
import '../models/location_point.dart';
import '../services/mock_location_service.dart';
import '../theme/ga_theme.dart';

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

  Future<bool> _confirm({required String title, required String body, required String confirmLabel, bool danger = false}) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(title),
            content: Text(body),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
              FilledButton(
                style: danger ? FilledButton.styleFrom(backgroundColor: GAColors.danger, foregroundColor: GAColors.black) : null,
                onPressed: () => Navigator.pop(context, true),
                child: Text(confirmLabel),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _sos() async {
    final ok = await _confirm(
      title: 'Confirmar SOS',
      body: 'Esta función puede compartir información sensible o iniciar una acción de emergencia cuando la integración esté activa. ¿Quieres continuar?',
      confirmLabel: 'Confirmar SOS',
      danger: true,
    );
    if (!ok || !mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('SOS confirmado. La integración externa de emergencia aún está pendiente.')),
    );
  }

  Future<void> _share() async {
    final ok = await _confirm(
      title: 'Compartir viaje',
      body: 'Compartir un viaje puede revelar ubicación. Revisa quién recibirá el enlace antes de enviarlo. ¿Quieres preparar la acción?',
      confirmLabel: 'Continuar',
    );
    if (!ok || !mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Confirmado. El proveedor de compartición todavía no está integrado.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = current;
    return Scaffold(
      appBar: AppBar(title: const Text('Seguimiento del viaje')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 110),
          children: [
            Container(
              height: 360,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF18130A), Color(0xFF090909)],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: GAColors.goldDark),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(painter: _RouteGridPainter()),
                  ),
                  Center(
                    child: p == null
                        ? const CircularProgressIndicator(color: GAColors.goldLight)
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 86,
                                height: 86,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFF211A08),
                                  border: Border.all(color: GAColors.gold, width: 2),
                                ),
                                child: const Icon(Icons.two_wheeler_rounded, size: 46, color: GAColors.goldLight),
                              ),
                              const SizedBox(height: 14),
                              const Text('UBICACIÓN SIMULADA', style: TextStyle(color: GAColors.goldLight, fontSize: 13, fontWeight: FontWeight.w900, letterSpacing: 1.1)),
                              const SizedBox(height: 7),
                              Text(
                                '${p.lat.toStringAsFixed(5)}, ${p.lng.toStringAsFixed(5)}',
                                style: const TextStyle(color: GAColors.white, fontSize: 18, fontWeight: FontWeight.w900),
                              ),
                              const SizedBox(height: 5),
                              Text('Actualizaciones: $updates', style: const TextStyle(color: GAColors.muted, fontSize: 14)),
                            ],
                          ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: GAColors.surface, borderRadius: BorderRadius.circular(18), border: Border.all(color: GAColors.line)),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.map_outlined, color: GAColors.goldLight, size: 27),
                  SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Mapa real pendiente de integración', style: TextStyle(color: GAColors.white, fontSize: 17, fontWeight: FontWeight.w900)),
                        SizedBox(height: 4),
                        Text('Esta vista usa coordenadas simuladas y no debe presentarse como seguimiento GPS real.', style: TextStyle(color: GAColors.muted, fontSize: 14, height: 1.4)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              style: FilledButton.styleFrom(backgroundColor: GAColors.danger, foregroundColor: GAColors.black),
              onPressed: _sos,
              icon: const Icon(Icons.sos_rounded),
              label: const Text('SOS — NECESITO AYUDA'),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: _share,
              icon: const Icon(Icons.share_location_rounded),
              label: const Text('COMPARTIR VIAJE'),
            ),
          ],
        ),
      ),
    );
  }
}

class _RouteGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = const Color(0x224A3B12)
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 34) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (double y = 0; y < size.height; y += 34) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
    final route = Paint()
      ..color = GAColors.gold
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    final path = Path()
      ..moveTo(size.width * .08, size.height * .77)
      ..cubicTo(size.width * .28, size.height * .46, size.width * .55, size.height * .86, size.width * .86, size.height * .25);
    canvas.drawPath(path, route);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
