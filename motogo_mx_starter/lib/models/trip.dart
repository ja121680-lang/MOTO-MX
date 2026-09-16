enum TripStatus {
  requested,
  accepted,
  driverArriving,
  pinRequired,
  inProgress,
  completed,
  cancelled,
}

class Trip {
  final String id;
  final String passengerId;
  final String? driverId;
  final TripStatus status;
  final double quotedFare;
  final double platformFeeRate;

  const Trip({
    required this.id,
    required this.passengerId,
    this.driverId,
    required this.status,
    required this.quotedFare,
    this.platformFeeRate = 0.08,
  });

  double get platformFee => quotedFare * platformFeeRate;
  double get driverGross => quotedFare - platformFee;
}
