/// Single source of truth for MotoGo MX's business pricing rules, so the
/// commission rate lives in exactly one place instead of being repeated
/// as a literal across models/screens/services.
class PricingConfig {
  /// Platform commission taken from each trip's fare. Confirmed by the
  /// app owner: 10% for MotoGo MX (not the 8% this starter shipped with —
  /// that was this project's placeholder default, not the agreed rate).
  static const double platformFeeRate = 0.10;
}
