import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:motogo_mx/models/driver_application.dart';
import 'package:motogo_mx/models/driver_registration.dart';
import 'package:motogo_mx/services/driver_approval_service.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('DriverApprovalService', () {
    test('submit creates a pending application that shows up in pending() and all()', () async {
      final service = DriverApprovalService();
      final data = DriverRegistrationData()
        ..fullName = 'Juana Pérez'
        ..plate = 'MGO-001';

      final application = await service.submit(data);

      expect(application.status, DriverApplicationStatus.pending);
      final pending = await service.pending();
      expect(pending.length, 1);
      expect(pending.first.data.fullName, 'Juana Pérez');
      expect((await service.all()).length, 1);
    });

    test('decide records the decision and removes the application from pending()', () async {
      final service = DriverApprovalService();
      final application = await service.submit(DriverRegistrationData()..fullName = 'Test');

      await service.decide(application.id, DriverApplicationStatus.approved);

      final all = await service.all();
      expect(all.single.status, DriverApplicationStatus.approved);
      expect(all.single.decisions, hasLength(1));
      expect(await service.pending(), isEmpty);
    });

    test('rejecting keeps the reason in the decision log', () async {
      final service = DriverApprovalService();
      final application = await service.submit(DriverRegistrationData()..fullName = 'Test');

      await service.decide(application.id, DriverApplicationStatus.rejected, reason: 'Placa ilegible');

      final all = await service.all();
      expect(all.single.status, DriverApplicationStatus.rejected);
      expect(all.single.decisions.single.reason, 'Placa ilegible');
    });

    test('currentApplication tracks this device\'s own submission', () async {
      final service = DriverApprovalService();
      expect(await service.currentApplication(), isNull);

      final application = await service.submit(DriverRegistrationData()..fullName = 'Test');
      final current = await service.currentApplication();

      expect(current?.id, application.id);
    });
  });
}
