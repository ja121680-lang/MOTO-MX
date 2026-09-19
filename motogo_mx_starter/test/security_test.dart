import 'package:flutter_test/flutter_test.dart';
import 'package:motogo_mx/utils/security.dart';

void main() {
  group('hashPin', () {
    test('is deterministic for the same PIN', () {
      expect(hashPin('1234'), hashPin('1234'));
    });

    test('never returns the PIN itself (not stored in plain text)', () {
      expect(hashPin('1234'), isNot('1234'));
    });

    test('different PINs hash differently', () {
      expect(hashPin('1234'), isNot(hashPin('4321')));
      expect(hashPin('1234'), isNot(hashPin('0000')));
    });
  });
}
