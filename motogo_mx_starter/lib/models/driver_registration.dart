import 'dart:convert';

enum DriverRegistrationStep {
  personalData,
  biometrics,
  vehicle,
  unionInfo,
  documents,
  review,
}

const kDriverDocumentNames = [
  'Identificación oficial',
  'Licencia',
  'Tarjeta de circulación',
  'Comprobante de domicilio',
  'Foto de la moto',
];

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

  /// Foto de cada documento, codificada en base64. Un documento cuenta como
  /// "subido" cuando tiene una foto real, no una casilla marcada a mano.
  final Map<String, String?> documentPhotos = {
    for (final name in kDriverDocumentNames) name: null,
  };

  bool get requiredDocumentsComplete =>
      documentPhotos.values.every((photo) => photo != null);

  bool get readyForReview =>
      fullName.trim().isNotEmpty &&
      phone.trim().isNotEmpty &&
      plate.trim().isNotEmpty &&
      biometricVerified &&
      requiredDocumentsComplete &&
      acceptedTerms;

  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'phone': phone,
        'email': email,
        'plate': plate,
        'make': make,
        'model': model,
        'color': color,
        'economicNumber': economicNumber,
        'unionName': unionName,
        'biometricVerified': biometricVerified,
        'acceptedTerms': acceptedTerms,
        'documentPhotos': documentPhotos,
      };

  static DriverRegistrationData fromJson(Map<String, dynamic> json) {
    final data = DriverRegistrationData()
      ..fullName = json['fullName'] as String? ?? ''
      ..phone = json['phone'] as String? ?? ''
      ..email = json['email'] as String? ?? ''
      ..plate = json['plate'] as String? ?? ''
      ..make = json['make'] as String? ?? ''
      ..model = json['model'] as String? ?? ''
      ..color = json['color'] as String? ?? ''
      ..economicNumber = json['economicNumber'] as String? ?? ''
      ..unionName = json['unionName'] as String? ?? ''
      ..biometricVerified = json['biometricVerified'] as bool? ?? false
      ..acceptedTerms = json['acceptedTerms'] as bool? ?? false;
    final photos = json['documentPhotos'] as Map<String, dynamic>?;
    if (photos != null) {
      for (final name in kDriverDocumentNames) {
        data.documentPhotos[name] = photos[name] as String?;
      }
    }
    return data;
  }

  String encode() => jsonEncode(toJson());
  static DriverRegistrationData decode(String raw) =>
      DriverRegistrationData.fromJson(jsonDecode(raw) as Map<String, dynamic>);
}
