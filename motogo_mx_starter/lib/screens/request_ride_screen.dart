import 'package:flutter/material.dart';
import '../theme/ga_theme.dart';

class RequestRideScreen extends StatefulWidget {
  const RequestRideScreen({super.key});

  @override
  State<RequestRideScreen> createState() => _RequestRideScreenState();
}

class _RequestRideScreenState extends State<RequestRideScreen> {
  final destination = TextEditingController();
  String paymentMethod = 'Efectivo';
  String? error;

  @override
  void dispose() {
    destination.dispose();
    super.dispose();
  }

  void _continue() {
    if (destination.text.trim().isEmpty) {
      setState(() => error = 'Escribe un destino para continuar.');
      return;
    }
    setState(() => error = null);
    Navigator.pushNamed(context, '/fare-preview');
  }

  Widget _step(
      {required IconData icon, required String label, required Widget child}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF211A08),
                border: Border.all(color: GAColors.gold),
              ),
              child: Icon(icon, color: GAColors.goldLight, size: 24),
            ),
            Container(width: 2, height: 42, color: GAColors.line),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      color: GAColors.goldLight,
                      fontSize: 14,
                      fontWeight: FontWeight.w900)),
              const SizedBox(height: 7),
              child,
              const SizedBox(height: 18),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Solicitar viaje')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 110),
          children: [
            const Text('Tu ruta',
                style: TextStyle(
                    color: GAColors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900)),
            const SizedBox(height: 6),
            const Text('Origen → destino → tarifa → confirmación',
                style: TextStyle(color: GAColors.muted, fontSize: 16)),
            const SizedBox(height: 22),
            _step(
              icon: Icons.my_location_rounded,
              label: 'ORIGEN',
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: GAColors.surface,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: GAColors.line),
                ),
                child: const Row(
                  children: [
                    Expanded(
                        child: Text('Ubicación actual',
                            style: TextStyle(
                                color: GAColors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w800))),
                    Text('GPS pendiente',
                        style: TextStyle(color: GAColors.muted, fontSize: 13)),
                  ],
                ),
              ),
            ),
            _step(
              icon: Icons.location_on_rounded,
              label: 'DESTINO',
              child: TextField(
                controller: destination,
                autofocus: false,
                onChanged: (_) {
                  if (error != null) setState(() => error = null);
                },
                decoration: const InputDecoration(
                  hintText: '¿A dónde vas?',
                  prefixIcon:
                      Icon(Icons.search_rounded, color: GAColors.goldLight),
                ),
              ),
            ),
            _step(
              icon: Icons.payments_rounded,
              label: 'MÉTODO DE PAGO',
              child: DropdownButtonFormField<String>(
                initialValue: paymentMethod,
                dropdownColor: GAColors.surface,
                items: const [
                  DropdownMenuItem(value: 'Efectivo', child: Text('Efectivo')),
                  DropdownMenuItem(value: 'Tarjeta', child: Text('Tarjeta')),
                  DropdownMenuItem(value: 'QR', child: Text('QR')),
                ],
                onChanged: (v) =>
                    setState(() => paymentMethod = v ?? 'Efectivo'),
                decoration: const InputDecoration(
                    prefixIcon:
                        Icon(Icons.wallet_rounded, color: GAColors.goldLight)),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color(0xFF17130A), Color(0xFF0C0C0C)]),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: GAColors.goldDark),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('PRECIO ESTIMADO',
                      style: TextStyle(
                          color: GAColors.goldLight,
                          fontSize: 14,
                          fontWeight: FontWeight.w900)),
                  SizedBox(height: 7),
                  Text('Se calcula antes de confirmar',
                      style: TextStyle(
                          color: GAColors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900)),
                  SizedBox(height: 5),
                  Text(
                      'La pantalla siguiente muestra distancia, tiempo y desglose de tarifa.',
                      style: TextStyle(
                          color: GAColors.muted, fontSize: 14, height: 1.4)),
                ],
              ),
            ),
            if (error != null) ...[
              const SizedBox(height: 12),
              Semantics(
                liveRegion: true,
                child: Text(error!,
                    style: const TextStyle(
                        color: GAColors.danger,
                        fontSize: 15,
                        fontWeight: FontWeight.w700)),
              ),
            ],
            const SizedBox(height: 22),
            FilledButton.icon(
              onPressed: _continue,
              icon: const Icon(Icons.arrow_forward_rounded),
              label: const Text('VER TARIFA'),
            ),
            const SizedBox(height: 10),
            const Text(
              'No se solicita ningún viaje hasta que confirmes la tarifa en la siguiente pantalla.',
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: GAColors.muted, fontSize: 13, height: 1.35),
            ),
          ],
        ),
      ),
    );
  }
}
