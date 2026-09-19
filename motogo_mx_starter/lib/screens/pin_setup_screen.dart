import 'package:flutter/material.dart';

import '../services/lock_service.dart';
import '../theme/app_theme.dart';
import '../utils/security.dart';
import '../widgets/pin_keypad.dart';

/// Pantalla obligatoria para crear el PIN de acceso (y activar huella/Face ID
/// si el dispositivo lo soporta) antes de poder usar la app.
class PinSetupScreen extends StatefulWidget {
  const PinSetupScreen({super.key, required this.nextRoute});

  final String nextRoute;

  @override
  State<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends State<PinSetupScreen> {
  final _lockService = LockService();
  String _stage = 'create'; // 'create' | 'confirm'
  String _pin = '';
  String _confirmPin = '';
  String _error = '';
  bool _biometricAvailable = false;
  bool _biometricEnabled = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _checkBiometric();
  }

  Future<void> _checkBiometric() async {
    final available = await _lockService.isBiometricAvailable();
    if (mounted) setState(() => _biometricAvailable = available);
  }

  void _handleKey(String key) {
    if (_saving) return;
    final isCreate = _stage == 'create';
    final current = isCreate ? _pin : _confirmPin;

    if (key == 'del') {
      setState(() {
        if (isCreate) {
          _pin = current.isEmpty ? current : current.substring(0, current.length - 1);
        } else {
          _confirmPin = current.isEmpty ? current : current.substring(0, current.length - 1);
        }
        _error = '';
      });
      return;
    }
    if (current.length >= 4) return;

    final next = current + key;
    setState(() {
      if (isCreate) {
        _pin = next;
      } else {
        _confirmPin = next;
      }
      _error = '';
    });

    if (next.length == 4) {
      Future.delayed(const Duration(milliseconds: 150), () {
        if (!mounted) return;
        if (isCreate) {
          setState(() => _stage = 'confirm');
        } else if (next == _pin) {
          _finish(next);
        } else {
          setState(() {
            _error = 'Los PIN no coinciden. Intenta de nuevo.';
            _pin = '';
            _confirmPin = '';
            _stage = 'create';
          });
        }
      });
    }
  }

  Future<void> _finish(String pin) async {
    setState(() => _saving = true);
    await _lockService.savePinHash(hashPin(pin));
    await _lockService.setBiometricEnabled(_biometricEnabled);
    LockService.sessionUnlocked = true;
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(widget.nextRoute);
  }

  @override
  Widget build(BuildContext context) {
    final current = _stage == 'create' ? _pin : _confirmPin;
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
              Text(
                _stage == 'create' ? 'Crea tu PIN de acceso' : 'Confirma tu PIN',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.textLight),
              ),
              const SizedBox(height: 8),
              const Text(
                'Este PIN protege tu cuenta. Es obligatorio para usar la app.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.textMuted),
              ),
              const SizedBox(height: 28),
              if (_error.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(_error, style: const TextStyle(color: AppTheme.error, fontSize: 13)),
                ),
              PinKeypad(length: current.length, onKeyTap: _handleKey, enabled: !_saving),
              if (_biometricAvailable) ...[
                const SizedBox(height: 24),
                OutlinedButton.icon(
                  onPressed: _saving ? null : () => setState(() => _biometricEnabled = !_biometricEnabled),
                  icon: const Icon(Icons.fingerprint),
                  label: Text(_biometricEnabled ? 'Huella/Face ID activada' : 'Activar huella/Face ID como acceso rápido'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
