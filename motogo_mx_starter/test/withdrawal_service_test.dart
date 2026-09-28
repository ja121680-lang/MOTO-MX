import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:motogo_mx/models/withdrawal_request.dart';
import 'package:motogo_mx/services/withdrawal_service.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('WithdrawalService', () {
    test('request persists a solicitado withdrawal that shows up in pending()', () async {
      final service = WithdrawalService();

      final withdrawal = await service.request(amount: 250.0, method: 'Transferencia');

      expect(withdrawal.status, WithdrawalStatus.solicitado);
      final pending = await service.pending();
      expect(pending.length, 1);
      expect(pending.first.amount, 250.0);
    });

    test('marking a withdrawal as pagado removes it from pending()', () async {
      final service = WithdrawalService();
      final withdrawal = await service.request(amount: 100.0, method: 'Efectivo');

      await service.updateStatus(withdrawal.id, WithdrawalStatus.pagado);

      expect(await service.pending(), isEmpty);
      final all = await service.all();
      expect(all.single.status, WithdrawalStatus.pagado);
    });

    test('totalRequested sums amounts across requests', () async {
      final service = WithdrawalService();
      await service.request(amount: 100.0, method: 'Efectivo');
      await service.request(amount: 50.0, method: 'Transferencia');

      final all = await service.all();
      expect(service.totalRequested(all), 150.0);
    });
  });
}
