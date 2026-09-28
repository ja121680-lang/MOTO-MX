import 'package:flutter/material.dart';

import '../l10n/app_strings.dart';
import '../models/trip_record.dart';
import '../models/withdrawal_request.dart';
import '../services/trip_ledger_service.dart';
import '../services/withdrawal_service.dart';
import '../theme/app_theme.dart';

/// Real wallet (Paquete B): balance and movements computed from the same
/// local ledger [PaymentScreen]/[DriverTripScreen] write completed trips
/// to, and the same [WithdrawalService] requests write to — not a fixed
/// demo balance disconnected from what actually happened in the app.
class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final _ledger = TripLedgerService();
  final _withdrawals = WithdrawalService();

  bool _loading = true;
  List<TripRecord> _trips = const [];
  List<WithdrawalRequest> _withdrawalRequests = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final trips = await _ledger.getTrips();
    final withdrawals = await _withdrawals.all();
    if (!mounted) return;
    setState(() {
      _trips = trips;
      _withdrawalRequests = withdrawals;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: AppTheme.primaryYellow)));
    }

    final lifetimeEarnings = _trips.fold<double>(0, (sum, t) => sum + t.fare);
    final lifetimeFees = _trips.fold<double>(0, (sum, t) => sum + t.platformFee);
    final lifetimeNet = lifetimeEarnings - lifetimeFees;
    final paidOut = _withdrawalRequests
        .where((w) => w.status == WithdrawalStatus.pagado)
        .fold<double>(0, (sum, w) => sum + w.amount);
    final pendingWithdrawals = _withdrawalRequests
        .where((w) => w.status != WithdrawalStatus.pagado)
        .fold<double>(0, (sum, w) => sum + w.amount);
    final available = (lifetimeNet - paidOut - pendingWithdrawals).clamp(0, double.infinity);

    return Scaffold(
      appBar: AppBar(title: Text(S.t('Wallet'))),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpace.xl),
              decoration: BoxDecoration(
                color: AppTheme.surfaceElevated,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: AppTheme.primaryYellow.withValues(alpha: 0.4)),
                boxShadow: AppTheme.glow(AppTheme.primaryYellow, opacity: 0.12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const GradientIconBadge(icon: Icons.account_balance_wallet, size: 40),
                      const SizedBox(width: AppSpace.md),
                      Text(S.t('Saldo disponible'), style: const TextStyle(color: AppTheme.textMuted)),
                    ],
                  ),
                  const SizedBox(height: AppSpace.md),
                  Text(
                    '\$${available.toStringAsFixed(2)} MXN',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(color: AppTheme.primaryYellow),
                  ),
                  const SizedBox(height: AppSpace.sm),
                  Row(
                    children: [
                      const Icon(Icons.hourglass_top, size: 14, color: AppTheme.textMuted),
                      const SizedBox(width: 6),
                      Text(
                        '${S.t('Pendiente de retiro')}: \$${pendingWithdrawals.toStringAsFixed(2)} MXN',
                        style: const TextStyle(color: AppTheme.textMuted, fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpace.lg),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpace.md, vertical: AppSpace.sm),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, size: 14, color: AppTheme.textMuted),
                  const SizedBox(width: AppSpace.sm),
                  Expanded(
                    child: Text(
                      S.t('Los pagos y retiros reales requieren validación operativa.'),
                      style: const TextStyle(color: AppTheme.textMuted, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpace.lg),
            FilledButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/withdrawal').then((_) => _load()),
              icon: const Icon(Icons.account_balance),
              label: Text(S.t('Solicitar retiro')),
            ),
            const SizedBox(height: AppSpace.xxl),
            Text(S.t('Movimientos'), style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpace.md),
            if (_trips.isEmpty && _withdrawalRequests.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpace.xl),
                child: Text(
                  S.t('Aún no hay movimientos. Aparecerán aquí al completar viajes o solicitar retiros.'),
                  style: const TextStyle(color: AppTheme.textMuted),
                  textAlign: TextAlign.center,
                ),
              )
            else ...[
              ..._withdrawalRequests.map((w) => Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppTheme.error.withValues(alpha: 0.15),
                        child: const Icon(Icons.arrow_upward, color: AppTheme.error, size: 18),
                      ),
                      title: Text('${S.t('Retiro')} · ${w.method}'),
                      subtitle: Text('${S.t(w.status.label)} · ${_formatDate(w.requestedAt)}'),
                      trailing: Text(
                        '-\$${w.amount.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.error),
                      ),
                    ),
                  )),
              ..._trips.map((t) => Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppTheme.success.withValues(alpha: 0.15),
                        child: const Icon(Icons.arrow_downward, color: AppTheme.success, size: 18),
                      ),
                      title: Text('${S.t('Viaje')} · ${t.route}'),
                      subtitle: Text(
                        '${S.t('Bruto')} \$${t.fare.toStringAsFixed(2)} · ${S.t('Comisión')} '
                        '\$${t.platformFee.toStringAsFixed(2)} · ${_formatDate(t.completedAt)}',
                        style: const TextStyle(fontSize: 11),
                      ),
                      trailing: Text(
                        '+\$${t.driverNet.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.success),
                      ),
                    ),
                  )),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';
}
