import '../config/pricing_config.dart';
import '../models/wallet.dart';

class WalletService {
  const WalletService();

  WalletSummary demoSummary() {
    return const WalletSummary(
      available: 846.50,
      pending: 120.00,
      lifetimeEarnings: 6840.00,
      lifetimePlatformFees: 684.00,
    );
  }

  List<WalletTransaction> demoTransactions() {
    const demoFare = 90.0;
    final fee = demoFare * PricingConfig.platformFeeRate;
    return [
      WalletTransaction(
        id: 'tx_1',
        kind: 'trip_credit',
        description: 'Viaje completado #MGX-1048',
        amount: demoFare - fee,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      WalletTransaction(
        id: 'tx_2',
        kind: 'platform_fee',
        description: 'Comisión MotoGo MX ${(PricingConfig.platformFeeRate * 100).toStringAsFixed(0)}%',
        amount: -fee,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      WalletTransaction(
        id: 'tx_3',
        kind: 'withdrawal',
        description: 'Retiro a cuenta registrada',
        amount: -500.00,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  bool canWithdraw({
    required double availableBalance,
    required double amount,
    required bool diamondEnabled,
  }) {
    if (!diamondEnabled) return false;
    if (amount <= 0) return false;
    return amount <= availableBalance;
  }
}
