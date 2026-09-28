import 'package:flutter/material.dart';

import '../l10n/app_strings.dart';
import '../services/fare_service.dart';
import '../theme/app_theme.dart';
import 'ride_matching_screen.dart';

/// "Revisa tu viaje" (Paquete 01). Shows exactly what the passenger is
/// about to pay before they confirm — no platform-commission line here,
/// that split is internal to the driver/admin side, not a passenger
/// line-item (see [PaymentScreen] for the same rule on the receipt).
class FarePreviewScreen extends StatelessWidget {
  const FarePreviewScreen({
    super.key,
    this.destination = '',
    this.note = '',
    this.tripTypeLabel = '',
    this.paymentMethod = 'Efectivo',
    this.distanceKm = 4.2,
    this.etaMinutes = 11,
  });

  final String destination;
  final String note;
  final String tripTypeLabel;
  final String paymentMethod;
  final double distanceKm;
  final int etaMinutes;

  @override
  Widget build(BuildContext context) {
    const service = FareService();
    final quote = service.quote(distanceKm: distanceKm, etaMinutes: etaMinutes);

    return Scaffold(
      appBar: AppBar(title: Text(S.t('Revisa tu viaje'))),
      body: ListView(
        padding: const EdgeInsets.all(AppSpace.xl),
        children: [
          // Elegant route placeholder — deliberately not pretending to be a
          // real map until a maps provider is integrated.
          Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.surfaceElevated, AppTheme.surface],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppTheme.divider),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.alt_route, size: 34, color: AppTheme.goldLight),
                  const SizedBox(height: 6),
                  Text(S.t('Vista previa de tu ruta'),
                      style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpace.xl),
          Card(
            child: Column(
              children: [
                if (destination.isNotEmpty)
                  ListTile(
                    leading: const Icon(Icons.location_on_outlined, color: AppTheme.primaryYellow),
                    title: Text(destination),
                    subtitle: Text(S.t('Destino')),
                  ),
                if (tripTypeLabel.isNotEmpty || note.isNotEmpty) const Divider(height: 1),
                if (tripTypeLabel.isNotEmpty)
                  ListTile(
                    dense: true,
                    leading: const Icon(Icons.two_wheeler, color: AppTheme.textMuted),
                    title: Text(tripTypeLabel, style: const TextStyle(fontSize: 13)),
                  ),
                if (note.isNotEmpty)
                  ListTile(
                    dense: true,
                    leading: const Icon(Icons.sticky_note_2_outlined, color: AppTheme.textMuted),
                    title: Text(note, style: const TextStyle(fontSize: 13)),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpace.lg),
          Card(
            child: ListTile(
              leading: const GradientIconBadge(icon: Icons.route, size: 44),
              title: Text('${quote.distanceKm.toStringAsFixed(1)} km',
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text('${S.t('Tiempo estimado')}: ${quote.etaMinutes} min'),
            ),
          ),
          Card(
            child: ExpansionTile(
              title: Text(
                S.t('Total estimado'),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Text(
                '\$${quote.totalFare.toStringAsFixed(2)} MXN',
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryYellow),
              ),
              childrenPadding: const EdgeInsets.only(bottom: AppSpace.sm),
              children: [
                ListTile(
                  dense: true,
                  title: Text(S.t('Tarifa base')),
                  trailing: Text('\$${quote.baseFare.toStringAsFixed(2)}'),
                ),
                ListTile(
                  dense: true,
                  title: Text(S.t('Distancia')),
                  trailing: Text('\$${quote.distanceFare.toStringAsFixed(2)}'),
                ),
                ListTile(
                  dense: true,
                  title: Text(S.t('Tiempo')),
                  trailing: Text('\$${quote.timeFare.toStringAsFixed(2)}'),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpace.lg),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpace.md, vertical: AppSpace.sm),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Row(
              children: [
                const Icon(Icons.shield_outlined, size: 16, color: AppTheme.goldLight),
                const SizedBox(width: AppSpace.sm),
                Expanded(
                  child: Text(
                    S.t('Solo inicia cuando confirmes el PIN con tu conductor.'),
                    style: const TextStyle(color: AppTheme.textMuted, fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpace.xxl),
          FilledButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RideMatchingScreen()),
            ),
            child: Text(S.t('Confirmar y buscar conductor')),
          ),
          const SizedBox(height: AppSpace.sm),
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(S.t('Modificar viaje')),
          ),
        ],
      ),
    );
  }
}
