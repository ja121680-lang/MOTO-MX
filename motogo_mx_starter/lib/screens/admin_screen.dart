import 'package:flutter/material.dart';

import '../config/pricing_config.dart';
import '../l10n/app_strings.dart';
import '../models/trip_record.dart';
import '../services/driver_approval_service.dart';
import '../services/sos_event_service.dart';
import '../services/trip_ledger_service.dart';
import '../services/withdrawal_service.dart';
import '../theme/app_theme.dart';
import 'admin_trips_screen.dart';
import 'sos_alerts_screen.dart';

/// Admin dashboard (Paquete C) — a real control center: every tile reads
/// from the same local stores the rest of the app writes to (driver
/// applications, SOS log, trip ledger, withdrawal requests). "Viajes
/// activos" and "conductores disponibles" are honestly unavailable here:
/// this is a single-device demo with no shared backend, so there is no
/// real cross-device signal for either yet — shown as such instead of a
/// fabricated number.
class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  bool _loading = true;
  int _pendingDrivers = 0;
  int _activeSos = 0;
  int _pendingWithdrawals = 0;
  double _todayCommission = 0;
  int _todayTrips = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final pendingDrivers = await DriverApprovalService().pending();
    final sosEvents = await SosEventService().all();
    final withdrawals = await WithdrawalService().pending();
    final trips = await TripLedgerService().getTrips();
    final now = DateTime.now();
    final todayTrips = trips.where((t) =>
        t.completedAt.year == now.year && t.completedAt.month == now.month && t.completedAt.day == now.day);

    if (!mounted) return;
    setState(() {
      _pendingDrivers = pendingDrivers.length;
      _activeSos = sosEvents.where((e) => !e.attended).length;
      _pendingWithdrawals = withdrawals.length;
      _todayTrips = todayTrips.length;
      _todayCommission = todayTrips.fold<double>(0, (sum, TripRecord t) => sum + t.platformFee);
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: AppTheme.primaryYellow)));
    }
    final feePct = (PricingConfig.platformFeeRate * 100).toStringAsFixed(0);

    return Scaffold(
      appBar: AppBar(title: Text(S.t('Administración'))),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.all(AppSpace.xl),
          children: [
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: AppSpace.md,
              mainAxisSpacing: AppSpace.md,
              childAspectRatio: 1.3,
              children: [
                _DashboardTile(
                  icon: Icons.route,
                  label: S.t('Viajes activos'),
                  value: S.t('N/D'),
                  caption: S.t('Requiere backend compartido'),
                  color: AppTheme.textMuted,
                ),
                _DashboardTile(
                  icon: Icons.two_wheeler,
                  label: S.t('Conductores disponibles'),
                  value: S.t('N/D'),
                  caption: S.t('Requiere backend compartido'),
                  color: AppTheme.textMuted,
                ),
                _DashboardTile(
                  icon: Icons.person_search,
                  label: S.t('Conductores pendientes'),
                  value: '$_pendingDrivers',
                  color: _pendingDrivers > 0 ? AppTheme.warning : AppTheme.success,
                  onTap: () => Navigator.pushNamed(context, '/driver-approval'),
                ),
                _DashboardTile(
                  icon: Icons.sos,
                  label: S.t('Alertas SOS activas'),
                  value: '$_activeSos',
                  color: _activeSos > 0 ? AppTheme.error : AppTheme.success,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SosAlertsScreen()),
                  ),
                ),
                _DashboardTile(
                  icon: Icons.percent,
                  label: '${S.t('Comisiones de hoy')} ($feePct%)',
                  value: '\$${_todayCommission.toStringAsFixed(2)}',
                  caption: '$_todayTrips ${S.t('viaje(s)')}',
                  color: AppTheme.primaryYellow,
                  onTap: () => Navigator.pushNamed(context, '/corte-de-caja'),
                ),
                _DashboardTile(
                  icon: Icons.account_balance,
                  label: S.t('Retiros pendientes'),
                  value: '$_pendingWithdrawals',
                  color: _pendingWithdrawals > 0 ? AppTheme.warning : AppTheme.success,
                ),
              ],
            ),
            const SizedBox(height: AppSpace.xxl),
            SectionHeader(S.t('Módulos')),
            const SizedBox(height: AppSpace.md),
            Card(
              child: ListTile(
                leading: const GradientIconBadge(icon: Icons.person_search, size: 44),
                title: Text(S.t('Aprobaciones')),
                subtitle: Text(S.t('Conductores y documentos pendientes')),
                trailing: const Icon(Icons.chevron_right, color: AppTheme.textMuted),
                onTap: () => Navigator.pushNamed(context, '/driver-approval').then((_) => _load()),
              ),
            ),
            Card(
              child: ListTile(
                leading: const GradientIconBadge(icon: Icons.route, size: 44),
                title: Text(S.t('Viajes')),
                subtitle: Text(S.t('Seguimiento, incidencias e historial')),
                trailing: const Icon(Icons.chevron_right, color: AppTheme.textMuted),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminTripsScreen()),
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(color: AppTheme.error.withValues(alpha: 0.15), shape: BoxShape.circle),
                  child: const Icon(Icons.warning_amber, color: AppTheme.error),
                ),
                title: Text(S.t('Seguridad')),
                subtitle: Text(S.t('SOS, reportes y bloqueos')),
                trailing: const Icon(Icons.chevron_right, color: AppTheme.textMuted),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SosAlertsScreen()),
                ).then((_) => _load()),
              ),
            ),
            Card(
              child: ListTile(
                leading: const GradientIconBadge(icon: Icons.percent, size: 44),
                title: Text(S.t('Comisión / Corte de caja')),
                subtitle: Text('${S.t('Regla actual')}: $feePct% — ${S.t('ver totales reales')}'),
                trailing: const Icon(Icons.chevron_right, color: AppTheme.textMuted),
                onTap: () => Navigator.pushNamed(context, '/corte-de-caja'),
              ),
            ),
            Card(
              child: ListTile(
                leading: const GradientIconBadge(icon: Icons.tune, size: 44),
                title: Text(S.t('Tarifas')),
                subtitle: Text(S.t('Base, por km, por minuto y mínimo')),
                trailing: const Icon(Icons.chevron_right, color: AppTheme.textMuted),
                onTap: () => Navigator.pushNamed(context, '/fare-config'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardTile extends StatelessWidget {
  const _DashboardTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.caption,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final String? caption;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.md),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpace.md),
        decoration: BoxDecoration(
          color: AppTheme.surfaceElevated,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppTheme.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            const Spacer(),
            Text(
              value,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: color),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textMuted), maxLines: 2),
            if (caption != null)
              Text(caption!, style: const TextStyle(fontSize: 10, color: AppTheme.textMuted)),
          ],
        ),
      ),
    );
  }
}
