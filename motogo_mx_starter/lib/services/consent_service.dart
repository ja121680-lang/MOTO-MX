import 'package:shared_preferences/shared_preferences.dart';

/// Aviso de privacidad/almacenamiento (equivalente a cookies) que se
/// muestra una sola vez, antes que cualquier otra pantalla.
class ConsentService {
  static const _key = 'motogo_privacy_consent_ok';

  Future<bool> getConsent() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? false;
  }

  Future<void> setConsent(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, value);
  }
}
