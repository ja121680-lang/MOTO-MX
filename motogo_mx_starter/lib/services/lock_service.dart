import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Candado de acceso obligatorio de MotoGo MX. Guarda el PIN de acceso
/// (hasheado, no en texto plano) y si la huella/Face ID está activada como
/// acceso rápido.
class LockService {
  LockService();

  static const _pinKey = 'motogo_pin_hash';
  static const _biometricKey = 'motogo_biometric_enabled';

  /// Se reinicia cada vez que arranca el proceso: obliga a desbloquear otra
  /// vez cada vez que se abre la app, aunque el PIN ya exista de antes.
  static bool sessionUnlocked = false;

  final LocalAuthentication _auth = LocalAuthentication();

  Future<String?> getPinHash() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_pinKey);
  }

  Future<void> savePinHash(String hash) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_pinKey, hash);
  }

  Future<void> clearLock() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_pinKey);
    await prefs.remove(_biometricKey);
    sessionUnlocked = false;
  }

  Future<bool> getBiometricEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_biometricKey) ?? false;
  }

  Future<void> setBiometricEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_biometricKey, enabled);
  }

  Future<bool> isBiometricAvailable() async {
    try {
      final supported = await _auth.isDeviceSupported();
      final canCheck = await _auth.canCheckBiometrics;
      return supported && canCheck;
    } catch (e) {
      return false;
    }
  }

  Future<bool> authenticateBiometric() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'Confirma tu identidad para entrar a MotoGo MX',
        options: const AuthenticationOptions(biometricOnly: true, stickyAuth: true),
      );
    } catch (e) {
      return false;
    }
  }
}
