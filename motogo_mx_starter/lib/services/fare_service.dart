import '../models/fare_quote.dart';

class FareConfig {
  final double baseFare;
  final double perKm;
  final double perMinute;
  final double minimumFare;

  const FareConfig({
    this.baseFare = 15,
    this.perKm = 7,
    this.perMinute = 1.2,
    this.minimumFare = 25,
  });
}

class FareService {
  final FareConfig config;

  const FareService({this.config = const FareConfig()});

  FareQuote quote({
    required double distanceKm,
    required int etaMinutes,
  }) {
    final distanceFare = distanceKm * config.perKm;
    final timeFare = etaMinutes * config.perMinute;
    final raw = config.baseFare + distanceFare + timeFare;
    final total = raw < config.minimumFare ? config.minimumFare : raw;

    return FareQuote(
      distanceKm: distanceKm,
      etaMinutes: etaMinutes,
      baseFare: config.baseFare,
      distanceFare: distanceFare,
      timeFare: timeFare,
      totalFare: double.parse(total.toStringAsFixed(2)),
    );
  }
}
