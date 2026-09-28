import 'package:flutter_test/flutter_test.dart';
import 'package:motogo_mx/services/wallet_service.dart';

void main() {
  group('WalletService.canWithdraw', () {
    const service = WalletService();

    test('allows a withdrawal within balance for a Diamond driver', () {
      expect(
        service.canWithdraw(availableBalance: 800, amount: 500, diamondEnabled: true),
        isTrue,
      );
    });

    test('blocks withdrawal for a non-Diamond driver', () {
      expect(
        service.canWithdraw(availableBalance: 800, amount: 100, diamondEnabled: false),
        isFalse,
      );
    });

    test('blocks a withdrawal larger than the available balance', () {
      expect(
        service.canWithdraw(availableBalance: 800, amount: 900, diamondEnabled: true),
        isFalse,
      );
    });

    test('blocks a zero or negative amount', () {
      expect(service.canWithdraw(availableBalance: 800, amount: 0, diamondEnabled: true), isFalse);
      expect(service.canWithdraw(availableBalance: 800, amount: -10, diamondEnabled: true), isFalse);
    });
  });
}
