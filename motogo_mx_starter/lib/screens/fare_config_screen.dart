import 'package:flutter/material.dart';

import '../l10n/app_strings.dart';
import '../services/fare_config_store.dart';
import '../services/fare_service.dart';
import '../theme/app_theme.dart';

/// Admin-editable tariff rates (Paquete C): base fare, per-km, per-minute
/// and minimum fare, persisted via [FareConfigStore] so [FareService]
/// picks them up on the next quote. Single default zone for now — real
/// per-zone tariffs need a zones model (listed as a pendiente). Changes
/// never save without an explicit confirmation step.
class FareConfigScreen extends StatefulWidget {
  const FareConfigScreen({super.key});

  @override
  State<FareConfigScreen> createState() => _FareConfigScreenState();
}

class _FareConfigScreenState extends State<FareConfigScreen> {
  final _store = FareConfigStore();
  final _baseFareController = TextEditingController();
  final _perKmController = TextEditingController();
  final _perMinuteController = TextEditingController();
  final _minimumFareController = TextEditingController();
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final config = await _store.load();
    _baseFareController.text = config.baseFare.toStringAsFixed(2);
    _perKmController.text = config.perKm.toStringAsFixed(2);
    _perMinuteController.text = config.perMinute.toStringAsFixed(2);
    _minimumFareController.text = config.minimumFare.toStringAsFixed(2);
    if (mounted) setState(() => _loading = false);
  }

  @override
  void dispose() {
    _baseFareController.dispose();
    _perKmController.dispose();
    _perMinuteController.dispose();
    _minimumFareController.dispose();
    super.dispose();
  }

  Future<void> _confirmAndSave() async {
    final config = FareConfig(
      baseFare: double.tryParse(_baseFareController.text) ?? 0,
      perKm: double.tryParse(_perKmController.text) ?? 0,
      perMinute: double.tryParse(_perMinuteController.text) ?? 0,
      minimumFare: double.tryParse(_minimumFareController.text) ?? 0,
    );
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(S.t('¿Guardar nuevas tarifas?')),
        content: Text(
          S.t('Esto cambia el cálculo de cotización para todos los viajes nuevos a partir de ahora.'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: Text(S.t('Cancelar'))),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(S.t('Guardar')),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    setState(() => _saving = true);
    await _store.save(config);
    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(S.t('Tarifas actualizadas.'))),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: AppTheme.primaryYellow)));
    }
    return Scaffold(
      appBar: AppBar(title: Text(S.t('Tarifas'))),
      body: ListView(
        padding: const EdgeInsets.all(AppSpace.xl),
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
                    S.t('Zona única por ahora — tarifas por zona requieren definir el mapa de zonas.'),
                    style: const TextStyle(color: AppTheme.textMuted, fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpace.xl),
          _RateField(controller: _baseFareController, label: S.t('Tarifa base (MXN)')),
          const SizedBox(height: AppSpace.lg),
          _RateField(controller: _perKmController, label: S.t('Por kilómetro (MXN)')),
          const SizedBox(height: AppSpace.lg),
          _RateField(controller: _perMinuteController, label: S.t('Por minuto (MXN)')),
          const SizedBox(height: AppSpace.lg),
          _RateField(controller: _minimumFareController, label: S.t('Tarifa mínima (MXN)')),
          const SizedBox(height: AppSpace.xxl),
          FilledButton(
            onPressed: _saving ? null : _confirmAndSave,
            child: _saving
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : Text(S.t('Guardar cambios')),
          ),
        ],
      ),
    );
  }
}

class _RateField extends StatelessWidget {
  const _RateField({required this.controller, required this.label});

  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: label),
    );
  }
}
