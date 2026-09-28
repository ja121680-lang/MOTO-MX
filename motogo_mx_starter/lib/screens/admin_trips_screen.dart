import 'package:flutter/material.dart';

import '../l10n/app_strings.dart';
import '../models/trip_record.dart';
import '../services/trip_ledger_service.dart';
import '../theme/app_theme.dart';

enum _TripFilter { all, completed, cancelled, incident }

/// Admin "Viajes" module (Paquete C) — real completed trips from the
/// local ledger, with status filter chips. "Cancelado" and "Incidencia"
/// honestly show empty: this app doesn't yet persist a cancelled-trip or
/// incident record anywhere (cancelling a request today just pops the
/// screen), so filtering to them can't show fabricated rows — that gap is
/// listed in the changelog's pendientes rather than faked here.
class AdminTripsScreen extends StatefulWidget {
  const AdminTripsScreen({super.key});

  @override
  State<AdminTripsScreen> createState() => _AdminTripsScreenState();
}

class _AdminTripsScreenState extends State<AdminTripsScreen> {
  final _ledger = TripLedgerService();
  bool _loading = true;
  List<TripRecord> _trips = const [];
  _TripFilter _filter = _TripFilter.all;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final trips = await _ledger.getTrips();
    trips.sort((a, b) => b.completedAt.compareTo(a.completedAt));
    if (!mounted) return;
    setState(() {
      _trips = trips;
      _loading = false;
    });
  }

  List<TripRecord> get _filtered {
    switch (_filter) {
      case _TripFilter.all:
      case _TripFilter.completed:
        return _trips;
      case _TripFilter.cancelled:
      case _TripFilter.incident:
        return const [];
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: AppTheme.primaryYellow)));
    }
    final filtered = _filtered;
    return Scaffold(
      appBar: AppBar(title: Text(S.t('Viajes'))),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.all(AppSpace.lg),
          children: [
            Wrap(
              spacing: AppSpace.sm,
              children: [
                ChoiceChip(
                  label: Text(S.t('Todos')),
                  selected: _filter == _TripFilter.all,
                  onSelected: (_) => setState(() => _filter = _TripFilter.all),
                ),
                ChoiceChip(
                  label: Text(S.t('Completado')),
                  selected: _filter == _TripFilter.completed,
                  onSelected: (_) => setState(() => _filter = _TripFilter.completed),
                ),
                ChoiceChip(
                  label: Text(S.t('Cancelado')),
                  selected: _filter == _TripFilter.cancelled,
                  onSelected: (_) => setState(() => _filter = _TripFilter.cancelled),
                ),
                ChoiceChip(
                  label: Text(S.t('Incidencia')),
                  selected: _filter == _TripFilter.incident,
                  onSelected: (_) => setState(() => _filter = _TripFilter.incident),
                ),
              ],
            ),
            if (_filter == _TripFilter.cancelled || _filter == _TripFilter.incident) ...[
              const SizedBox(height: AppSpace.md),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpace.md, vertical: AppSpace.sm),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, size: 14, color: AppTheme.textMuted),
                    const SizedBox(width: AppSpace.sm),
                    Expanded(
                      child: Text(
                        S.t('Todavía no se registran cancelaciones ni incidencias — pendiente de conectar.'),
                        style: const TextStyle(color: AppTheme.textMuted, fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: AppSpace.lg),
            if (filtered.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpace.xl),
                child: Text(
                  S.t('No hay viajes en esta categoría.'),
                  style: const TextStyle(color: AppTheme.textMuted),
                  textAlign: TextAlign.center,
                ),
              )
            else
              ...filtered.map((trip) => Card(
                    child: ListTile(
                      leading: const Icon(Icons.check_circle_outline, color: AppTheme.success),
                      title: Text(trip.route),
                      subtitle: Text('${trip.id} · ${trip.metodoPago.label}'),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('\$${trip.fare.toStringAsFixed(2)}',
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          StatusBadge(label: S.t('Completado').toUpperCase(), color: AppTheme.success),
                        ],
                      ),
                    ),
                  )),
          ],
        ),
      ),
    );
  }
}
