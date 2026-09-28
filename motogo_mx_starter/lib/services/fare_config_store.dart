import 'package:shared_preferences/shared_preferences.dart';

import '../services/fare_service.dart';

/// Lets admin edit the base fare/per-km/per-minute/minimum-fare rates used
/// by [FareService], persisted locally, instead of only the hardcoded
/// [FareConfig] defaults. Single default zone for now — per-zone tariffs
/// need a real zones model, listed as a pendiente.
class FareConfigStore {
  static const _baseFareKey = 'motogo_fare_base';
  static const _perKmKey = 'motogo_fare_per_km';
  static const _perMinuteKey = 'motogo_fare_per_minute';
  static const _minimumFareKey = 'motogo_fare_minimum';

  static const _defaults = FareConfig();

  Future<FareConfig> load() async {
    final prefs = await SharedPreferences.getInstance();
    return FareConfig(
      baseFare: prefs.getDouble(_baseFareKey) ?? _defaults.baseFare,
      perKm: prefs.getDouble(_perKmKey) ?? _defaults.perKm,
      perMinute: prefs.getDouble(_perMinuteKey) ?? _defaults.perMinute,
      minimumFare: prefs.getDouble(_minimumFareKey) ?? _defaults.minimumFare,
    );
  }

  Future<void> save(FareConfig config) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_baseFareKey, config.baseFare);
    await prefs.setDouble(_perKmKey, config.perKm);
    await prefs.setDouble(_perMinuteKey, config.perMinute);
    await prefs.setDouble(_minimumFareKey, config.minimumFare);
  }

  Future<void> resetToDefaults() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_baseFareKey);
    await prefs.remove(_perKmKey);
    await prefs.remove(_perMinuteKey);
    await prefs.remove(_minimumFareKey);
  }
}
