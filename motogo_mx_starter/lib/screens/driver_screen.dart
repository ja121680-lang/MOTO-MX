import 'package:flutter/material.dart';

import '../config/pricing_config.dart';
import '../l10n/app_strings.dart';
import '../models/driver_application.dart';
import '../models/trip_record.dart';
import '../services/driver_approval_service.dart';
import '../services/trip_ledger_service.dart';
import '../theme/app_theme.dart';
import 'incoming_request_screen.dart';

/// Driver home (Paquete B). The "Disponible" switch is gated on a real
/// approval status from [DriverApprovalService] — a driver whose
/// application hasn't been approved cannot go online, matching the rule
/// "conductor no puede estar disponible sin aprobación".
class DriverScreen extends StatefulWidget {
  const DriverScreen({super.key});

  @override
  State<DriverScreen> createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {
  final _approvalService = DriverApprovalService();
  final _ledger = TripLedgerService();

  bool online = false;
  bool _loading = true;
  DriverApplication? _application;
  List<TripRecord> _todayTrips = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final application = await _approvalService.currentApplication();
    final trips = await _ledger.getTrips();
    final now = DateTime.now();
    final today = trips.where((t) =>
        t.completedAt.year == now.year && t.completedAt.month == now.month && t.completedAt.day == now.day);
    if (!mounted) return;
    setState(() {
      _application = application;
      _todayTrips = today.toList();
      _loading = false;
      if (application?.status != DriverApplicationStatus.approved) online = false;
    });
  }

  bool get _isApproved => _application?.status == DriverApplicationStatus.approved;

  String get _statusMessage {
    switch (_application?.status) {
      case null:
        return S.t('Completa tu registro para poder recibir viajes.');
      case DriverApplicationStatus.pending:
        return S.t('Tu registro está en revisión. Te avisaremos cuando esté aprobado.');
      case DriverApplicationStatus.rejected:
        return S.t('Tu registro fue rechazado. Revisa el motivo y vuelve a enviarlo.');
      case DriverApplicationStatus.needsCorrection:
        return S.t('Tu registro necesita una corrección antes de aprobarse.');
      case DriverApplicationStatus.approved:
        return S.t('Cuenta aprobada — puedes activarte para recibir viajes.');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: AppTheme.primaryYellow)));
    }

    final feePct = (PricingConfig.platformFeeRate * 100).toStringAsFixed(0);
    final todayGross = _todayTrips.fold<double>(0, (sum, t) => sum + t.fare);
    final todayNet = _todayTrips.fold<double>(0, (sum, t) => sum + t.driverNet);

    return Scaffold(
      appBar: AppBar(title: Text(S.t('Conductor'))),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(AppSpace.xl),
              decoration: BoxDecoration(
                color: online ? AppTheme.success.withValues(alpha: 0.12) : AppTheme.surfaceElevated,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: online ? AppTheme.success : AppTheme.divider),
                boxShadow: online ? AppTheme.glow(AppTheme.success, opacity: 0.15) : null,
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: online ? AppTheme.success : AppTheme.surfaceMuted,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      online ? Icons.check : Icons.pause,
                      color: online ? Colors.black : AppTheme.textMuted,
                    ),
                  ),
                  const SizedBox(width: AppSpace.lg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          online ? S.t('Disponible') : S.t('Fuera de línea'),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(S.t('Estado para recibir solicitudes'),
                            style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                      ],
                    ),
                  ),
                  Switch(
                    value: online,
                    onChanged: _isApproved ? (v) => setState(() => online = v) : null,
                  ),
                ],
              ),
            ),
            if (!_isApproved) ...[
              const SizedBox(height: AppSpace.md),
              Container(
                padding: const EdgeInsets.all(AppSpace.md),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  border: Border.all(color: AppTheme.warning.withValues(alpha: 0.4)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, size: 18, color: AppTheme.warning),
                    const SizedBox(width: AppSpace.sm),
                    Expanded(
                      child: Text(_statusMessage, style: const TextStyle(fontSize: 12.5, color: AppTheme.textMuted)),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: AppSpace.xxl),
            if (online)
              FilledButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const IncomingRequestScreen()),
                ),
                icon: const Icon(Icons.notifications_active_outlined),
                label: Text(S.t('Simular solicitud entrante')),
              )
            else
              FilledButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/driver-registration'),
                icon: const Icon(Icons.app_registration),
                label: Text(S.t('Completar registro de conductor')),
              ),
            const SizedBox(height: AppSpace.xxl),
            SectionHeader(S.t('Ganancias de hoy')),
            const SizedBox(height: AppSpace.md),
            Container(
              padding: const EdgeInsets.all(AppSpace.lg),
              decoration: BoxDecoration(
                color: AppTheme.surfaceElevated,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppTheme.divider),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(S.t('Viajes completados'),
                            style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                        const SizedBox(height: 4),
                        Text('${_todayTrips.length}', style: Theme.of(context).textTheme.titleLarge),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${S.t('Comisión plataforma')} ($feePct%)',
                            style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                        const SizedBox(height: 4),
                        Text('\$${(todayGross - todayNet).toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.titleLarge),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(S.t('Saldo disponible'), style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                        const SizedBox(height: 4),
                        Text(
                          '\$${todayNet.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppTheme.primaryYellow),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpace.xxl),
            SectionHeader(S.t('Accesos rápidos')),
            const SizedBox(height: AppSpace.md),
            Card(
              child: ListTile(
                leading: const Icon(Icons.account_balance_wallet),
                title: Text(S.t('Wallet')),
                subtitle: Text(S.t('Saldo, comisiones y retiros')),
                trailing: const Icon(Icons.chevron_right, color: AppTheme.textMuted),
                onTap: () => Navigator.pushNamed(context, '/wallet'),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.workspace_premium, color: Color(0xFF60D6F0)),
                title: Text(S.t('Nivel Diamond')),
                subtitle: Text(S.t('Beneficios y requisitos')),
                trailing: const Icon(Icons.chevron_right, color: AppTheme.textMuted),
                onTap: () => Navigator.pushNamed(context, '/diamond'),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.history),
                title: Text(S.t('Historial')),
                subtitle: Text(S.t('Viajes y movimientos')),
                trailing: const Icon(Icons.chevron_right, color: AppTheme.textMuted),
                onTap: () => Navigator.pushNamed(context, '/history'),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.support_agent),
                title: Text(S.t('Soporte')),
                subtitle: Text(S.t('Ayuda y contacto')),
                trailing: const Icon(Icons.chevron_right, color: AppTheme.textMuted),
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(S.t('Soporte en vivo próximamente. Escribe a soporte@motogomx.mx.'))),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
