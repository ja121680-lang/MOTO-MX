import 'package:flutter/material.dart';

import '../data/demo_driver_fixture.dart';
import '../l10n/app_strings.dart';
import '../theme/app_theme.dart';
import 'live_tracking_screen.dart';

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
        return S.t('Buscando conductor');
      case MatchingState.accepted:
        return S.t('Conductor asignado');
      case MatchingState.arriving:
        return S.t('Conductor en camino');
      case MatchingState.pin:
        return S.t('Validar PIN');
      case MatchingState.inProgress:
        return S.t('Viaje en curso');
      case MatchingState.completed:
        return S.t('Viaje completado');
    }
  }

  Color get statusColor {
    switch (state) {
      case MatchingState.searching:
        return AppTheme.warning;
      case MatchingState.accepted:
      case MatchingState.arriving:
        return AppTheme.primaryYellow;
      case MatchingState.pin:
        return AppTheme.warning;
      case MatchingState.inProgress:
      case MatchingState.completed:
        return AppTheme.success;
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

  Future<void> _cancel() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(S.t('¿Cancelar viaje?')),
        content: Text(S.t('Se cancelará la búsqueda o el viaje en curso.')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: Text(S.t('Seguir'))),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppTheme.error),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(S.t('Cancelar viaje')),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  void _help() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(AppSpace.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(S.t('¿Necesitas ayuda?'), style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpace.md),
            Text(
              S.t('Si algo no va bien con tu viaje, usa el botón SOS para emergencias o cancela la solicitud.'),
              style: const TextStyle(color: AppTheme.textMuted, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }

  bool get _driverKnown => state != MatchingState.searching;

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
    if (confirmed == true && mounted) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(title),
            const SizedBox(width: 10),
            StatusBadge(label: title, color: statusColor),
          ],
        ),
        actions: [
          if (state != MatchingState.completed)
            IconButton(
              onPressed: _cancel,
              icon: const Icon(Icons.close),
              tooltip: S.t('Cancelar'),
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
                  child: state == MatchingState.searching
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 56,
                              height: 56,
                              child: CircularProgressIndicator(
                                color: AppTheme.primaryYellow,
                                strokeWidth: 3,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              S.t('Buscando un conductor cercano...'),
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: AppTheme.textMuted),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              S.t('Tiempo estimado: 2–4 min'),
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
                            ),
                          ],
                        )
                      : Text(
                          S.t('Mapa / ubicación en tiempo real\nIntegración pendiente'),
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: AppTheme.textMuted),
                        ),
                ),
              ),
            ),
            if (_driverKnown) ...[
              const SizedBox(height: 12),
              Card(
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text('${DemoDriverFixture.name} · ${DemoDriverFixture.rating} ★'),
                  subtitle: Text(
                    '${DemoDriverFixture.motorcycle} · ${DemoDriverFixture.maskedPlate} · '
                    '${S.t('Económico')} ${DemoDriverFixture.economicNumber} · ${DemoDriverFixture.union}',
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: state == MatchingState.inProgress
                          ? () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const LiveTrackingScreen()),
                              )
                          : null,
                      icon: const Icon(Icons.gps_fixed, size: 16),
                      label: Text(S.t('Seguimiento'), style: const TextStyle(fontSize: 12)),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(S.t('Enlace de viaje generado (función simulada).'))),
                      ),
                      icon: const Icon(Icons.share_location, size: 16),
                      label: Text(S.t('Compartir'), style: const TextStyle(fontSize: 12)),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _help,
                      icon: const Icon(Icons.help_outline, size: 16),
                      label: Text(S.t('Ayuda'), style: const TextStyle(fontSize: 12)),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(backgroundColor: AppTheme.error),
                      onPressed: _sos,
                      icon: const Icon(Icons.sos, size: 16),
                      label: Text(S.t('SOS'), style: const TextStyle(fontSize: 12)),
                    ),
                  ),
                ],
              ),
            ],
            if (state == MatchingState.pin) ...[
              const SizedBox(height: 12),
              TextField(
                controller: pinController,
                keyboardType: TextInputType.number,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: S.t('PIN de viaje'),
                  hintText: S.t('Demo: 1234'),
                ),
              ),
            ],
            const SizedBox(height: 12),
            FilledButton(
              onPressed: state == MatchingState.completed
                  ? () => Navigator.pushNamed(context, '/payment')
                  : next,
              child: Text(
                switch (state) {
                  MatchingState.searching => S.t('Simular conductor disponible'),
                  MatchingState.accepted => S.t('Conductor inicia traslado'),
                  MatchingState.arriving => S.t('Conductor llegó'),
                  MatchingState.pin => S.t('Validar PIN'),
                  MatchingState.inProgress => S.t('Finalizar viaje'),
                  MatchingState.completed => S.t('Ir a pago'),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
