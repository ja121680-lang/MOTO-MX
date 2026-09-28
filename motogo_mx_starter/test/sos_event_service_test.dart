import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:motogo_mx/models/sos_event.dart';
import 'package:motogo_mx/services/sos_event_service.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('SosEventService', () {
    test('log creates an unattended event, most recent first', () async {
      final service = SosEventService();

      await service.log(role: SosRole.passenger, tripId: 'trip_1');
      await service.log(role: SosRole.driver);

      final events = await service.all();
      expect(events, hasLength(2));
      expect(events.every((e) => !e.attended), isTrue);
      // Most recent (driver) first.
      expect(events.first.role, SosRole.driver);
    });

    test('markAttended flips the event and only that one', () async {
      final service = SosEventService();
      final passengerEvent = await service.log(role: SosRole.passenger);
      await service.log(role: SosRole.driver);

      await service.markAttended(passengerEvent.id);

      final events = await service.all();
      final updated = events.firstWhere((e) => e.id == passengerEvent.id);
      expect(updated.attended, isTrue);
      expect(events.where((e) => e.attended), hasLength(1));
    });
  });
}
