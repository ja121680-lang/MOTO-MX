class DiamondStatus {
  final bool enabled;
  final int completedTrips;
  final double rating;
  final double cancellationRate;

  const DiamondStatus({
    required this.enabled,
    required this.completedTrips,
    required this.rating,
    required this.cancellationRate,
  });
}

class DiamondService {
  const DiamondService();

  bool qualifies({
    required int completedTrips,
    required double rating,
    required double cancellationRate,
  }) {
    return completedTrips >= 100 &&
        rating >= 4.8 &&
        cancellationRate <= 0.08;
  }
}
