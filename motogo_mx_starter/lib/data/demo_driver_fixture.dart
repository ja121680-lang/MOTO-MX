/// Consistent test/demo driver data for screens that show an assigned
/// driver before a real matching backend exists (Paquete 01). Lives in one
/// fixture instead of being retyped — and risking drifting — inside each
/// widget that needs it (matching, live tracking).
class DemoDriverFixture {
  static const String name = 'Carlos M.';
  static const double rating = 4.9;
  static const String motorcycle = 'Italika FT 125';
  static const String plate = 'ABC-123';
  static const String economicNumber = '27';
  static const String union = 'Sindicato demo';

  /// Plate with the middle characters masked, e.g. `ABC-123` → `AB•-•23`,
  /// so it reads as real personal/vehicle data instead of something to
  /// screenshot and share — required wherever a driver's plate is shown
  /// to a passenger before/while a trip is in progress.
  static String get maskedPlate {
    if (plate.length <= 4) return plate;
    final chars = plate.split('');
    for (var i = 2; i < chars.length - 2; i++) {
      if (chars[i] != '-') chars[i] = '•';
    }
    return chars.join();
  }
}
