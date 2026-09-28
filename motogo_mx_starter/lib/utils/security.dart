/// Hash ligero del PIN para no guardarlo en texto plano en SharedPreferences.
String hashPin(String pin) {
  int h = 0;
  for (final codeUnit in pin.codeUnits) {
    h = (h * 31 + codeUnit) & 0xFFFFFFFF;
  }
  return h.toRadixString(36);
}
