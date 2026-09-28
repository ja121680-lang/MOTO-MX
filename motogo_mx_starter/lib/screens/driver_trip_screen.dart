import 'package:flutter/material.dart';

import '../data/demo_passenger_fixture.dart';
import '../l10n/app_strings.dart';
import '../models/sos_event.dart';
import '../models/trip_record.dart';
import '../services/sos_event_service.dart';
import '../services/trip_ledger_service.dart';
import '../theme/app_theme.dart';

enum _DriverTripState { validatingPin, inProgress, completed }

const _demoPin = '1234';
const _maxPinAttempts = 3;

/// Driver side of an accepted trip (Paquete B): validate the passenger's
/// PIN before starting (never auto-starts), then the in-progress screen
/// with share/SOS/finish — finishing writes a real [TripRecord] to the
/// same local ledger [PaymentScreen] uses, so wallet/corte de caja reflect
/// it (single-device demo model, same as the rest of this app).
class DriverTripScreen extends StatefulWidget {
  const DriverTripScreen({super.key});

  @override
  State<DriverTripScreen> createState() => _DriverTripScreenState();
}

class _DriverTripScreenState extends State<DriverTripScreen> {
  final _pinController = TextEditingController();
  final _ledger = TripLedgerService();
  final _sos = SosEventService();

  _DriverTripState _state = _DriverTripState.validatingPin;
  int _attemptsLeft = _maxPinAttempts;
  String? _pinError;
  bool _saving = false;

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  void _validatePin() {
    if (_pinController.text == _demoPin) {
      setState(() {
        _state = _DriverTripState.inProgress;
        _pinError = null;
      });
      return;
    }
    setState(() {
      _attemptsLeft--;
      _pinError = _attemptsLeft > 0
          ? S.t('PIN incorrecto. Te quedan $_attemptsLeft intento(s).')
          : S.t('Se agotaron los intentos. Cancela y confirma el PIN de nuevo con el pasajero.');
      _pinController.clear();
    });
  }

  Future<void> _sosAlert() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(S.t('¿Activar SOS?')),
        content: Text(
          S.t('Se notificará a soporte. Solo úsalo en una emergencia real.'),
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
      await _sos.log(role: SosRole.driver);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppTheme.error,
          content: Text(S.t('SOS activado (función simulada) — registrado para soporte.')),
        ),
      );
    }
  }

  void _share() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(S.t('Enlace de viaje generado (función simulada).'))),
    );
  }

  Future<void> _finish() async {
    setState(() => _saving = true);
    await _ledger.addTrip(TripRecord(
      id: 'MGX-${DateTime.now().millisecondsSinceEpoch}',
      route: '${DemoPassengerFixture.pickup} → ${DemoPassengerFixture.destination}',
      fare: DemoPassengerFixture.fare,
      metodoPago: MetodoPago.efectivo,
      completedAt: DateTime.now(),
    ));
    if (!mounted) return;
    setState(() {
      _state = _DriverTripState.completed;
      _saving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.t('Viaje con pasajero'))),
      body: switch (_state) {
        _DriverTripState.validatingPin => _buildPinStep(),
        _DriverTripState.inProgress => _buildInProgress(),
        _DriverTripState.completed => _buildCompleted(),
      },
    );
  }

  Widget _buildPinStep() {
    return Padding(
      padding: const EdgeInsets.all(AppSpace.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(Icons.pin_outlined, size: 48, color: AppTheme.goldLight),
          const SizedBox(height: AppSpace.md),
          Text(S.t('Pide al pasajero su PIN de viaje'), style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpace.sm),
          Text(
            S.t('El viaje solo inicia cuando el PIN coincide. Nunca inicies sin validarlo.'),
            style: const TextStyle(color: AppTheme.textMuted, fontSize: 13),
          ),
          const SizedBox(height: AppSpace.xl),
          TextField(
            controller: _pinController,
            keyboardType: TextInputType.number,
            obscureText: true,
            enabled: _attemptsLeft > 0,
            decoration: InputDecoration(
              labelText: S.t('PIN de viaje'),
              hintText: S.t('Demo: 1234'),
              errorText: _pinError,
            ),
          ),
          const SizedBox(height: AppSpace.lg),
          FilledButton(
            onPressed: _attemptsLeft > 0 ? _validatePin : null,
            child: Text(S.t('Validar PIN')),
          ),
          if (_attemptsLeft <= 0) ...[
            const SizedBox(height: AppSpace.sm),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(S.t('Cancelar viaje')),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInProgress() {
    return Padding(
      padding: const EdgeInsets.all(AppSpace.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StatusBadge(label: S.t('Viaje en curso').toUpperCase(), color: AppTheme.success),
          const SizedBox(height: AppSpace.md),
          Expanded(
            child: Card(
              child: Center(
                child: Text(
                  S.t('Ruta demo\nIntegración de mapas pendiente'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppTheme.textMuted),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpace.md),
          Card(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(DemoPassengerFixture.name),
              subtitle: Text('${DemoPassengerFixture.pickup} → ${DemoPassengerFixture.destination}'),
            ),
          ),
          const SizedBox(height: AppSpace.md),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _share,
                  icon: const Icon(Icons.share_location, size: 16),
                  label: Text(S.t('Compartir'), style: const TextStyle(fontSize: 12)),
                ),
              ),
              const SizedBox(width: AppSpace.sm),
              Expanded(
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(backgroundColor: AppTheme.error),
                  onPressed: _sosAlert,
                  icon: const Icon(Icons.sos, size: 16),
                  label: Text(S.t('SOS'), style: const TextStyle(fontSize: 12)),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpace.md),
          FilledButton(
            onPressed: _saving ? null : _finish,
            child: _saving
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : Text(S.t('Finalizar viaje')),
          ),
        ],
      ),
    );
  }

  Widget _buildCompleted() {
    return Padding(
      padding: const EdgeInsets.all(AppSpace.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, size: 64, color: AppTheme.success),
          const SizedBox(height: AppSpace.md),
          Text(S.t('Viaje finalizado'), style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppSpace.sm),
          Text(
            S.t('El ingreso ya se reflejó en tu wallet.'),
            style: const TextStyle(color: AppTheme.textMuted),
          ),
          const SizedBox(height: AppSpace.xl),
          FilledButton(
            onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
            child: Text(S.t('Volver a inicio')),
          ),
        ],
      ),
    );
  }
}
