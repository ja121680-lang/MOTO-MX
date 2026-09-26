/// Single source of truth for MotoGo MX's business pricing rules, so the
/// commission rate lives in exactly one place instead of being repeated
/// as a literal across models/screens/services.
class PricingConfig {
  /// Platform commission taken from each trip's fare.
  /// MotoGo MX business rule: 8%.
  static const double platformFeeRate = 0.08;
}
