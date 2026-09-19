import 'package:flutter/material.dart';

import '../services/lock_service.dart';
import '../theme/app_theme.dart';
import '../utils/security.dart';
import '../widgets/pin_keypad.dart';

/// Pantalla de bloqueo obligatoria: se muestra cada vez que se abre la app
/// (o tras "Bloquear aplicación") si ya existe un PIN guardado. Intenta
/// primero huella/Face ID si está activada, y siempre permite el PIN.
class LockScreen extends StatefulWidget {
  const LockScreen({super.key, required this.nextRoute});

  final String nextRoute;

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final _lockService = LockService();
  String _pin = '';
  String _error = '';
  bool _biometricEnabled = false;
  bool _checkingBiometric = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final enabled = await _lockService.getBiometricEnabled();
    if (!mounted) return;
    setState(() => _biometricEnabled = enabled);
    if (enabled) _tryBiometric();
  }

  void _unlock() {
    LockService.sessionUnlocked = true;
    Navigator.of(context).pushReplacementNamed(widget.nextRoute);
  }

  Future<void> _tryBiometric() async {
    setState(() => _checkingBiometric = true);
    final ok = await _lockService.authenticateBiometric();
    if (!mounted) return;
    setState(() => _checkingBiometric = false);
    if (ok) _unlock();
  }

  Future<void> _handleKey(String key) async {
    if (key == 'del') {
      setState(() {
        _pin = _pin.isEmpty ? _pin : _pin.substring(0, _pin.length - 1);
        _error = '';
      });
      return;
    }
    if (_pin.length >= 4) return;
    final next = _pin + key;
    setState(() {
      _pin = next;
      _error = '';
    });
    if (next.length == 4) {
      final savedHash = await _lockService.getPinHash();
      await Future.delayed(const Duration(milliseconds: 150));
      if (!mounted) return;
      if (hashPin(next) == savedHash) {
        _unlock();
      } else {
        setState(() {
          _error = 'PIN incorrecto, intenta de nuevo.';
          _pin = '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppTheme.primaryYellow,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.lock_outline, color: Colors.black, size: 32),
              ),
              const SizedBox(height: 24),
              const Text(
                'Ingresa tu PIN',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.textLight),
              ),
              const SizedBox(height: 8),
              const Text(
                'Protegemos el acceso a tu cuenta.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.textMuted),
              ),
              const SizedBox(height: 28),
              if (_error.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(_error, style: const TextStyle(color: AppTheme.error, fontSize: 13)),
                ),
              PinKeypad(length: _pin.length, onKeyTap: _handleKey),
              if (_biometricEnabled) ...[
                const SizedBox(height: 24),
                OutlinedButton.icon(
                  onPressed: _checkingBiometric ? null : _tryBiometric,
                  icon: const Icon(Icons.fingerprint),
                  label: Text(_checkingBiometric ? 'Verificando...' : 'Usar huella/Face ID'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
