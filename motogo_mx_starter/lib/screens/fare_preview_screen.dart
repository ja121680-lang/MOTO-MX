import 'package:flutter/material.dart';
import '../services/fare_service.dart';

class FarePreviewScreen extends StatefulWidget {
  const FarePreviewScreen({super.key});

  @override
  State<FarePreviewScreen> createState() => _FarePreviewScreenState();
}

class _FarePreviewScreenState extends State<FarePreviewScreen> {
  final service = const FareService();
  double distance = 4.2;
  int minutes = 11;

  @override
  Widget build(BuildContext context) {
    final quote = service.quote(distanceKm: distance, etaMinutes: minutes);

    return Scaffold(
      appBar: AppBar(title: const Text('Cotización')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.route),
              title: Text('${quote.distanceKm.toStringAsFixed(1)} km'),
              subtitle: Text('Tiempo estimado: ${quote.etaMinutes} min'),
            ),
          ),
          Card(
            child: Column(
              children: [
                ListTile(
                  title: const Text('Tarifa base'),
                  trailing: Text('\$${quote.baseFare.toStringAsFixed(2)}'),
                ),
                ListTile(
                  title: const Text('Distancia'),
                  trailing: Text('\$${quote.distanceFare.toStringAsFixed(2)}'),
                ),
                ListTile(
                  title: const Text('Tiempo'),
                  trailing: Text('\$${quote.timeFare.toStringAsFixed(2)}'),
                ),
                const Divider(),
                ListTile(
                  title: const Text(
                    'Total estimado',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: Text(
                    '\$${quote.totalFare.toStringAsFixed(2)} MXN',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text('Simulación de distancia'),
          Slider(
            value: distance,
            min: 1,
            max: 20,
            divisions: 38,
            label: '${distance.toStringAsFixed(1)} km',
            onChanged: (v) => setState(() => distance = v),
          ),
          const Text('Simulación de tiempo'),
          Slider(
            value: minutes.toDouble(),
            min: 3,
            max: 45,
            divisions: 42,
            label: '$minutes min',
            onChanged: (v) => setState(() => minutes = v.round()),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => Navigator.pushNamed(context, '/matching'),
            child: const Text('Solicitar este viaje'),
          ),
        ],
      ),
    );
  }
}
