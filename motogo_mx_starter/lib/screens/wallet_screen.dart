import 'package:flutter/material.dart';
import '../services/wallet_service.dart';
import '../theme/ga_theme.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const service = WalletService();
    final summary = service.demoSummary();
    final transactions = service.demoTransactions();

    return Scaffold(
      appBar: AppBar(title: const Text('Wallet')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 110),
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF211A08), Color(0xFF090909)],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: GAColors.gold),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black45,
                      blurRadius: 26,
                      offset: Offset(0, 14))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.account_balance_wallet_rounded,
                          color: GAColors.goldLight, size: 28),
                      SizedBox(width: 9),
                      Text('SALDO DISPONIBLE',
                          style: TextStyle(
                              color: GAColors.goldLight,
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.1)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    '\$${summary.available.toStringAsFixed(2)} MXN',
                    style: const TextStyle(
                        color: GAColors.white,
                        fontSize: 38,
                        fontWeight: FontWeight.w900,
                        height: 1),
                  ),
                  const SizedBox(height: 13),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.circular(14)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Pendiente',
                                  style: TextStyle(
                                      color: GAColors.muted, fontSize: 13)),
                              const SizedBox(height: 3),
                              Text('\$${summary.pending.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      color: GAColors.white,
                                      fontSize: 19,
                                      fontWeight: FontWeight.w900)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.circular(14)),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Moneda',
                                  style: TextStyle(
                                      color: GAColors.muted, fontSize: 13)),
                              SizedBox(height: 3),
                              Text('MXN',
                                  style: TextStyle(
                                      color: GAColors.white,
                                      fontSize: 19,
                                      fontWeight: FontWeight.w900)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/withdrawal'),
              icon: const Icon(Icons.account_balance_rounded),
              label: const Text('SOLICITAR RETIRO'),
            ),
            const SizedBox(height: 8),
            const Text(
              'Revisa monto y destino antes de confirmar un retiro.',
              textAlign: TextAlign.center,
              style: TextStyle(color: GAColors.muted, fontSize: 13),
            ),
            const SizedBox(height: 24),
            const Text('Movimientos',
                style: TextStyle(
                    color: GAColors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 21)),
            const SizedBox(height: 10),
            if (transactions.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                    color: GAColors.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: GAColors.line)),
                child: const Column(
                  children: [
                    Icon(Icons.receipt_long_outlined,
                        color: GAColors.goldLight, size: 36),
                    SizedBox(height: 10),
                    Text('Sin movimientos todavía',
                        style: TextStyle(
                            color: GAColors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w800)),
                  ],
                ),
              )
            else
              ...transactions.map(
                (tx) {
                  final positive = tx.amount >= 0;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      minVerticalPadding: 12,
                      leading: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: positive
                              ? const Color(0xFF102A1B)
                              : const Color(0xFF2A1616),
                          borderRadius: BorderRadius.circular(13),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                            positive
                                ? Icons.south_west_rounded
                                : Icons.north_east_rounded,
                            color:
                                positive ? GAColors.success : GAColors.danger),
                      ),
                      title: Text(tx.description,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w800)),
                      subtitle: Text(tx.kind,
                          style: const TextStyle(
                              color: GAColors.muted, fontSize: 13)),
                      trailing: Text(
                        '${positive ? '+' : ''}\$${tx.amount.toStringAsFixed(2)}',
                        style: TextStyle(
                            color: positive ? GAColors.success : GAColors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
