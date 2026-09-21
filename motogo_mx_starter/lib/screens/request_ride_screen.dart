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
      body: ListView(
        padding: const EdgeInsets.all(AppSpace.xl),
        children: [
          const SectionHeader('Origen'),
          const SizedBox(height: AppSpace.sm),
          Card(
            child: ListTile(
              leading: const Icon(Icons.my_location, color: AppTheme.success),
              title: const Text('Mi ubicación actual'),
              subtitle: const Text('GPS — integración pendiente'),
            ),
          ),
          const SizedBox(height: AppSpace.xl),
          const SectionHeader('Destino'),
          const SizedBox(height: AppSpace.sm),
          TextField(
            controller: destination,
            decoration: const InputDecoration(
              labelText: '¿A dónde vas?',
              prefixIcon: Icon(Icons.location_on),
            ),
          ),
          const SizedBox(height: AppSpace.xl),
          const SectionHeader('Tipo de viaje'),
          const SizedBox(height: AppSpace.sm),
          const Card(
            child: ListTile(
              leading: Icon(Icons.two_wheeler),
              title: Text('Moto económica'),
              subtitle: Text('1 pasajero · disponible en tu zona'),
              trailing: Icon(Icons.check_circle, color: AppTheme.primaryYellow),
            ),
          ),
          const SizedBox(height: AppSpace.xl),
          const SectionHeader('Método de pago'),
          const SizedBox(height: AppSpace.sm),
          DropdownButtonFormField<String>(
            value: paymentMethod,
            items: const [
              DropdownMenuItem(value: 'Efectivo', child: Text('Efectivo')),
              DropdownMenuItem(value: 'Tarjeta', child: Text('Tarjeta')),
              DropdownMenuItem(value: 'QR', child: Text('QR')),
            ],
            onChanged: (v) => setState(() => paymentMethod = v ?? 'Efectivo'),
          ),
          const SizedBox(height: AppSpace.xl),
          Container(
            padding: const EdgeInsets.all(AppSpace.lg),
            decoration: BoxDecoration(
              color: AppTheme.surfaceElevated,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: AppTheme.primaryYellow.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const GradientIconBadge(icon: Icons.payments_outlined, size: 40),
                const SizedBox(width: AppSpace.md),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Precio estimado', style: TextStyle(fontWeight: FontWeight.w600)),
                      SizedBox(height: 2),
                      Text('Demo: \$45.00 MXN · cálculo real pendiente',
                          style: TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpace.xxxl),
          FilledButton(
            onPressed: () => Navigator.pushNamed(context, '/fare-preview'),
            child: const Text('Ver cotización'),
          ),
        ],
      ),
    );
  }
}
