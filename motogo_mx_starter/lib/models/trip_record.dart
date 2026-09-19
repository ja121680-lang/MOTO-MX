import '../config/pricing_config.dart';

/// How the passenger actually paid — kept open-ended per trip rather than
/// tied to one processor, since drivers can be paid in cash, by bank
/// transfer, or through in-app payment.
enum MetodoPago { efectivo, transferencia, tarjeta, app }

extension MetodoPagoLabel on MetodoPago {
  String get label {
    switch (this) {
      case MetodoPago.efectivo:
        return 'Efectivo';
      case MetodoPago.transferencia:
        return 'Transferencia';
      case MetodoPago.tarjeta:
        return 'Tarjeta';
      case MetodoPago.app:
        return 'Pago en la app';
    }
  }
}

/// A completed trip's money split, persisted locally so "Corte de caja"
/// can show real totals instead of one hardcoded demo trip. Kept simple
/// on purpose: this is the local ledger until a real backend is
/// connected (supabase/schema.sql's `trips`/`payments` tables already
/// model the same split server-side).
class TripRecord {
  const TripRecord({
    required this.id,
    required this.route,
    required this.fare,
    required this.metodoPago,
    required this.completedAt,
    this.platformFeeRate = PricingConfig.platformFeeRate,
  });

  final String id;
  final String route;
  final double fare;
  final double platformFeeRate;
  final MetodoPago metodoPago;
  final DateTime completedAt;

  double get platformFee => fare * platformFeeRate;
  double get driverNet => fare - platformFee;

  factory TripRecord.fromJson(Map<String, dynamic> json) => TripRecord(
        id: json['id'] as String,
        route: json['route'] as String,
        fare: (json['fare'] as num).toDouble(),
        platformFeeRate: (json['platformFeeRate'] as num).toDouble(),
        metodoPago: MetodoPago.values.byName(json['metodoPago'] as String),
        completedAt: DateTime.parse(json['completedAt'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'route': route,
        'fare': fare,
        'platformFeeRate': platformFeeRate,
        'metodoPago': metodoPago.name,
        'completedAt': completedAt.toIso8601String(),
      };
}
