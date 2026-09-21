import 'package:flutter/material.dart';
import '../services/wallet_service.dart';
import '../theme/app_theme.dart';

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
        padding: const EdgeInsets.all(AppSpace.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpace.xl),
              decoration: BoxDecoration(
                color: AppTheme.surfaceElevated,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: AppTheme.divider),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Disponible', style: TextStyle(color: AppTheme.textMuted)),
                  const SizedBox(height: AppSpace.sm),
                  Text(
                    '\$${available.toStringAsFixed(2)} MXN',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(color: AppTheme.primaryYellow),
                  ),
                  const SizedBox(height: AppSpace.sm),
                  Row(
                    children: [
                      Icon(
                        diamondEnabled ? Icons.workspace_premium : Icons.info_outline,
                        size: 16,
                        color: diamondEnabled ? AppTheme.success : AppTheme.warning,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        diamondEnabled
                            ? 'Diamond activo: retiro habilitado'
                            : 'Diamond inactivo: retiro no disponible',
                        style: const TextStyle(color: AppTheme.textMuted, fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpace.xl),
            TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Monto a retirar'),
            ),
            const SizedBox(height: AppSpace.lg),
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
