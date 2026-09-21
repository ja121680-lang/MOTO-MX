import 'package:flutter/material.dart';

import '../config/pricing_config.dart';
import '../models/trip_record.dart';
import '../services/trip_ledger_service.dart';
import '../theme/app_theme.dart';

/// Real corte de caja: aggregates every trip actually recorded locally
/// (via TripLedgerService, populated from PaymentScreen) instead of
/// showing one hardcoded demo number. Shows the company/driver split and
/// a breakdown by how each trip was paid.
class CorteDeCajaScreen extends StatefulWidget {
  const CorteDeCajaScreen({super.key});

  @override
  State<CorteDeCajaScreen> createState() => _CorteDeCajaScreenState();
}

class _CorteDeCajaScreenState extends State<CorteDeCajaScreen> {
  final _ledger = TripLedgerService();
  List<TripRecord>? _trips;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final trips = await _ledger.getTrips();
    if (!mounted) return;
    setState(() => _trips = trips);
  }

  @override
  Widget build(BuildContext context) {
    final trips = _trips;
    return Scaffold(
      appBar: AppBar(title: const Text('Corte de caja')),
      body: trips == null
          ? const Center(child: CircularProgressIndicator())
          : trips.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      'Todavía no hay viajes completados registrados. Se van agregando aquí cada vez que se marca un pago como completado.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppTheme.textMuted),
                    ),
                  ),
                )
              : _buildSummary(calcularCorteDeCaja(trips)),
    );
  }

  Widget _buildSummary(CorteDeCaja corte) {
    final feePct = (PricingConfig.platformFeeRate * 100).toStringAsFixed(0);
    return ListView(
      padding: const EdgeInsets.all(AppSpace.xl),
      children: [
        Card(
          child: Column(
            children: [
              ListTile(
                title: const Text('Viajes registrados'),
                trailing: Text('${corte.tripCount}', style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              const Divider(height: 1),
              ListTile(
                title: const Text('Total cobrado'),
                trailing: Text('\$${corte.totalFare.toStringAsFixed(2)} MXN', style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              ListTile(
                title: Text('Comisión MotoGo MX ($feePct%)'),
                trailing: Text('\$${corte.totalPlatformFee.toStringAsFixed(2)} MXN', style: const TextStyle(color: AppTheme.textMuted)),
              ),
              ListTile(
                title: const Text('A entregar a conductores', style: TextStyle(fontWeight: FontWeight.bold)),
                trailing: Text(
                  '\$${corte.totalDriverNet.toStringAsFixed(2)} MXN',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.success),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpace.xxl),
        const SectionHeader('Por método de pago'),
        const SizedBox(height: AppSpace.md),
        for (final metodo in MetodoPago.values)
          if ((corte.countByMetodo[metodo] ?? 0) > 0)
            Card(
              margin: const EdgeInsets.only(bottom: AppSpace.sm),
              child: ListTile(
                title: Text(metodo.label),
                subtitle: Text('${corte.countByMetodo[metodo]} viaje(s)'),
                trailing: Text(
                  '\$${(corte.totalByMetodo[metodo] ?? 0).toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
      ],
    );
  }
}
