class DriverCandidate {
  final String id;
  final String name;
  final String plate;
  final String economicNumber;
  final String unionName;
  final double rating;
  final double distanceKm;
  final int etaMinutes;

  const DriverCandidate({
    required this.id,
    required this.name,
    required this.plate,
    required this.economicNumber,
    required this.unionName,
    required this.rating,
    required this.distanceKm,
    required this.etaMinutes,
  });
}

class DriverMatchingService {
  const DriverMatchingService();

  List<DriverCandidate> nearbyDrivers() {
    final drivers = [
      const DriverCandidate(
        id: 'drv_1',
        name: 'Carlos M.',
        plate: 'ABC-123',
        economicNumber: '27',
        unionName: 'Sindicato Centro',
        rating: 4.9,
        distanceKm: 0.8,
        etaMinutes: 3,
      ),
      const DriverCandidate(
        id: 'drv_2',
        name: 'Luis R.',
        plate: 'XYZ-987',
        economicNumber: '14',
        unionName: 'Sindicato Norte',
        rating: 4.8,
        distanceKm: 1.4,
        etaMinutes: 5,
      ),
      const DriverCandidate(
        id: 'drv_3',
        name: 'Marta P.',
        plate: 'MGO-421',
        economicNumber: '08',
        unionName: 'Sindicato Centro',
        rating: 4.95,
        distanceKm: 2.1,
        etaMinutes: 7,
      ),
    ];

    drivers.sort((a, b) {
      final etaCompare = a.etaMinutes.compareTo(b.etaMinutes);
      if (etaCompare != 0) return etaCompare;
      return b.rating.compareTo(a.rating);
    });
    return drivers;
  }
}
