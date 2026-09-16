import 'package:flutter/material.dart';
import '../services/wallet_service.dart';

class WithdrawalScreen extends StatefulWidget {
  const WithdrawalScreen({super.key});

  @override
  State<WithdrawalScreen> createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {
  final controller = TextEditingController();
  final service = const WalletService();
  final available = 846.50;
  final diamondEnabled = true;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Retiro')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Disponible: \$${available.toStringAsFixed(2)} MXN'),
            const SizedBox(height: 8),
            Text(
              diamondEnabled
                  ? 'Diamond activo: retiro habilitado'
                  : 'Diamond inactivo: retiro no disponible',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Monto a retirar',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                final amount = double.tryParse(controller.text) ?? 0;
                final ok = service.canWithdraw(
                  availableBalance: available,
                  amount: amount,
                  diamondEnabled: diamondEnabled,
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      ok
                          ? 'Solicitud de retiro creada.'
                          : 'El retiro no cumple las condiciones.',
                    ),
                  ),
                );
              },
              child: const Text('Confirmar retiro'),
            ),
          ],
        ),
      ),
    );
  }
}
