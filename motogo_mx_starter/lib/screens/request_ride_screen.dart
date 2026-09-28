import 'package:flutter/material.dart';

import '../l10n/app_strings.dart';
import '../theme/app_theme.dart';
import 'fare_preview_screen.dart';

enum _TripType { onePerson, lightCargo }

class RequestRideScreen extends StatefulWidget {
  const RequestRideScreen({super.key});

  @override
  State<RequestRideScreen> createState() => _RequestRideScreenState();
}

class _RequestRideScreenState extends State<RequestRideScreen> {
  final destination = TextEditingController();
  final note = TextEditingController();
  _TripType tripType = _TripType.onePerson;
  String? paymentMethod;

  bool get canContinue => destination.text.trim().isNotEmpty && paymentMethod != null;

  @override
  void dispose() {
    destination.dispose();
    note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.t('Solicitar viaje'))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpace.xl, AppSpace.xl, AppSpace.xl, 120),
        children: [
          SectionHeader(S.t('Recogida')),
          const SizedBox(height: AppSpace.sm),
          Card(
            child: ListTile(
              leading: const Icon(Icons.my_location, color: AppTheme.success),
              title: Text(S.t('Mi ubicación actual')),
              subtitle: Text(
                S.t('Usaremos tu ubicación al activar permisos'),
                style: const TextStyle(fontSize: 12),
              ),
              trailing: TextButton(
                onPressed: () {},
                child: Text(S.t('Cambiar')),
              ),
            ),
          ),
          const SizedBox(height: AppSpace.xl),
          SectionHeader(S.t('Destino')),
          const SizedBox(height: AppSpace.sm),
          TextField(
            controller: destination,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              labelText: S.t('¿A dónde vas?'),
              prefixIcon: const Icon(Icons.location_on),
            ),
          ),
          const SizedBox(height: AppSpace.xl),
          SectionHeader(S.t('Nota para el conductor (opcional)')),
          const SizedBox(height: AppSpace.sm),
          TextField(
            controller: note,
            maxLength: 120,
            maxLines: 2,
            decoration: InputDecoration(hintText: S.t('Ej. Portón azul, timbre 2')),
          ),
          SectionHeader(S.t('Tipo de viaje')),
          const SizedBox(height: AppSpace.sm),
          Row(
            children: [
              Expanded(
                child: _SelectableCard(
                  icon: Icons.person_outline,
                  label: S.t('Una persona'),
                  selected: tripType == _TripType.onePerson,
                  onTap: () => setState(() => tripType = _TripType.onePerson),
                ),
              ),
              const SizedBox(width: AppSpace.md),
              Expanded(
                child: _SelectableCard(
                  icon: Icons.inventory_2_outlined,
                  label: S.t('Con carga ligera'),
                  selected: tripType == _TripType.lightCargo,
                  onTap: () => setState(() => tripType = _TripType.lightCargo),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpace.xl),
          SectionHeader(S.t('Método de pago')),
          const SizedBox(height: AppSpace.sm),
          Row(
            children: [
              Expanded(
                child: _SelectableCard(
                  icon: Icons.payments_outlined,
                  label: S.t('Efectivo'),
                  selected: paymentMethod == 'Efectivo',
                  onTap: () => setState(() => paymentMethod = 'Efectivo'),
                ),
              ),
              const SizedBox(width: AppSpace.sm),
              Expanded(
                child: _SelectableCard(
                  icon: Icons.credit_card,
                  label: S.t('Tarjeta'),
                  selected: paymentMethod == 'Tarjeta',
                  onTap: () => setState(() => paymentMethod = 'Tarjeta'),
                ),
              ),
              const SizedBox(width: AppSpace.sm),
              Expanded(
                child: _SelectableCard(
                  icon: Icons.qr_code,
                  label: S.t('QR'),
                  selected: paymentMethod == 'QR',
                  onTap: () => setState(() => paymentMethod = 'QR'),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpace.xl),
          Container(
            padding: const EdgeInsets.all(AppSpace.lg),
            decoration: BoxDecoration(
              color: AppTheme.surfaceElevated,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: AppTheme.primaryYellow.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const GradientIconBadge(icon: Icons.payments_outlined, size: 40),
                const SizedBox(width: AppSpace.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(S.t('Estimado'), style: const TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.divider,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              S.t('Datos simulados'),
                              style: const TextStyle(fontSize: 10, color: AppTheme.textMuted),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        S.t('El total se confirma antes de pedir'),
                        style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpace.lg),
          child: FilledButton(
            onPressed: canContinue
                ? () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FarePreviewScreen(
                          destination: destination.text.trim(),
                          note: note.text.trim(),
                          tripTypeLabel: tripType == _TripType.onePerson
                              ? S.t('Una persona')
                              : S.t('Con carga ligera'),
                          paymentMethod: paymentMethod!,
                        ),
                      ),
                    )
                : null,
            child: Text(S.t('Ver cotización')),
          ),
        ),
      ),
    );
  }
}

class _SelectableCard extends StatelessWidget {
  const _SelectableCard({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.md),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpace.md, horizontal: AppSpace.sm),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primaryYellow.withOpacity(0.12) : AppTheme.surfaceMuted,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: selected ? AppTheme.primaryYellow : AppTheme.divider),
        ),
        child: Column(
          children: [
            Icon(icon, color: selected ? AppTheme.primaryYellow : AppTheme.textMuted, size: 22),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: selected ? AppTheme.textLight : AppTheme.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
