import 'package:flutter/material.dart';

import '../l10n/app_strings.dart';
import '../models/trip_record.dart';
import '../services/trip_ledger_service.dart';
import '../theme/app_theme.dart';
import 'rating_screen.dart';

/// Passenger's payment + receipt (Paquete 01). Shows the total and the
/// receipt — never the platform commission split, which stays internal to
/// wallet/driver/admin (see [PricingConfig], [TripRecord.platformFee]):
/// showing it here would read as an extra charge on top of the fare.
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

  bool get _isSimulated => method != MetodoPago.efectivo;

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
    final isPaid = status == 'Pagado';

    return Scaffold(
      appBar: AppBar(title: Text(S.t('Pago'))),
      body: ListView(
        padding: const EdgeInsets.all(AppSpace.xl),
        children: [
          Card(
            child: ListTile(
              title: Text(S.t('Total del viaje')),
              subtitle: Text(widget.route, style: const TextStyle(fontSize: 12)),
              trailing: Text(
                '\$${fare.toStringAsFixed(2)} MXN',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ),
          ),
          const SizedBox(height: AppSpace.lg),
          DropdownButtonFormField<MetodoPago>(
            initialValue: method,
            items: MetodoPago.values
                .map((m) => DropdownMenuItem(value: m, child: Text(S.t(m.label))))
                .toList(),
            onChanged: isPaid ? null : (v) => setState(() => method = v ?? MetodoPago.efectivo),
            decoration: InputDecoration(labelText: S.t('Método de pago')),
          ),
          if (_isSimulated) ...[
            const SizedBox(height: AppSpace.sm),
            Text(
              S.t('Pago simulado — proveedor de pagos real pendiente de integrar.'),
              style: const TextStyle(color: AppTheme.textMuted, fontSize: 11),
            ),
          ],
          const SizedBox(height: AppSpace.xl),
          FilledButton(
            onPressed: isPaid ? null : _confirmarPago,
            child: Text(S.t('Confirmar pago completado')),
          ),
          const SizedBox(height: AppSpace.lg),
          Center(
            child: StatusBadge(
              label: S.t(status).toUpperCase(),
              color: isPaid ? AppTheme.success : AppTheme.warning,
            ),
          ),
          if (isPaid) ...[
            const SizedBox(height: AppSpace.xl),
            FilledButton.icon(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const RatingScreen()),
              ),
              icon: const Icon(Icons.star_outline),
              label: Text(S.t('Calificar viaje')),
            ),
          ],
        ],
      ),
    );
  }
}
