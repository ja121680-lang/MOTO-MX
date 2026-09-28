import 'package:flutter/material.dart';

import '../services/consent_service.dart';
import '../services/lock_service.dart';
import '../theme/app_theme.dart';

/// Primera pantalla que ve la app: primero el aviso de privacidad (si no se
/// ha aceptado), luego decide si hay que crear un PIN (primera vez),
/// pedirlo (ya existe pero no se ha desbloqueado esta sesión), o pasar
/// directo a Inicio. El acceso con PIN/huella es obligatorio en MotoGo MX.
class AppGateScreen extends StatefulWidget {
  const AppGateScreen({super.key});

  @override
  State<AppGateScreen> createState() => _AppGateScreenState();
}

class _AppGateScreenState extends State<AppGateScreen> {
  @override
  void initState() {
    super.initState();
    _decide();
  }

  Future<void> _decide() async {
    final hasConsent = await ConsentService().getConsent();
    if (!mounted) return;
    if (!hasConsent) {
      Navigator.of(context).pushReplacementNamed('/privacy-consent');
      return;
    }

    final pinHash = await LockService().getPinHash();
    if (!mounted) return;
    if (pinHash == null) {
      Navigator.of(context).pushReplacementNamed('/pin-setup');
    } else if (!LockService.sessionUnlocked) {
      Navigator.of(context).pushReplacementNamed('/lock');
    } else {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppTheme.background,
      body: Center(
        child: CircularProgressIndicator(color: AppTheme.primaryYellow),
      ),
    );
  }
}
