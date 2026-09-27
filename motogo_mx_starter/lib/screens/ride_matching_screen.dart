import 'package:flutter/material.dart';
import '../theme/ga_theme.dart';

enum MatchingState {
  searching,
  accepted,
  arriving,
  pin,
  inProgress,
  completed,
}

class RideMatchingScreen extends StatefulWidget {
  const RideMatchingScreen({super.key});

  @override
  State<RideMatchingScreen> createState() => _RideMatchingScreenState();
}

class _RideMatchingScreenState extends State<RideMatchingScreen> {
  MatchingState state = MatchingState.searching;
  final pinController = TextEditingController();
  String? pinError;

  @override
  void dispose() {
    pinController.dispose();
    super.dispose();
  }

  String get title {
    switch (state) {
      case MatchingState.searching:
        return 'Buscando conductor';
      case MatchingState.accepted:
        return 'Conductor asignado';
      case MatchingState.arriving:
        return 'Conductor en camino';
      case MatchingState.pin:
        return 'Validar PIN';
      case MatchingState.inProgress:
        return 'Viaje en curso';
      case MatchingState.completed:
        return 'Viaje completado';
    }
  }

  String get subtitle {
    switch (state) {
      case MatchingState.searching:
        return 'Buscando una moto disponible cerca de ti.';
      case MatchingState.accepted:
        return 'Encontramos un conductor para tu viaje.';
      case MatchingState.arriving:
        return 'Verifica conductor, moto y placa antes de subir.';
      case MatchingState.pin:
        return 'Comparte el PIN solo cuando estés frente al conductor correcto.';
      case MatchingState.inProgress:
        return 'Tu viaje está activo. Puedes abrir el seguimiento.';
      case MatchingState.completed:
        return 'Llegaste. Revisa el pago antes de confirmar.';
    }
  }

  void next() {
    setState(() {
      pinError = null;
      switch (state) {
        case MatchingState.searching:
          state = MatchingState.accepted;
          break;
        case MatchingState.accepted:
          state = MatchingState.arriving;
          break;
        case MatchingState.arriving:
          state = MatchingState.pin;
          break;
        case MatchingState.pin:
          if (pinController.text == '1234') {
            state = MatchingState.inProgress;
          } else {
            pinError = 'PIN incorrecto. En esta versión de prueba usa 1234.';
          }
          break;
        case MatchingState.inProgress:
          state = MatchingState.completed;
          break;
        case MatchingState.completed:
          break;
      }
    });
  }

  Widget _mapPlaceholder() {
    return Container(
      height: 280,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF17130A), Color(0xFF080808)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: GAColors.goldDark),
      ),
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _MatchingGridPainter())),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (state == MatchingState.searching) ...[
                  const SizedBox(
                    width: 58,
                    height: 58,
                    child: CircularProgressIndicator(
                      color: GAColors.goldLight,
                      strokeWidth: 5,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'BUSCANDO CERCA DE TI',
                    style: TextStyle(
                      color: GAColors.goldLight,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.1,
                    ),
                  ),
                ] else ...[
                  Container(
                    width: 78,
                    height: 78,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF211A08),
                      border: Border.all(color: GAColors.gold, width: 2),
                    ),
                    child: const Icon(
                      Icons.two_wheeler_rounded,
                      color: GAColors.goldLight,
                      size: 42,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    state == MatchingState.completed
                        ? 'VIAJE COMPLETADO'
                        : 'CONDUCTOR DEMO',
                    style: const TextStyle(
                      color: GAColors.goldLight,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.1,
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                const Text(
                  'Mapa real pendiente de integración',
                  style: TextStyle(color: GAColors.muted, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _driverCard() {
    return Container(
      margin: const EdgeInsets.only(top: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GAColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: GAColors.line),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Color(0xFF211A08),
            child: Icon(Icons.person_rounded, color: GAColors.goldLight, size: 31),
          ),
          SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Conductor demo · 4.9 ★',
                  style: TextStyle(
                    color: GAColors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Moto demo · Placa ABC-123',
                  style: TextStyle(color: GAColors.muted, fontSize: 14),
                ),
                SizedBox(height: 3),
                Text(
                  'Verifica estos datos antes de subir',
                  style: TextStyle(
                    color: GAColors.goldLight,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 110),
          children: [
            Text(
              title,
              style: const TextStyle(
                color: GAColors.white,
                fontSize: 28,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              subtitle,
              style: const TextStyle(
                color: GAColors.muted,
                fontSize: 16,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 18),
            _mapPlaceholder(),
            if (state != MatchingState.searching) _driverCard(),
            if (state == MatchingState.pin) ...[
              const SizedBox(height: 16),
              TextField(
                controller: pinController,
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 4,
                onChanged: (_) {
                  if (pinError != null) setState(() => pinError = null);
                },
                decoration: const InputDecoration(
                  labelText: 'PIN de viaje',
                  hintText: 'Demo: 1234',
                  prefixIcon: Icon(
                    Icons.pin_rounded,
                    color: GAColors.goldLight,
                  ),
                ),
              ),
              if (pinError != null)
                Semantics(
                  liveRegion: true,
                  child: Text(
                    pinError!,
                    style: const TextStyle(
                      color: GAColors.danger,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
            if (state == MatchingState.inProgress) ...[
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/tracking'),
                icon: const Icon(Icons.gps_fixed_rounded),
                label: const Text('ABRIR SEGUIMIENTO'),
              ),
            ],
            const SizedBox(height: 18),
            FilledButton(
              onPressed: state == MatchingState.completed
                  ? () => Navigator.pushNamed(context, '/payment')
                  : next,
              child: Text(
                switch (state) {
                  MatchingState.searching =>
                    'CONTINUAR DEMO — CONDUCTOR DISPONIBLE',
                  MatchingState.accepted => 'CONDUCTOR INICIA TRASLADO',
                  MatchingState.arriving => 'CONDUCTOR LLEGÓ',
                  MatchingState.pin => 'VALIDAR PIN',
                  MatchingState.inProgress => 'FINALIZAR VIAJE DEMO',
                  MatchingState.completed => 'IR A PAGO',
                },
              ),
            ),
            if (state == MatchingState.searching) ...[
              const SizedBox(height: 10),
              const Text(
                'Esta etapa todavía simula el matching. El botón permite validar el flujo visual sin presentarlo como asignación real.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: GAColors.muted,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MatchingGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = const Color(0x224A3B12)
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 32) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (double y = 0; y < size.height; y += 32) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
    final route = Paint()
      ..color = GAColors.gold
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    final path = Path()
      ..moveTo(size.width * .10, size.height * .76)
      ..cubicTo(
        size.width * .26,
        size.height * .48,
        size.width * .56,
        size.height * .88,
        size.width * .88,
        size.height * .24,
      );
    canvas.drawPath(path, route);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
