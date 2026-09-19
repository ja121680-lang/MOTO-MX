import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

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
            const _SectionLabel('Origen'),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.my_location, color: AppTheme.success),
                title: const Text('Mi ubicación actual'),
                subtitle: const Text('GPS — integración pendiente'),
              ),
            ),
            const SizedBox(height: 20),
            const _SectionLabel('Destino'),
            const SizedBox(height: 8),
            TextField(
              controller: destination,
              decoration: const InputDecoration(
                labelText: '¿A dónde vas?',
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
            const SizedBox(height: 20),
            const _SectionLabel('Tipo de viaje'),
            const SizedBox(height: 8),
            const Card(
              child: ListTile(
                leading: Icon(Icons.two_wheeler),
                title: Text('Moto económica'),
                subtitle: Text('1 pasajero · disponible en tu zona'),
                trailing: Icon(Icons.check_circle, color: AppTheme.primaryYellow),
              ),
            ),
            const SizedBox(height: 20),
            const _SectionLabel('Método de pago'),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: paymentMethod,
              items: const [
                DropdownMenuItem(value: 'Efectivo', child: Text('Efectivo')),
                DropdownMenuItem(value: 'Tarjeta', child: Text('Tarjeta')),
                DropdownMenuItem(value: 'QR', child: Text('QR')),
              ],
              onChanged: (v) => setState(() => paymentMethod = v ?? 'Efectivo'),
            ),
            const SizedBox(height: 20),
            Card(
              color: AppTheme.surfaceMuted,
              child: const ListTile(
                leading: Icon(Icons.payments_outlined, color: AppTheme.primaryYellow),
                title: Text('Precio estimado'),
                subtitle: Text('Demo: \$45.00 MXN · cálculo real pendiente'),
              ),
            ),
            const Spacer(),
            FilledButton(
              onPressed: () => Navigator.pushNamed(context, '/fare-preview'),
              child: const Text('Ver cotización'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: AppTheme.textMuted,
        letterSpacing: 0.8,
      ),
    );
  }
}
