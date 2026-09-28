import 'package:flutter/material.dart';

import '../l10n/app_strings.dart';
import '../services/trip_ledger_service.dart';
import '../services/wallet_service.dart';
import '../services/withdrawal_service.dart';
import '../theme/app_theme.dart';

/// Real withdrawal request (Paquete B): persists via [WithdrawalService]
/// instead of showing a confirmation `SnackBar` and forgetting the
/// request — [WalletScreen] and the admin dashboard both read from the
/// same store.
class WithdrawalScreen extends StatefulWidget {
  const WithdrawalScreen({super.key});

  @override
  State<WithdrawalScreen> createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {
  final controller = TextEditingController();
  final _service = const WalletService();
  final _ledger = TripLedgerService();
  final _withdrawals = WithdrawalService();

  bool _loading = true;
  bool _submitting = false;
  double _available = 0;
  final bool diamondEnabled = true;
  String method = 'Transferencia';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final trips = await _ledger.getTrips();
    final withdrawals = await _withdrawals.all();
    final lifetimeNet = trips.fold<double>(0, (sum, t) => sum + t.driverNet);
    // Every withdrawal ever requested — paid or still pending — is already
    // committed against the balance.
    final alreadyWithdrawn = withdrawals.fold<double>(0, (sum, w) => sum + w.amount);
    if (!mounted) return;
    setState(() {
      _available = (lifetimeNet - alreadyWithdrawn).clamp(0, double.infinity).toDouble();
      _loading = false;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _confirm() async {
    final amount = double.tryParse(controller.text) ?? 0;
    final ok = _service.canWithdraw(
      availableBalance: _available,
      amount: amount,
      diamondEnabled: diamondEnabled,
    );
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.t('El retiro no cumple las condiciones.'))),
      );
      return;
    }
    setState(() => _submitting = true);
    await _withdrawals.request(amount: amount, method: method);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(S.t('Solicitud de retiro creada.'))),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: AppTheme.primaryYellow)));
    }
    return Scaffold(
      appBar: AppBar(title: Text(S.t('Retiro'))),
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
                  Text(S.t('Disponible'), style: const TextStyle(color: AppTheme.textMuted)),
                  const SizedBox(height: AppSpace.sm),
                  Text(
                    '\$${_available.toStringAsFixed(2)} MXN',
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
                            ? S.t('Diamond activo: retiro habilitado')
                            : S.t('Diamond inactivo: retiro no disponible'),
                        style: const TextStyle(color: AppTheme.textMuted, fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpace.xl),
            DropdownButtonFormField<String>(
              initialValue: method,
              items: const ['Transferencia', 'Depósito en tienda']
                  .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                  .toList(),
              onChanged: (v) => setState(() => method = v ?? 'Transferencia'),
              decoration: InputDecoration(labelText: S.t('Método de retiro')),
            ),
            const SizedBox(height: AppSpace.lg),
            TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: S.t('Monto a retirar')),
            ),
            const SizedBox(height: AppSpace.lg),
            FilledButton(
              onPressed: _submitting ? null : _confirm,
              child: _submitting
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(S.t('Confirmar retiro')),
            ),
          ],
        ),
      ),
    );
  }
}
