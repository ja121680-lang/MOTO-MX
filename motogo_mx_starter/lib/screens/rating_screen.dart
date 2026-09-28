import 'package:flutter/material.dart';

import '../l10n/app_strings.dart';
import '../theme/app_theme.dart';
import 'main_shell_screen.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  int score = 5;
  final comment = TextEditingController();

  @override
  void dispose() {
    comment.dispose();
    super.dispose();
  }

  void _goToMyTrips() {
    MainShellScreen.requestedTab.value = 1; // Mis viajes
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _submit() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${S.t('Calificación enviada')}: $score ★')),
    );
    _goToMyTrips();
  }

  void _reportProblem() {
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
            Text(S.t('Reportar un problema'), style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpace.md),
            Text(
              S.t('Cuéntanos qué pasó en el campo de comentario y envía tu calificación — lo revisaremos.'),
              style: const TextStyle(color: AppTheme.textMuted, height: 1.4),
            ),
            const SizedBox(height: AppSpace.lg),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(S.t('Entendido')),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.t('Calificar viaje'))),
      body: Padding(
        padding: const EdgeInsets.all(AppSpace.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(S.t('¿Cómo estuvo el viaje?'), style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: AppSpace.lg),
            Wrap(
              alignment: WrapAlignment.center,
              children: List.generate(5, (index) {
                final value = index + 1;
                return IconButton(
                  onPressed: () => setState(() => score = value),
                  icon: Icon(
                    value <= score ? Icons.star : Icons.star_border,
                    color: value <= score ? AppTheme.primaryYellow : AppTheme.textMuted,
                    size: 38,
                  ),
                );
              }),
            ),
            const SizedBox(height: AppSpace.lg),
            TextField(
              controller: comment,
              maxLines: 3,
              decoration: InputDecoration(labelText: S.t('Comentario opcional')),
            ),
            const SizedBox(height: AppSpace.sm),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: _reportProblem,
                icon: const Icon(Icons.flag_outlined, size: 18),
                label: Text(S.t('Reportar un problema')),
              ),
            ),
            const Spacer(),
            FilledButton(
              onPressed: _submit,
              child: Text(S.t('Enviar calificación')),
            ),
          ],
        ),
      ),
    );
  }
}
