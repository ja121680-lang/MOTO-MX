import 'package:flutter_test/flutter_test.dart';
import 'package:motogo_mx/services/fare_service.dart';

void main() {
  group('FareService', () {
    const service = FareService();

    test('computes base + distance + time fare', () {
      final quote = service.quote(distanceKm: 4.2, etaMinutes: 11);

      // 15 + (4.2 * 7) + (11 * 1.2) = 15 + 29.4 + 13.2 = 57.6
      expect(quote.totalFare, 57.6);
      expect(quote.distanceKm, 4.2);
      expect(quote.etaMinutes, 11);
    });

    test('enforces the minimum fare for very short trips', () {
      final quote = service.quote(distanceKm: 0.2, etaMinutes: 1);

      // raw = 15 + 1.4 + 1.2 = 17.6, below the 25 minimum
      expect(quote.totalFare, 25.0);
    });

    test('respects a custom FareConfig', () {
      const customService = FareService(
        config: FareConfig(baseFare: 20, perKm: 10, perMinute: 2, minimumFare: 30),
      );

      final quote = customService.quote(distanceKm: 5, etaMinutes: 5);

      // 20 + 50 + 10 = 80
      expect(quote.totalFare, 80.0);
    });
  });
}
