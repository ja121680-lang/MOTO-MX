import 'dart:convert';

import 'package:flutter/material.dart';

import '../l10n/app_strings.dart';
import '../models/driver_application.dart';
import '../models/driver_registration.dart';
import '../services/driver_approval_service.dart';
import '../theme/app_theme.dart';

/// Real approval queue (Paquete C): every application submitted from
/// [DriverRegistrationScreen] on this device, with per-document review,
/// a required reason on reject/correction, and a visible decision log —
/// not a single anonymous draft with a decision that vanishes when you
/// leave the screen.
class DriverApprovalScreen extends StatefulWidget {
  const DriverApprovalScreen({super.key});

  @override
  State<DriverApprovalScreen> createState() => _DriverApprovalScreenState();
}

class _DriverApprovalScreenState extends State<DriverApprovalScreen> {
  final _service = DriverApprovalService();
  bool _loading = true;
  List<DriverApplication> _applications = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final apps = await _service.all();
    if (!mounted) return;
    setState(() {
      _applications = apps;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: AppTheme.primaryYellow)));
    }
    return Scaffold(
      appBar: AppBar(title: Text(S.t('Aprobación de conductores'))),
      body: _applications.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  S.t('Todavía no hay solicitudes de conductor enviadas desde este dispositivo.'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppTheme.textMuted),
                ),
              ),
            )
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView.separated(
                padding: const EdgeInsets.all(AppSpace.lg),
                itemCount: _applications.length,
                separatorBuilder: (_, __) => const SizedBox(height: AppSpace.sm),
                itemBuilder: (context, index) {
                  final app = _applications[index];
                  return Card(
                    child: ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.person)),
                      title: Text(app.data.fullName.isEmpty ? S.t('Sin nombre') : app.data.fullName),
                      subtitle: Text('${app.data.make} ${app.data.model} · ${app.data.plate} · ${app.data.unionName}'),
                      trailing: StatusBadge(
                        label: S.t(app.status.label).toUpperCase(),
                        color: switch (app.status) {
                          DriverApplicationStatus.approved => AppTheme.success,
                          DriverApplicationStatus.rejected => AppTheme.error,
                          DriverApplicationStatus.needsCorrection => AppTheme.warning,
                          DriverApplicationStatus.pending => AppTheme.textMuted,
                        },
                      ),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => _ApplicationDetailScreen(application: app)),
                        );
                        _load();
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }
}

class _ApplicationDetailScreen extends StatefulWidget {
  const _ApplicationDetailScreen({required this.application});

  final DriverApplication application;

  @override
  State<_ApplicationDetailScreen> createState() => _ApplicationDetailScreenState();
}

class _ApplicationDetailScreenState extends State<_ApplicationDetailScreen> {
  final _service = DriverApprovalService();
  late Map<String, String> _docStatus;

  @override
  void initState() {
    super.initState();
    _docStatus = {for (final name in kDriverDocumentNames) name: 'Pendiente'};
  }

  bool get _allDocsApproved => _docStatus.values.every((s) => s == 'Aprobado');

  Future<String?> _askReason(String title) {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: InputDecoration(hintText: S.t('Motivo (obligatorio)')),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text(S.t('Cancelar'))),
          FilledButton(
            onPressed: controller.text.trim().isEmpty
                ? null
                : () => Navigator.pop(dialogContext, controller.text.trim()),
            child: Text(S.t('Confirmar')),
          ),
        ],
      ),
    );
  }

  Future<void> _decide(DriverApplicationStatus status) async {
    String? reason;
    if (status != DriverApplicationStatus.approved) {
      reason = await _askReason(
        status == DriverApplicationStatus.rejected
            ? S.t('Motivo del rechazo')
            : S.t('¿Qué debe corregir el conductor?'),
      );
      if (reason == null || reason.isEmpty) return; // cancelled — no decision without a reason
    }
    await _service.decide(widget.application.id, status, reason: reason);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.application.data;
    return Scaffold(
      appBar: AppBar(title: Text(S.t('Expediente de conductor'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(data.fullName.isEmpty ? S.t('Sin nombre') : data.fullName),
              subtitle: Text('${data.phone} · ${data.email}'),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.two_wheeler),
              title: Text('${data.make} ${data.model} · ${data.color}'),
              subtitle: Text('${S.t('Placa')}: ${data.plate}'),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.badge_outlined),
              title: Text('${S.t('Número económico')}: ${data.economicNumber}'),
              subtitle: Text('${S.t('Sindicato')}: ${data.unionName}'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(
                data.biometricVerified ? Icons.verified_user : Icons.fingerprint,
                color: data.biometricVerified ? AppTheme.success : AppTheme.textMuted,
              ),
              title: Text(data.biometricVerified ? S.t('Biometría verificada') : S.t('Biometría pendiente')),
            ),
          ),
          const SizedBox(height: 8),
          SectionHeader(S.t('Documentos')),
          const SizedBox(height: 8),
          ...kDriverDocumentNames.map((name) {
            final photo = data.documentPhotos[name];
            return Card(
              child: ListTile(
                leading: photo != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.memory(base64Decode(photo), width: 44, height: 44, fit: BoxFit.cover),
                      )
                    : const Icon(Icons.description_outlined, color: AppTheme.textMuted),
                title: Text(name),
                subtitle: Text(photo != null ? '${S.t('Estado')}: ${_docStatus[name]}' : S.t('Sin foto subida')),
                trailing: PopupMenuButton<String>(
                  enabled: photo != null,
                  onSelected: (v) => setState(() => _docStatus[name] = v),
                  itemBuilder: (_) => [
                    PopupMenuItem(value: 'Aprobado', child: Text(S.t('Aprobar'))),
                    PopupMenuItem(value: 'Rechazado', child: Text(S.t('Rechazar'))),
                    PopupMenuItem(value: 'Pendiente', child: Text(S.t('Pendiente'))),
                  ],
                ),
              ),
            );
          }),
          if (widget.application.decisions.isNotEmpty) ...[
            const SizedBox(height: 8),
            SectionHeader(S.t('Bitácora de decisiones')),
            const SizedBox(height: 8),
            ...widget.application.decisions.reversed.map((d) => Card(
                  child: ListTile(
                    leading: Icon(
                      d.status == DriverApplicationStatus.approved ? Icons.check_circle : Icons.info_outline,
                      color: d.status == DriverApplicationStatus.approved ? AppTheme.success : AppTheme.warning,
                    ),
                    title: Text(S.t(d.status.label)),
                    subtitle: Text(
                      [
                        '${d.decidedAt.day.toString().padLeft(2, '0')}/${d.decidedAt.month.toString().padLeft(2, '0')}/${d.decidedAt.year}',
                        if (d.reason != null && d.reason!.isNotEmpty) d.reason!,
                      ].join(' · '),
                    ),
                  ),
                )),
          ],
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _allDocsApproved ? () => _decide(DriverApplicationStatus.approved) : null,
            icon: const Icon(Icons.verified),
            label: Text(S.t('Aprobar conductor')),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => _decide(DriverApplicationStatus.needsCorrection),
            icon: const Icon(Icons.edit_note),
            label: Text(S.t('Requiere corrección')),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(side: const BorderSide(color: AppTheme.error)),
            onPressed: () => _decide(DriverApplicationStatus.rejected),
            icon: const Icon(Icons.block, color: AppTheme.error),
            label: Text(S.t('Rechazar conductor'), style: const TextStyle(color: AppTheme.error)),
          ),
        ],
      ),
    );
  }
}
