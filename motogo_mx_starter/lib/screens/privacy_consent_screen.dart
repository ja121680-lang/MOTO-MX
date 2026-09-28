import 'package:flutter/material.dart';

import '../services/consent_service.dart';
import '../theme/app_theme.dart';

/// Primera pantalla que ve la app: aviso de privacidad/almacenamiento
/// (equivalente a cookies) con las dos opciones — solo en el dispositivo
/// o respaldo en la nube — antes de crear el PIN.
class PrivacyConsentScreen extends StatefulWidget {
  const PrivacyConsentScreen({super.key, required this.nextRoute});

  final String nextRoute;

  @override
  State<PrivacyConsentScreen> createState() => _PrivacyConsentScreenState();
}

class _PrivacyConsentScreenState extends State<PrivacyConsentScreen> {
  bool _saving = false;

  Future<void> _accept() async {
    setState(() => _saving = true);
    await ConsentService().setConsent(true);
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(widget.nextRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: AppSpace.lg),
            Text('Antes de continuar', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: AppSpace.lg),
            const Text(
              'MotoGo MX usa almacenamiento local en tu teléfono (similar a las cookies de un sitio web) y, cuando inicias sesión, también guarda tu información en nuestros servidores para que tus viajes y tu cuenta funcionen entre dispositivos.',
              style: TextStyle(fontSize: 14, color: AppTheme.textLight, height: 1.5),
            ),
            const SizedBox(height: 20),
            const Text('Tienes dos opciones de privacidad:', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textLight)),
            const SizedBox(height: 10),
            const _ConsentOption(
              icon: Icons.phone_iphone,
              title: 'Solo en este dispositivo',
              body: 'Preferencias y datos temporales que no necesitan sincronizarse se guardan únicamente en tu teléfono.',
            ),
            const SizedBox(height: 12),
            const _ConsentOption(
              icon: Icons.cloud_outlined,
              title: 'En la nube (con tu cuenta)',
              body: 'Tus viajes, cobros y documentos de registro se guardan de forma segura en nuestros servidores, protegidos por tu cuenta.',
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: _saving ? null : _accept,
              child: _saving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2),
                    )
                  : const Text('Aceptar y continuar'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConsentOption extends StatelessWidget {
  const _ConsentOption({required this.icon, required this.title, required this.body});

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpace.md),
      decoration: BoxDecoration(color: AppTheme.surfaceMuted, borderRadius: BorderRadius.circular(AppRadius.md)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.primaryYellow, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.textLight)),
                const SizedBox(height: 4),
                Text(body, style: const TextStyle(fontSize: 12, color: AppTheme.textMuted, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
