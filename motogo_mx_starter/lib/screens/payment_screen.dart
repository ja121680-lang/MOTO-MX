import 'package:flutter/material.dart';
import '../config/pricing_config.dart';
import '../models/trip_record.dart';
import '../services/trip_ledger_service.dart';
import '../theme/app_theme.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key, this.tripId, this.route = 'Viaje', this.fare = 90.0});

  final String? tripId;
  final String route;
  final double fare;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _ledger = TripLedgerService();
  MetodoPago method = MetodoPago.efectivo;
  String status = 'Pendiente';

  Future<void> _confirmarPago() async {
    await _ledger.addTrip(TripRecord(
      id: widget.tripId ?? 'MGX-${DateTime.now().millisecondsSinceEpoch}',
      route: widget.route,
      fare: widget.fare,
      metodoPago: method,
      completedAt: DateTime.now(),
    ));
    if (!mounted) return;
    setState(() => status = 'Pagado');
  }

  @override
  Widget build(BuildContext context) {
    final fare = widget.fare;
    final platformFee = fare * PricingConfig.platformFeeRate;
    final driverNet = fare - platformFee;
    final feePct = (PricingConfig.platformFeeRate * 100).toStringAsFixed(0);
    final isPaid = status == 'Pagado';

    return Scaffold(
      appBar: AppBar(title: const Text('Pago')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpace.xl),
        children: [
          Card(
            child: Column(
              children: [
                ListTile(
                  title: const Text('Total del viaje'),
                  trailing: Text('\$${fare.toStringAsFixed(2)} MXN', style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                ListTile(
                  title: Text('Comisión MotoGo MX ($feePct%)'),
                  trailing: Text('\$${platformFee.toStringAsFixed(2)}', style: const TextStyle(color: AppTheme.textMuted)),
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('Neto conductor', style: TextStyle(fontWeight: FontWeight.bold)),
                  trailing: Text(
                    '\$${driverNet.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.success),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpace.lg),
          DropdownButtonFormField<MetodoPago>(
            value: method,
            items: MetodoPago.values
                .map((m) => DropdownMenuItem(value: m, child: Text(m.label)))
                .toList(),
            onChanged: isPaid ? null : (v) => setState(() => method = v ?? MetodoPago.efectivo),
            decoration: const InputDecoration(labelText: 'Método de pago'),
          ),
          const SizedBox(height: AppSpace.xl),
          FilledButton(
            onPressed: isPaid ? null : _confirmarPago,
            child: const Text('Confirmar pago completado'),
          ),
          const SizedBox(height: AppSpace.lg),
          Center(
            child: StatusBadge(
              label: status.toUpperCase(),
              color: isPaid ? AppTheme.success : AppTheme.warning,
            ),
          ),
        ],
      ),
    );
  }
}
