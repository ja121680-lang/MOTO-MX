import 'package:shared_preferences/shared_preferences.dart';

import '../models/driver_registration.dart';

/// Guarda el registro del conductor en curso — para que no se pierda si
/// cierra la app a la mitad (no es solo llenar páginas y listo).
class DriverRegistrationStore {
  static const _key = 'motogo_driver_registration';

  Future<DriverRegistrationData?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return null;
    return DriverRegistrationData.decode(raw);
  }

  Future<void> save(DriverRegistrationData data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, data.encode());
  }
}
