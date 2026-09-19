import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String method = 'Efectivo';
  String status = 'Pendiente';

  @override
  Widget build(BuildContext context) {
    const fare = 90.0;
    const platformFee = fare * 0.08;
    const driverNet = fare - platformFee;
    final isPaid = status == 'Pagado';

    return Scaffold(
      appBar: AppBar(title: const Text('Pago')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Column(
              children: [
                const ListTile(
                  title: Text('Total del viaje'),
                  trailing: Text('\$90.00 MXN', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                ListTile(
                  title: const Text('Comisión MotoGo MX (8%)'),
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
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: method,
            items: const [
              DropdownMenuItem(value: 'Efectivo', child: Text('Efectivo')),
              DropdownMenuItem(value: 'Tarjeta', child: Text('Tarjeta')),
              DropdownMenuItem(value: 'QR', child: Text('QR')),
            ],
            onChanged: (v) => setState(() => method = v ?? 'Efectivo'),
            decoration: const InputDecoration(labelText: 'Método de pago'),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: isPaid ? null : () => setState(() => status = 'Pagado'),
            child: const Text('Simular pago completado'),
          ),
          const SizedBox(height: 16),
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
