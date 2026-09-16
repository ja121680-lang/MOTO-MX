import 'package:flutter/material.dart';
import '../services/wallet_service.dart';

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
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Saldo disponible'),
                  Text(
                    '\$${summary.available.toStringAsFixed(2)} MXN',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Pendiente: \$${summary.pending.toStringAsFixed(2)}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/withdrawal'),
            icon: const Icon(Icons.account_balance),
            label: const Text('Solicitar retiro'),
          ),
          const SizedBox(height: 20),
          const Text(
            'Movimientos',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          ...transactions.map(
            (tx) => Card(
              child: ListTile(
                title: Text(tx.description),
                subtitle: Text(tx.kind),
                trailing: Text(
                  '${tx.amount >= 0 ? '+' : ''}\$${tx.amount.toStringAsFixed(2)}',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
