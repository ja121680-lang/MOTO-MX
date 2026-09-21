import 'package:flutter_test/flutter_test.dart';
import 'package:motogo_mx/models/driver_registration.dart';

void main() {
  group('DriverRegistrationData', () {
    test('round-trips through encode/decode, including document photos', () {
      final data = DriverRegistrationData()
        ..fullName = 'Juan Pérez'
        ..phone = '9981234567'
        ..plate = 'ABC123'
        ..biometricVerified = true
        ..acceptedTerms = true;
      data.documentPhotos['Licencia'] = 'ZmFrZQ==';

      final restored = DriverRegistrationData.decode(data.encode());

      expect(restored.fullName, 'Juan Pérez');
      expect(restored.plate, 'ABC123');
      expect(restored.documentPhotos['Licencia'], 'ZmFrZQ==');
      expect(restored.documentPhotos['Foto de la moto'], isNull);
    });

    test('requiredDocumentsComplete is false until every document has a photo', () {
      final data = DriverRegistrationData();
      expect(data.requiredDocumentsComplete, isFalse);

      for (final name in kDriverDocumentNames) {
        data.documentPhotos[name] = 'ZmFrZQ==';
      }
      expect(data.requiredDocumentsComplete, isTrue);
    });

    test('readyForReview requires personal data, biometrics, documents and terms', () {
      final data = DriverRegistrationData()
        ..fullName = 'Juan Pérez'
        ..phone = '9981234567'
        ..plate = 'ABC123'
        ..biometricVerified = true;
      for (final name in kDriverDocumentNames) {
        data.documentPhotos[name] = 'ZmFrZQ==';
      }
      expect(data.readyForReview, isFalse); // acceptedTerms still false

      data.acceptedTerms = true;
      expect(data.readyForReview, isTrue);
    });
  });
}
