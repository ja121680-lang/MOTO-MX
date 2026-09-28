import 'dart:async';

import 'package:flutter/material.dart';

import '../data/demo_passenger_fixture.dart';
import '../l10n/app_strings.dart';
import '../theme/app_theme.dart';
import 'driver_trip_screen.dart';

/// Driver-side incoming ride request (Paquete B). A real countdown with a
/// visible timer, big Aceptar/Rechazar actions, and an auto-decline when
/// the countdown runs out — so an ignored request doesn't just sit there
/// forever with no outcome.
class IncomingRequestScreen extends StatefulWidget {
  const IncomingRequestScreen({super.key});

  @override
  State<IncomingRequestScreen> createState() => _IncomingRequestScreenState();
}

class _IncomingRequestScreenState extends State<IncomingRequestScreen> {
  late int _secondsLeft = DemoPassengerFixture.secondsToRespond;
  Timer? _timer;
  bool _resolved = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resolved) {
        timer.cancel();
        return;
      }
      setState(() => _secondsLeft--);
      if (_secondsLeft <= 0) {
        timer.cancel();
        _decline(auto: true);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _accept() {
    if (_resolved) return;
    _resolved = true;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const DriverTripScreen()),
    );
  }

  void _decline({bool auto = false}) {
    if (_resolved) return;
    _resolved = true;
    Navigator.of(context).pop();
    if (auto) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.t('La solicitud expiró sin respuesta.'))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.t('Nueva solicitud'))),
      body: Padding(
        padding: const EdgeInsets.all(AppSpace.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.primaryYellow, width: 3),
                ),
                child: Center(
                  child: Text(
                    '$_secondsLeft',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppTheme.primaryYellow),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpace.xl),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpace.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(child: Icon(Icons.person)),
                        const SizedBox(width: AppSpace.md),
                        Expanded(
                          child: Text(DemoPassengerFixture.name,
                              style: Theme.of(context).textTheme.titleLarge),
                        ),
                        Text(
                          '\$${DemoPassengerFixture.fare.toStringAsFixed(2)} MXN',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryYellow),
                        ),
                      ],
                    ),
                    const Divider(height: AppSpace.xxl),
                    _InfoRow(icon: Icons.my_location, label: S.t('Recogida'), value: DemoPassengerFixture.pickup),
                    const SizedBox(height: AppSpace.sm),
                    _InfoRow(icon: Icons.location_on, label: S.t('Destino'), value: DemoPassengerFixture.destination),
                    const SizedBox(height: AppSpace.sm),
                    _InfoRow(
                      icon: Icons.social_distance,
                      label: S.t('Distancia a ti'),
                      value: '${DemoPassengerFixture.distanceToPassengerKm} km',
                    ),
                    const SizedBox(height: AppSpace.sm),
                    _InfoRow(
                      icon: Icons.payments_outlined,
                      label: S.t('Método de pago'),
                      value: DemoPassengerFixture.paymentMethod,
                    ),
                    if (DemoPassengerFixture.note.isNotEmpty) ...[
                      const SizedBox(height: AppSpace.sm),
                      _InfoRow(
                        icon: Icons.sticky_note_2_outlined,
                        label: S.t('Nota del pasajero'),
                        value: DemoPassengerFixture.note,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _decline(),
                    style: OutlinedButton.styleFrom(side: const BorderSide(color: AppTheme.error)),
                    child: Text(S.t('Rechazar'), style: const TextStyle(color: AppTheme.error)),
                  ),
                ),
                const SizedBox(width: AppSpace.md),
                Expanded(
                  flex: 2,
                  child: FilledButton(
                    onPressed: _accept,
                    child: Text(S.t('Aceptar')),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppTheme.textMuted),
        const SizedBox(width: AppSpace.sm),
        Text(label, style: const TextStyle(color: AppTheme.textMuted, fontSize: 13)),
        const Spacer(),
        Flexible(
          child: Text(value, textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}
