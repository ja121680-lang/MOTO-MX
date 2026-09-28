import 'package:flutter/material.dart';

import '../l10n/app_strings.dart';
import '../models/trip_record.dart';
import '../services/trip_ledger_service.dart';
import '../theme/app_theme.dart';

/// "Mis viajes" — a real navigation section (Paquete 01), not a screen you
/// can only reach through an ad-hoc button. Shows the active trip (if any)
/// and the real receipt history from [TripLedgerService] — the same
/// ledger [PaymentScreen] already writes to — instead of the fixed demo
/// list the old `/history` route showed.
class MyTripsScreen extends StatefulWidget {
  const MyTripsScreen({super.key});

  @override
  State<MyTripsScreen> createState() => _MyTripsScreenState();
}

class _MyTripsScreenState extends State<MyTripsScreen> {
  final _ledger = TripLedgerService();
  late Future<List<TripRecord>> _trips = _ledger.getTrips();

  Future<void> _refresh() async {
    setState(() => _trips = _ledger.getTrips());
    await _trips;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.t('Mis viajes'))),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<TripRecord>>(
          future: _trips,
          builder: (context, snapshot) {
            final trips = (snapshot.data ?? const [])
              ..sort((a, b) => b.completedAt.compareTo(a.completedAt));
            return ListView(
              padding: const EdgeInsets.all(AppSpace.lg),
              children: [
                SectionHeader(S.t('Viaje activo')),
                const SizedBox(height: AppSpace.sm),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.two_wheeler_outlined, color: AppTheme.textMuted),
                    title: Text(S.t('No tienes ningún viaje en curso')),
                    subtitle: Text(
                      S.t('Cuando pidas una moto, la verás aquí en tiempo real.'),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpace.xxl),
                SectionHeader(S.t('Historial y recibos')),
                const SizedBox(height: AppSpace.sm),
                if (snapshot.connectionState == ConnectionState.waiting)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpace.xxxl),
                    child: Center(child: CircularProgressIndicator(color: AppTheme.primaryYellow)),
                  )
                else if (trips.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpace.xl),
                    child: Text(
                      S.t('Aún no tienes viajes completados.'),
                      style: const TextStyle(color: AppTheme.textMuted),
                      textAlign: TextAlign.center,
                    ),
                  )
                else
                  ...trips.map((trip) => Card(
                        child: ListTile(
                          leading: const Icon(Icons.check_circle_outline, color: AppTheme.success),
                          title: Text(trip.route),
                          subtitle: Text(
                            '${trip.id} · ${trip.metodoPago.label} · '
                            '${trip.completedAt.day.toString().padLeft(2, '0')}/'
                            '${trip.completedAt.month.toString().padLeft(2, '0')}/'
                            '${trip.completedAt.year}',
                          ),
                          trailing: Text(
                            '\$${trip.fare.toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      )),
              ],
            );
          },
        ),
      ),
    );
  }
}
