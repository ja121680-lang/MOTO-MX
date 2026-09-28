import 'package:flutter/material.dart';

import '../l10n/app_strings.dart';
import '../models/trip_record.dart';
import '../services/trip_ledger_service.dart';
import '../theme/app_theme.dart';

/// "Actividad" — a real navigation section (Paquete 01). Until MotoGo MX
/// has a real notifications backend, showing recent trip activity from the
/// same local ledger [MyTripsScreen] reads is honest content instead of a
/// fabricated notifications feed with nothing behind it.
class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  final _ledger = TripLedgerService();
  late Future<List<TripRecord>> _trips = _ledger.getTrips();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.t('Actividad'))),
      body: FutureBuilder<List<TripRecord>>(
        future: _trips,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppTheme.primaryYellow));
          }
          final trips = (snapshot.data ?? const [])
            ..sort((a, b) => b.completedAt.compareTo(a.completedAt));
          final recent = trips.take(10).toList();

          if (recent.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpace.xxxl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.notifications_none, size: 48, color: AppTheme.textMuted),
                    const SizedBox(height: AppSpace.md),
                    Text(
                      S.t('Todavía no hay actividad'),
                      style: const TextStyle(color: AppTheme.textMuted),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpace.sm),
                    Text(
                      S.t('Aquí verás avisos sobre tus viajes y tu cuenta.'),
                      style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(AppSpace.lg),
            itemCount: recent.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpace.sm),
            itemBuilder: (context, index) {
              final trip = recent[index];
              return Card(
                child: ListTile(
                  leading: const GradientIconBadge(icon: Icons.receipt_long_outlined, size: 40),
                  title: Text(S.t('Viaje completado')),
                  subtitle: Text('${trip.route} · \$${trip.fare.toStringAsFixed(2)}'),
                  trailing: Text(
                    '${trip.completedAt.day.toString().padLeft(2, '0')}/'
                    '${trip.completedAt.month.toString().padLeft(2, '0')}',
                    style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
