import 'package:flutter/material.dart';
import '../services/diamond_service.dart';
import '../theme/app_theme.dart';

class DiamondScreen extends StatelessWidget {
  const DiamondScreen({super.key});

  static const _diamondBlue = Color(0xFF60D6F0);

  @override
  Widget build(BuildContext context) {
    const service = DiamondService();
    const trips = 134;
    const rating = 4.91;
    const cancellation = 0.05;
    final qualified = service.qualifies(
      completedTrips: trips,
      rating: rating,
      cancellationRate: cancellation,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Diamond')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [_diamondBlue, Color(0xFF2E7D9E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Icon(Icons.workspace_premium, size: 56, color: Colors.white),
                const SizedBox(height: 12),
                Text(
                  qualified ? '¡Eres Diamond!' : 'Camino a Diamond',
                  style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  qualified
                      ? 'Disfruta beneficios exclusivos por tu excelente servicio.'
                      : 'Sigue así para desbloquear beneficios exclusivos.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Tu progreso', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          _ProgressCriterion(
            icon: Icons.route,
            label: 'Viajes completados',
            value: '$trips / 100',
            progress: (trips / 100).clamp(0.0, 1.0),
            met: trips >= 100,
          ),
          const SizedBox(height: 10),
          _ProgressCriterion(
            icon: Icons.star,
            label: 'Calificación',
            value: '$rating / 4.8 mín.',
            progress: (rating / 5).clamp(0.0, 1.0),
            met: rating >= 4.8,
          ),
          const SizedBox(height: 10),
          _ProgressCriterion(
            icon: Icons.cancel_outlined,
            label: 'Cancelaciones',
            value: '${(cancellation * 100).toStringAsFixed(1)}% / 8% máx.',
            progress: (1 - cancellation / 0.08).clamp(0.0, 1.0),
            met: cancellation <= 0.08,
          ),
          const SizedBox(height: 24),
          const Text('Beneficios Diamond', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          const _BenefitTile(icon: Icons.bolt, label: 'Prioridad en asignación de viajes'),
          const _BenefitTile(icon: Icons.percent, label: 'Comisión preferencial'),
          const _BenefitTile(icon: Icons.support_agent, label: 'Soporte prioritario'),
        ],
      ),
    );
  }
}

class _ProgressCriterion extends StatelessWidget {
  const _ProgressCriterion({
    required this.icon,
    required this.label,
    required this.value,
    required this.progress,
    required this.met,
  });

  final IconData icon;
  final String label;
  final String value;
  final double progress;
  final bool met;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: met ? AppTheme.success : AppTheme.textMuted),
              const SizedBox(width: 8),
              Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600))),
              Text(value, style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
              if (met) ...[
                const SizedBox(width: 6),
                const Icon(Icons.check_circle, color: AppTheme.success, size: 16),
              ],
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: AppTheme.divider,
              valueColor: AlwaysStoppedAnimation(met ? AppTheme.success : AppTheme.primaryYellow),
            ),
          ),
        ],
      ),
    );
  }
}

class _BenefitTile extends StatelessWidget {
  const _BenefitTile({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: DiamondScreen._diamondBlue),
        title: Text(label),
      ),
    );
  }
}
