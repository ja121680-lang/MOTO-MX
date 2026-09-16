import 'package:flutter/material.dart';

enum MatchingState {
  searching,
  accepted,
  arriving,
  pin,
  inProgress,
  completed,
}

class RideMatchingScreen extends StatefulWidget {
  const RideMatchingScreen({super.key});

  @override
  State<RideMatchingScreen> createState() => _RideMatchingScreenState();
}

class _RideMatchingScreenState extends State<RideMatchingScreen> {
  MatchingState state = MatchingState.searching;
  final pinController = TextEditingController();

  @override
  void dispose() {
    pinController.dispose();
    super.dispose();
  }

  String get title {
    switch (state) {
      case MatchingState.searching:
        return 'Buscando conductor';
      case MatchingState.accepted:
        return 'Conductor asignado';
      case MatchingState.arriving:
        return 'Conductor en camino';
      case MatchingState.pin:
        return 'Validar PIN';
      case MatchingState.inProgress:
        return 'Viaje en curso';
      case MatchingState.completed:
        return 'Viaje completado';
    }
  }

  void next() {
    setState(() {
      switch (state) {
        case MatchingState.searching:
          state = MatchingState.accepted;
          break;
        case MatchingState.accepted:
          state = MatchingState.arriving;
          break;
        case MatchingState.arriving:
          state = MatchingState.pin;
          break;
        case MatchingState.pin:
          if (pinController.text == '1234') {
            state = MatchingState.inProgress;
          }
          break;
        case MatchingState.inProgress:
          state = MatchingState.completed;
          break;
        case MatchingState.completed:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Expanded(
              child: Card(
                child: Center(
                  child: Text(
                    'Mapa / ubicación en tiempo real\nIntegración pendiente',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            if (state != MatchingState.searching) ...[
              const Card(
                child: ListTile(
                  leading: CircleAvatar(child: Icon(Icons.person)),
                  title: Text('Conductor demo · 4.9 ★'),
                  subtitle: Text(
                    'Moto demo · Placa ABC-123 · Económico 27 · Sindicato demo',
                  ),
                ),
              ),
            ],
            if (state == MatchingState.pin)
              TextField(
                controller: pinController,
                keyboardType: TextInputType.number,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'PIN de viaje',
                  hintText: 'Demo: 1234',
                  border: OutlineInputBorder(),
                ),
              ),
            if (state == MatchingState.inProgress) ...[
              FilledButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/tracking'),
                icon: const Icon(Icons.gps_fixed),
                label: const Text('Abrir seguimiento en vivo'),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.sos),
                      label: const Text('SOS'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.share_location),
                      label: const Text('Compartir'),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            FilledButton(
              onPressed: state == MatchingState.completed
                  ? () => Navigator.pushNamed(context, '/payment')
                  : next,
              child: Text(
                switch (state) {
                  MatchingState.searching => 'Simular conductor disponible',
                  MatchingState.accepted => 'Conductor inicia traslado',
                  MatchingState.arriving => 'Conductor llegó',
                  MatchingState.pin => 'Validar PIN',
                  MatchingState.inProgress => 'Finalizar viaje',
                  MatchingState.completed => 'Ir a pago',
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
