import 'package:flutter_test/flutter_test.dart';
import 'package:motogo_mx/models/trip_record.dart';
import 'package:motogo_mx/services/trip_ledger_service.dart';

void main() {
  group('calcularCorteDeCaja', () {
    test('sums fares, platform fees and driver net, split by payment method', () {
      final trips = [
        TripRecord(
          id: '1',
          route: 'A -> B',
          fare: 100,
          metodoPago: MetodoPago.efectivo,
          completedAt: DateTime(2026, 1, 1),
          platformFeeRate: 0.10,
        ),
        TripRecord(
          id: '2',
          route: 'C -> D',
          fare: 50,
          metodoPago: MetodoPago.transferencia,
          completedAt: DateTime(2026, 1, 1),
          platformFeeRate: 0.10,
        ),
        TripRecord(
          id: '3',
          route: 'E -> F',
          fare: 200,
          metodoPago: MetodoPago.efectivo,
          completedAt: DateTime(2026, 1, 1),
          platformFeeRate: 0.10,
        ),
      ];

      final corte = calcularCorteDeCaja(trips);

      expect(corte.tripCount, 3);
      expect(corte.totalFare, 350);
      expect(corte.totalPlatformFee, closeTo(35, 0.001));
      expect(corte.totalDriverNet, closeTo(315, 0.001));
      expect(corte.countByMetodo[MetodoPago.efectivo], 2);
      expect(corte.totalByMetodo[MetodoPago.efectivo], 300);
      expect(corte.countByMetodo[MetodoPago.transferencia], 1);
      expect(corte.totalByMetodo[MetodoPago.transferencia], 50);
      expect(corte.countByMetodo[MetodoPago.tarjeta], 0);
    });

    test('empty ledger returns zeroed totals, not an error', () {
      final corte = calcularCorteDeCaja(const []);
      expect(corte.tripCount, 0);
      expect(corte.totalFare, 0);
      expect(corte.totalPlatformFee, 0);
      expect(corte.totalDriverNet, 0);
    });
  });

  group('TripRecord', () {
    test('platformFee/driverNet use the trip\'s own rate, and round-trip through JSON', () {
      final t = TripRecord(
        id: 'x',
        route: 'Centro -> Playa',
        fare: 90,
        metodoPago: MetodoPago.app,
        completedAt: DateTime(2026, 3, 4, 10, 30),
        platformFeeRate: 0.10,
      );
      expect(t.platformFee, closeTo(9.0, 0.001));
      expect(t.driverNet, closeTo(81.0, 0.001));

      final restored = TripRecord.fromJson(t.toJson());
      expect(restored.fare, 90);
      expect(restored.metodoPago, MetodoPago.app);
      expect(restored.platformFeeRate, 0.10);
    });
  });
}
