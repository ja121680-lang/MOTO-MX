import 'package:flutter/material.dart';

class RequestRideScreen extends StatefulWidget {
  const RequestRideScreen({super.key});

  @override
  State<RequestRideScreen> createState() => _RequestRideScreenState();
}

class _RequestRideScreenState extends State<RequestRideScreen> {
  final destination = TextEditingController();
  String paymentMethod = 'Efectivo';

  @override
  void dispose() {
    destination.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Solicitar viaje')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Card(
              child: ListTile(
                leading: Icon(Icons.my_location),
                title: Text('Origen'),
                subtitle: Text('Ubicación GPS — integración pendiente'),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: destination,
              decoration: const InputDecoration(
                labelText: '¿A dónde vas?',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: paymentMethod,
              items: const [
                DropdownMenuItem(value: 'Efectivo', child: Text('Efectivo')),
                DropdownMenuItem(value: 'Tarjeta', child: Text('Tarjeta')),
                DropdownMenuItem(value: 'QR', child: Text('QR')),
              ],
              onChanged: (v) => setState(() => paymentMethod = v ?? 'Efectivo'),
              decoration: const InputDecoration(
                labelText: 'Método de pago',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            const Card(
              child: ListTile(
                leading: Icon(Icons.payments),
                title: Text('Precio estimado'),
                subtitle: Text('Demo: \$45.00 MXN · cálculo real pendiente'),
              ),
            ),
            const Spacer(),
            FilledButton(
              onPressed: () => Navigator.pushNamed(context, '/fare-preview'),
              child: const Text('Confirmar solicitud'),
            ),
          ],
        ),
      ),
    );
  }
}
