import '../config/pricing_config.dart';

class FareQuote {
  final double distanceKm;
  final int etaMinutes;
  final double baseFare;
  final double distanceFare;
  final double timeFare;
  final double totalFare;

  const FareQuote({
    required this.distanceKm,
    required this.etaMinutes,
    required this.baseFare,
    required this.distanceFare,
    required this.timeFare,
    required this.totalFare,
  });

  double get platformFee => totalFare * PricingConfig.platformFeeRate;
  double get driverNet => totalFare - platformFee;
}
