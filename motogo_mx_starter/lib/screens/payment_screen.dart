import 'package:flutter/material.dart';

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

    return Scaffold(
      appBar: AppBar(title: const Text('Pago')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Column(
              children: const [
                ListTile(
                  title: Text('Total del viaje'),
                  trailing: Text('\$90.00 MXN'),
                ),
                ListTile(
                  title: Text('Comisión MotoGo MX (8%)'),
                  trailing: Text('\$7.20'),
                ),
                ListTile(
                  title: Text('Neto conductor'),
                  trailing: Text('\$82.80'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: method,
            items: const [
              DropdownMenuItem(value: 'Efectivo', child: Text('Efectivo')),
              DropdownMenuItem(value: 'Tarjeta', child: Text('Tarjeta')),
              DropdownMenuItem(value: 'QR', child: Text('QR')),
            ],
            onChanged: (v) => setState(() => method = v ?? 'Efectivo'),
            decoration: const InputDecoration(
              labelText: 'Método de pago',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => setState(() => status = 'Pagado'),
            child: const Text('Simular pago completado'),
          ),
          const SizedBox(height: 12),
          Text(
            'Estado: $status',
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
