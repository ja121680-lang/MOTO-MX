import 'package:flutter/material.dart';
import '../services/wallet_service.dart';
import '../theme/app_theme.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const service = WalletService();
    final summary = service.demoSummary();
    final transactions = service.demoTransactions();

    return Scaffold(
      appBar: AppBar(title: const Text('Wallet')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpace.xl),
            decoration: BoxDecoration(
              color: AppTheme.surfaceElevated,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppTheme.primaryYellow.withOpacity(0.4)),
              boxShadow: AppTheme.glow(AppTheme.primaryYellow, opacity: 0.12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const GradientIconBadge(icon: Icons.account_balance_wallet, size: 40),
                    const SizedBox(width: AppSpace.md),
                    const Text('Saldo disponible', style: TextStyle(color: AppTheme.textMuted)),
                  ],
                ),
                const SizedBox(height: AppSpace.md),
                Text(
                  '\$${summary.available.toStringAsFixed(2)} MXN',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(color: AppTheme.primaryYellow),
                ),
                const SizedBox(height: AppSpace.sm),
                Row(
                  children: [
                    const Icon(Icons.hourglass_top, size: 14, color: AppTheme.textMuted),
                    const SizedBox(width: 6),
                    Text(
                      'Pendiente: \$${summary.pending.toStringAsFixed(2)} MXN',
                      style: const TextStyle(color: AppTheme.textMuted, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpace.lg),
          FilledButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/withdrawal'),
            icon: const Icon(Icons.account_balance),
            label: const Text('Solicitar retiro'),
          ),
          const SizedBox(height: AppSpace.xxl),
          Text('Movimientos', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpace.md),
          ...transactions.map((tx) {
            final isPositive = tx.amount >= 0;
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: (isPositive ? AppTheme.success : AppTheme.error).withOpacity(0.15),
                  child: Icon(
                    isPositive ? Icons.arrow_downward : Icons.arrow_upward,
                    color: isPositive ? AppTheme.success : AppTheme.error,
                    size: 18,
                  ),
                ),
                title: Text(tx.description),
                subtitle: Text(tx.kind, style: const TextStyle(color: AppTheme.textMuted)),
                trailing: Text(
                  '${isPositive ? '+' : ''}\$${tx.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isPositive ? AppTheme.success : AppTheme.error,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
