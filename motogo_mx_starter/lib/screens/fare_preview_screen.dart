import 'package:flutter/material.dart';
import '../services/fare_service.dart';
import '../theme/ga_theme.dart';

class FarePreviewScreen extends StatefulWidget {
  const FarePreviewScreen({super.key});

  @override
  State<FarePreviewScreen> createState() => _FarePreviewScreenState();
}

class _FarePreviewScreenState extends State<FarePreviewScreen> {
  final service = const FareService();
  double distance = 4.2;
  int minutes = 11;

  Widget _line(String label, double amount, {bool total = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: total ? 14 : 9),
      child: Row(
        children: [
          Expanded(child: Text(label, style: TextStyle(color: total ? GAColors.white : GAColors.muted, fontSize: total ? 18 : 15, fontWeight: total ? FontWeight.w900 : FontWeight.w600))),
          Text('\$${amount.toStringAsFixed(2)}', style: TextStyle(color: total ? GAColors.goldLight : GAColors.white, fontSize: total ? 24 : 16, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final quote = service.quote(distanceKm: distance, etaMinutes: minutes);

    return Scaffold(
      appBar: AppBar(title: const Text('Tu tarifa')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 110),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF211A08), Color(0xFF0A0A0A)]),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: GAColors.gold),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('TOTAL ESTIMADO', style: TextStyle(color: GAColors.goldLight, fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
                  const SizedBox(height: 8),
                  Text('\$${quote.totalFare.toStringAsFixed(2)} MXN', style: const TextStyle(color: GAColors.white, fontSize: 38, fontWeight: FontWeight.w900, height: 1)),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      const Icon(Icons.route_rounded, color: GAColors.goldLight),
                      const SizedBox(width: 8),
                      Text('${quote.distanceKm.toStringAsFixed(1)} km', style: const TextStyle(color: GAColors.white, fontSize: 16, fontWeight: FontWeight.w800)),
                      const SizedBox(width: 18),
                      const Icon(Icons.schedule_rounded, color: GAColors.goldLight),
                      const SizedBox(width: 8),
                      Text('${quote.etaMinutes} min', style: const TextStyle(color: GAColors.white, fontSize: 16, fontWeight: FontWeight.w800)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(color: GAColors.surface, borderRadius: BorderRadius.circular(20), border: Border.all(color: GAColors.line)),
              child: Column(
                children: [
                  _line('Tarifa base', quote.baseFare),
                  _line('Distancia', quote.distanceFare),
                  _line('Tiempo', quote.timeFare),
                  const Divider(),
                  _line('Total', quote.totalFare, total: true),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFF14120D), borderRadius: BorderRadius.circular(17), border: Border.all(color: GAColors.line)),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline_rounded, color: GAColors.goldLight, size: 24),
                  SizedBox(width: 10),
                  Expanded(child: Text('Esta pantalla usa una simulación de distancia y tiempo mientras se integra el mapa real. La tarifa se muestra antes de solicitar el viaje.', style: TextStyle(color: GAColors.muted, fontSize: 14, height: 1.45))),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const Text('Simulación de distancia', style: TextStyle(color: GAColors.white, fontSize: 16, fontWeight: FontWeight.w800)),
            Slider(
              value: distance,
              min: 1,
              max: 20,
              divisions: 38,
              label: '${distance.toStringAsFixed(1)} km',
              onChanged: (v) => setState(() => distance = v),
            ),
            const Text('Simulación de tiempo', style: TextStyle(color: GAColors.white, fontSize: 16, fontWeight: FontWeight.w800)),
            Slider(
              value: minutes.toDouble(),
              min: 3,
              max: 45,
              divisions: 42,
              label: '$minutes min',
              onChanged: (v) => setState(() => minutes = v.round()),
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/matching'),
              icon: const Icon(Icons.two_wheeler_rounded),
              label: const Text('SOLICITAR ESTE VIAJE'),
            ),
            const SizedBox(height: 10),
            const Text('Al continuar comenzarás la búsqueda de conductor.', textAlign: TextAlign.center, style: TextStyle(color: GAColors.muted, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
