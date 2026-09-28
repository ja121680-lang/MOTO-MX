import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../l10n/app_strings.dart';
import '../services/lock_service.dart';
import '../theme/app_theme.dart';

/// Passenger's real fourth navigation section — text size, app lock, the
/// privacy notice, and (debug builds only) the development-only entry
/// points into driver/admin mode, moved off the passenger's central home
/// screen per Paquete 01.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showPrivacyNotice(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(AppSpace.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(S.t('Aviso de privacidad'), style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpace.md),
            Text(
              S.t(
                'MotoGo MX usa almacenamiento local en tu teléfono (similar a las cookies de un sitio web) y, cuando inicias sesión, también guarda tu información en nuestros servidores para que tus viajes y tu cuenta funcionen entre dispositivos.',
              ),
              style: const TextStyle(color: AppTheme.textMuted, height: 1.5),
            ),
            const SizedBox(height: AppSpace.xl),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(S.t('Entendido')),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _lock(BuildContext context) async {
    LockService.sessionUnlocked = false;
    Navigator.of(context).pushReplacementNamed('/lock');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.t('Perfil'))),
      body: ListView(
        padding: const EdgeInsets.all(AppSpace.xl),
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 32,
                backgroundColor: AppTheme.surfaceElevated,
                child: Icon(Icons.person, size: 32, color: AppTheme.primaryYellow),
              ),
              const SizedBox(width: AppSpace.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(S.t('Tu cuenta'), style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 2),
                    Text(
                      S.t('Pasajero MotoGo MX'),
                      style: const TextStyle(color: AppTheme.textMuted, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpace.xxl),
          SectionHeader(S.t('Preferencias')),
          const SizedBox(height: AppSpace.sm),
          _ProfileTile(
            icon: Icons.text_fields,
            title: S.t('Tamaño de letra'),
            trailing: const TextScaleToggleButton(),
          ),
          _ProfileTile(
            icon: Icons.lock_outline,
            title: S.t('Bloquear aplicación'),
            onTap: () => _lock(context),
          ),
          _ProfileTile(
            icon: Icons.privacy_tip_outlined,
            title: S.t('Aviso de privacidad'),
            onTap: () => _showPrivacyNotice(context),
          ),
          if (kDebugMode) ...[
            const SizedBox(height: AppSpace.xxl),
            SectionHeader(S.t('Acceso de desarrollo (solo QA)')),
            const SizedBox(height: AppSpace.sm),
            _ProfileTile(
              icon: Icons.badge_outlined,
              title: S.t('Modo conductor'),
              onTap: () => Navigator.pushNamed(context, '/driver'),
            ),
            _ProfileTile(
              icon: Icons.admin_panel_settings_outlined,
              title: S.t('Panel administrador'),
              onTap: () => Navigator.pushNamed(context, '/admin'),
            ),
          ],
        ],
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({required this.icon, required this.title, this.onTap, this.trailing});

  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.md),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpace.sm),
        padding: const EdgeInsets.symmetric(horizontal: AppSpace.lg, vertical: AppSpace.md),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppTheme.textMuted),
            const SizedBox(width: AppSpace.md),
            Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600))),
            trailing ?? const Icon(Icons.chevron_right, size: 18, color: AppTheme.textMuted),
          ],
        ),
      ),
    );
  }
}
