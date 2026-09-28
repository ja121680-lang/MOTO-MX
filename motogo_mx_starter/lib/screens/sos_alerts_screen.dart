import 'package:flutter/material.dart';

import '../l10n/app_strings.dart';
import '../models/sos_event.dart';
import '../services/sos_event_service.dart';
import '../theme/app_theme.dart';

/// Admin "Seguridad" module (Paquete C): every SOS activation logged
/// locally by the passenger or driver app, with hora/rol/estado — real
/// records of a real button press, not a live monitoring feed. Live
/// location/maps/an actual response protocol are external pendientes,
/// stated as such rather than faked.
class SosAlertsScreen extends StatefulWidget {
  const SosAlertsScreen({super.key});

  @override
  State<SosAlertsScreen> createState() => _SosAlertsScreenState();
}

class _SosAlertsScreenState extends State<SosAlertsScreen> {
  final _service = SosEventService();
  bool _loading = true;
  List<SosEvent> _events = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final events = await _service.all();
    if (!mounted) return;
    setState(() {
      _events = events;
      _loading = false;
    });
  }

  Future<void> _markAttended(String id) async {
    await _service.markAttended(id);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: AppTheme.primaryYellow)));
    }
    final active = _events.where((e) => !e.attended).toList();
    final attended = _events.where((e) => e.attended).toList();

    return Scaffold(
      appBar: AppBar(title: Text(S.t('Seguridad · Alertas SOS'))),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.all(AppSpace.lg),
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpace.md, vertical: AppSpace.sm),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, size: 14, color: AppTheme.textMuted),
                  const SizedBox(width: AppSpace.sm),
                  Expanded(
                    child: Text(
                      S.t(
                        'Registro local de cada SOS activado. No es monitoreo en vivo hasta tener mapas, permisos y protocolo operativo conectados.',
                      ),
                      style: const TextStyle(color: AppTheme.textMuted, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpace.xl),
            SectionHeader('${S.t('Activas')} (${active.length})'),
            const SizedBox(height: AppSpace.sm),
            if (active.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpace.lg),
                child: Text(S.t('Sin alertas activas.'), style: const TextStyle(color: AppTheme.textMuted)),
              )
            else
              ...active.map((e) => _SosCard(event: e, onMarkAttended: () => _markAttended(e.id))),
            if (attended.isNotEmpty) ...[
              const SizedBox(height: AppSpace.xxl),
              SectionHeader('${S.t('Atendidas')} (${attended.length})'),
              const SizedBox(height: AppSpace.sm),
              ...attended.map((e) => _SosCard(event: e, onMarkAttended: null)),
            ],
          ],
        ),
      ),
    );
  }
}

class _SosCard extends StatelessWidget {
  const _SosCard({required this.event, required this.onMarkAttended});

  final SosEvent event;
  final VoidCallback? onMarkAttended;

  @override
  Widget build(BuildContext context) {
    final roleLabel = event.role == SosRole.passenger ? S.t('Pasajero') : S.t('Conductor');
    return Card(
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: (event.attended ? AppTheme.success : AppTheme.error).withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.sos, color: event.attended ? AppTheme.success : AppTheme.error, size: 18),
        ),
        title: Text('$roleLabel · ${_formatDateTime(event.triggeredAt)}'),
        subtitle: Text(S.t('Última ubicación demo — sin proveedor de mapas conectado')),
        trailing: onMarkAttended == null
            ? StatusBadge(label: S.t('Atendida').toUpperCase(), color: AppTheme.success)
            : OutlinedButton(
                onPressed: onMarkAttended,
                child: Text(S.t('Marcar atendida'), style: const TextStyle(fontSize: 12)),
              ),
      ),
    );
  }

  String _formatDateTime(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')} '
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
}
