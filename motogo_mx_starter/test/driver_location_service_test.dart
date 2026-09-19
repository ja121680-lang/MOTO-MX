import 'package:flutter_test/flutter_test.dart';
import 'package:motogo_mx/services/driver_location_service.dart';

void main() {
  group('DriverLocationService.watchTripLocation', () {
    test('falls back to the simulated route when no backend is configured', () async {
      final service = DriverLocationService();
      var reportedLive = true; // starts wrong on purpose so the callback must flip it

      final stream = service.watchTripLocation('demo-trip', onModeKnown: (live) => reportedLive = live);

      final first = await stream.first;
      expect(reportedLive, isFalse, reason: 'AppConfig has no --dart-define values in tests, so this must be demo mode');
      expect(first.lat, isNotNull);
      expect(first.lng, isNotNull);
    });
  });
}
