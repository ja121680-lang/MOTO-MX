enum DriverRegistrationStep {
  personalData,
  biometrics,
  vehicle,
  unionInfo,
  documents,
  review,
}

class DriverRegistrationData {
  String fullName = '';
  String phone = '';
  String email = '';
  String plate = '';
  String make = '';
  String model = '';
  String color = '';
  String economicNumber = '';
  String unionName = '';
  bool biometricVerified = false;
  bool acceptedTerms = false;

  final Map<String, bool> documents = {
    'Identificación oficial': false,
    'Licencia': false,
    'Tarjeta de circulación': false,
    'Comprobante de domicilio': false,
    'Foto de la moto': false,
  };

  bool get requiredDocumentsComplete =>
      documents.values.every((uploaded) => uploaded);

  bool get readyForReview =>
      fullName.trim().isNotEmpty &&
      phone.trim().isNotEmpty &&
      plate.trim().isNotEmpty &&
      biometricVerified &&
      requiredDocumentsComplete &&
      acceptedTerms;
}
