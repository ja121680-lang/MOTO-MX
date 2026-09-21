import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/driver_registration.dart';
import '../services/driver_registration_store.dart';

class DriverApprovalScreen extends StatefulWidget {
  const DriverApprovalScreen({super.key});

  @override
  State<DriverApprovalScreen> createState() => _DriverApprovalScreenState();
}

class _DriverApprovalScreenState extends State<DriverApprovalScreen> {
  final _store = DriverRegistrationStore();
  DriverRegistrationData? _registration;
  bool _loading = true;
  String status = 'Pendiente';

  late Map<String, String> _docStatus;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await _store.load();
    _docStatus = {for (final name in kDriverDocumentNames) name: 'Pendiente'};
    if (mounted) {
      setState(() {
        _registration = data;
        _loading = false;
      });
    }
  }

  bool get allApproved => _docStatus.values.every((s) => s == 'Aprobado');

  void updateDoc(String name, String newStatus) {
    setState(() => _docStatus[name] = newStatus);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final data = _registration;
    return Scaffold(
      appBar: AppBar(title: const Text('Revisión de conductor')),
      body: data == null
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Todavía no hay un registro de conductor guardado en este dispositivo.',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: Text(data.fullName.isEmpty ? 'Sin nombre' : data.fullName),
                    subtitle: Text('${data.make} ${data.model} · placa ${data.plate} · ${data.unionName}'),
                  ),
                ),
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
                          : const Icon(Icons.description_outlined, color: Colors.grey),
                      title: Text(name),
                      subtitle: Text(photo != null ? 'Estado: ${_docStatus[name]}' : 'Sin foto subida'),
                      trailing: PopupMenuButton<String>(
                        enabled: photo != null,
                        onSelected: (v) => updateDoc(name, v),
                        itemBuilder: (_) => const [
                          PopupMenuItem(value: 'Aprobado', child: Text('Aprobar')),
                          PopupMenuItem(value: 'Rechazado', child: Text('Rechazar')),
                          PopupMenuItem(value: 'Pendiente', child: Text('Pendiente')),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: allApproved
                      ? () => setState(() => status = 'Aprobado')
                      : null,
                  icon: const Icon(Icons.verified),
                  label: const Text('Aprobar conductor'),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () => setState(() => status = 'Rechazado'),
                  icon: const Icon(Icons.block),
                  label: const Text('Rechazar conductor'),
                ),
                const SizedBox(height: 12),
                Text(
                  'Estado final: $status',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
    );
  }
}
