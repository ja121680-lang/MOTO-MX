import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calificar viaje')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpace.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('¿Cómo estuvo el viaje?', style: Theme.of(context).textTheme.headlineMedium),
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
              decoration: const InputDecoration(labelText: 'Comentario opcional'),
            ),
            const Spacer(),
            FilledButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Calificación enviada: $score ★')),
                );
              },
              child: const Text('Enviar calificación'),
            ),
          ],
        ),
      ),
    );
  }
}
