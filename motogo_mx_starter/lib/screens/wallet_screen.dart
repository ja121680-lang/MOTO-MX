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
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.primaryYellow.withOpacity(0.4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Saldo disponible', style: TextStyle(color: AppTheme.textMuted)),
                const SizedBox(height: 6),
                Text(
                  '\$${summary.available.toStringAsFixed(2)} MXN',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryYellow,
                  ),
                ),
                const SizedBox(height: 10),
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
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/withdrawal'),
            icon: const Icon(Icons.account_balance),
            label: const Text('Solicitar retiro'),
          ),
          const SizedBox(height: 24),
          const Text('Movimientos', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 12),
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
