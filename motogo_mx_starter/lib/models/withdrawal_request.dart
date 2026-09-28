import 'dart:convert';

enum WithdrawalStatus { solicitado, aprobado, pagado }

extension WithdrawalStatusLabel on WithdrawalStatus {
  String get label {
    switch (this) {
      case WithdrawalStatus.solicitado:
        return 'Solicitado';
      case WithdrawalStatus.aprobado:
        return 'Aprobado';
      case WithdrawalStatus.pagado:
        return 'Pagado';
    }
  }
}

/// A driver's withdrawal request — persisted locally so it's a real entry
/// [WalletScreen] can show as a pending movement and the admin dashboard
/// can count, instead of a form that shows a confirmation `SnackBar` and
/// then forgets the request ever happened.
class WithdrawalRequest {
  WithdrawalRequest({
    required this.id,
    required this.amount,
    required this.method,
    required this.requestedAt,
    this.status = WithdrawalStatus.solicitado,
  });

  final String id;
  final double amount;
  final String method;
  final DateTime requestedAt;
  WithdrawalStatus status;

  Map<String, dynamic> toJson() => {
        'id': id,
        'amount': amount,
        'method': method,
        'requestedAt': requestedAt.toIso8601String(),
        'status': status.name,
      };

  static WithdrawalRequest fromJson(Map<String, dynamic> json) => WithdrawalRequest(
        id: json['id'] as String,
        amount: (json['amount'] as num).toDouble(),
        method: json['method'] as String,
        requestedAt: DateTime.parse(json['requestedAt'] as String),
        status: WithdrawalStatus.values.byName(json['status'] as String),
      );

  String encode() => jsonEncode(toJson());
  static WithdrawalRequest decode(String raw) =>
      WithdrawalRequest.fromJson(jsonDecode(raw) as Map<String, dynamic>);
}
