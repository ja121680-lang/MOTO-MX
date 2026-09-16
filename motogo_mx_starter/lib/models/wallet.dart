class WalletSummary {
  final double available;
  final double pending;
  final double lifetimeEarnings;
  final double lifetimePlatformFees;

  const WalletSummary({
    required this.available,
    required this.pending,
    required this.lifetimeEarnings,
    required this.lifetimePlatformFees,
  });
}

class WalletTransaction {
  final String id;
  final String kind;
  final String description;
  final double amount;
  final DateTime createdAt;

  const WalletTransaction({
    required this.id,
    required this.kind,
    required this.description,
    required this.amount,
    required this.createdAt,
  });
}
