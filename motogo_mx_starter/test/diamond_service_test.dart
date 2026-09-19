import 'package:flutter_test/flutter_test.dart';
import 'package:motogo_mx/services/diamond_service.dart';

void main() {
  group('DiamondService.qualifies', () {
    const service = DiamondService();

    test('qualifies a driver meeting all three thresholds', () {
      final result = service.qualifies(completedTrips: 134, rating: 4.91, cancellationRate: 0.05);
      expect(result, isTrue);
    });

    test('rejects a driver below the trip count threshold', () {
      final result = service.qualifies(completedTrips: 40, rating: 4.9, cancellationRate: 0.02);
      expect(result, isFalse);
    });

    test('rejects a driver below the rating threshold', () {
      final result = service.qualifies(completedTrips: 150, rating: 4.5, cancellationRate: 0.02);
      expect(result, isFalse);
    });

    test('rejects a driver above the cancellation-rate threshold', () {
      final result = service.qualifies(completedTrips: 150, rating: 4.9, cancellationRate: 0.15);
      expect(result, isFalse);
    });

    test('qualifies exactly at the boundary values', () {
      final result = service.qualifies(completedTrips: 100, rating: 4.8, cancellationRate: 0.08);
      expect(result, isTrue);
    });
  });
}
