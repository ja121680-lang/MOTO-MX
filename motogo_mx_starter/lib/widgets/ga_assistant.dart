import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../theme/ga_theme.dart';

class GAAssistantOverlay extends StatefulWidget {
  final Widget child;
  final GlobalKey<NavigatorState> navigatorKey;

  const GAAssistantOverlay({
    super.key,
    required this.child,
    required this.navigatorKey,
  });

  @override
  State<GAAssistantOverlay> createState() => _GAAssistantOverlayState();
}

class _GAAssistantOverlayState extends State<GAAssistantOverlay> {
  final _controller = TextEditingController();
  final _speech = stt.SpeechToText();
  final _tts = FlutterTts();
  bool _open = false;
  bool _listening = false;
  String _reply =
      'Hola. Dime qué necesitas: pedir un viaje, revisar tu wallet, ver viajes, encontrar conductores o entrar al modo conductor.';

  @override
  void initState() {
    super.initState();
    _tts.setLanguage('es-MX');
    _tts.setSpeechRate(.48);
  }

  @override
  void dispose() {
    _controller.dispose();
    _speech.stop();
    _tts.stop();
    super.dispose();
  }

  String _normalize(String value) {
    return value
        .toLowerCase()
        .replaceAll(RegExp(r'[áàäâ]'), 'a')
        .replaceAll(RegExp(r'[éèëê]'), 'e')
        .replaceAll(RegExp(r'[íìïî]'), 'i')
        .replaceAll(RegExp(r'[óòöô]'), 'o')
        .replaceAll(RegExp(r'[úùüû]'), 'u')
        .replaceAll('ñ', 'n')
        .trim();
  }

  Future<void> _say(String text) async {
    if (!mounted) return;
    setState(() => _reply = text);
    await _tts.stop();
    await _tts.speak(text);
  }

  void _go(String route, String message) {
    final nav = widget.navigatorKey.currentState;
    if (nav == null) {
      _say(
          'No pude abrir esa sección todavía. Intenta de nuevo en un momento.');
      return;
    }
    nav.pushNamed(route);
    _say(message);
  }

  Future<void> _handle(String raw) async {
    final t = _normalize(raw);
    if (t.isEmpty) return;

    if (RegExp(r'^(hola|buenos dias|buenas tardes|buenas noches|hello|ola)')
        .hasMatch(t)) {
      await _say(
          'Hola. ¿En qué te puedo ayudar? Puedes hablarme con tus propias palabras.');
      return;
    }
    if (t.contains('pedir') ||
        t.contains('solicitar') ||
        t.contains('quiero viajar') ||
        t.contains('a donde voy')) {
      _go('/request',
          'Claro. Te llevo a solicitar un viaje. Revisa origen, destino y tarifa antes de confirmar.');
      return;
    }
    if (t.contains('conductores cerca') ||
        t.contains('motos cerca') ||
        t.contains('conductor cercano')) {
      _go('/nearby-drivers', 'Abriendo conductores cercanos.');
      return;
    }
    if (t.contains('wallet') ||
        t.contains('saldo') ||
        t.contains('dinero') ||
        t.contains('billetera')) {
      _go('/wallet', 'Abriendo tu wallet.');
      return;
    }
    if (t.contains('retiro') || t.contains('retirar')) {
      _go('/wallet',
          'Te llevo a tu wallet. Retirar dinero es una acción sensible: revisa el monto y confirma tú mismo antes de continuar.');
      return;
    }
    if (t.contains('historial') ||
        t.contains('viajes anteriores') ||
        t.contains('mis viajes')) {
      _go('/history', 'Abriendo tu historial de viajes.');
      return;
    }
    if (t.contains('conductor') ||
        t.contains('manejar') ||
        t.contains('trabajar')) {
      _go('/driver',
          'Abriendo el modo conductor. Revisa tu estado antes de conectarte.');
      return;
    }
    if (t.contains('diamante') ||
        t.contains('recompensa') ||
        t.contains('puntos')) {
      _go('/diamond', 'Abriendo tus recompensas y diamantes.');
      return;
    }
    if (t.contains('pago') || t.contains('pagar')) {
      _go('/payment',
          'Abriendo métodos de pago. Revisa el método y el importe antes de confirmar.');
      return;
    }
    if (t.contains('seguimiento') ||
        t.contains('donde viene') ||
        t.contains('tracking')) {
      _go('/tracking', 'Abriendo el seguimiento del viaje.');
      return;
    }
    if (t.contains('ayuda') ||
        t.contains('no encuentro') ||
        t.contains('que puedo hacer')) {
      await _say(
          'Puedo llevarte a solicitar un viaje, conductores cercanos, wallet, historial, modo conductor, recompensas, pagos o seguimiento. Dime qué necesitas.');
      return;
    }
    if (t.contains('cancelar') ||
        t.contains('eliminar') ||
        t.contains('borrar') ||
        t.contains('transferir')) {
      await _say(
          'Esa puede ser una acción sensible. Puedo llevarte a la sección correcta, pero la confirmación final debe hacerla tú en pantalla.');
      return;
    }
    await _say(
        'No quiero adivinar una acción importante. Prueba diciendo: quiero pedir una moto, abre mi wallet, enséñame mis viajes o quiero modo conductor.');
  }

  Future<void> _toggleListening() async {
    if (_listening) {
      await _speech.stop();
      if (mounted) setState(() => _listening = false);
      return;
    }
    final available = await _speech.initialize(
      onStatus: (status) {
        if ((status == 'done' || status == 'notListening') && mounted) {
          setState(() => _listening = false);
        }
      },
      onError: (_) {
        if (mounted) {
          setState(() {
            _listening = false;
            _reply =
                'No pude activar la voz. Revisa el permiso del micrófono o escribe tu mensaje.';
          });
        }
      },
    );
    if (!available) {
      await _say(
          'La voz no está disponible en este dispositivo. Puedes escribir tu mensaje.');
      return;
    }
    if (mounted) setState(() => _listening = true);
    await _speech.listen(
      listenOptions: stt.SpeechListenOptions(
        localeId: 'es_MX',
        listenMode: stt.ListenMode.confirmation,
        cancelOnError: true,
        partialResults: false,
      ),
      onResult: (result) {
        if (!result.finalResult) return;
        _controller.text = result.recognizedWords;
        _handle(result.recognizedWords);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_open)
          Positioned(
            right: 16,
            left: 16,
            bottom: 92,
            child: SafeArea(
              top: false,
              child: Material(
                color: Colors.transparent,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 430),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [GAColors.surface2, GAColors.black],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: GAColors.gold),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black54,
                            blurRadius: 28,
                            offset: Offset(0, 16))
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 46,
                              height: 46,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF211A08),
                                border: Border.all(
                                    color: GAColors.goldLight, width: 2),
                              ),
                              alignment: Alignment.center,
                              child: const Text('GA',
                                  style: TextStyle(
                                      color: GAColors.goldLight,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w900)),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Asistente MotoGo',
                                      style: TextStyle(
                                          color: GAColors.white,
                                          fontSize: 19,
                                          fontWeight: FontWeight.w900)),
                                  Text('Habla o escribe con naturalidad',
                                      style: TextStyle(
                                          color: GAColors.muted, fontSize: 14)),
                                ],
                              ),
                            ),
                            IconButton(
                              tooltip: 'Cerrar asistente',
                              onPressed: () => setState(() => _open = false),
                              icon: const Icon(Icons.close,
                                  color: GAColors.white),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Semantics(
                          liveRegion: true,
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: GAColors.surface,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: GAColors.line),
                            ),
                            child: Text(_reply,
                                style: const TextStyle(
                                    color: GAColors.white,
                                    fontSize: 16,
                                    height: 1.45)),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _controller,
                                textInputAction: TextInputAction.send,
                                onSubmitted: (v) {
                                  _handle(v);
                                  _controller.clear();
                                },
                                decoration: const InputDecoration(
                                    hintText: 'Ej. Quiero pedir una moto'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton.filledTonal(
                              tooltip:
                                  _listening ? 'Dejar de escuchar' : 'Hablar',
                              onPressed: _toggleListening,
                              style: IconButton.styleFrom(
                                minimumSize: const Size(54, 54),
                                backgroundColor: _listening
                                    ? GAColors.goldLight
                                    : const Color(0xFF211A08),
                                foregroundColor: _listening
                                    ? GAColors.black
                                    : GAColors.goldLight,
                              ),
                              icon: Icon(
                                  _listening ? Icons.mic : Icons.mic_none,
                                  size: 27),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        FilledButton(
                          onPressed: () {
                            _handle(_controller.text);
                            _controller.clear();
                          },
                          child: const Text('Enviar'),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Las acciones sensibles requieren tu confirmación manual.',
                          style: TextStyle(color: GAColors.muted, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        Positioned(
          right: 18,
          bottom: 18,
          child: SafeArea(
            child: Semantics(
              button: true,
              label: _open ? 'Cerrar asistente GA' : 'Abrir asistente GA',
              child: FloatingActionButton(
                heroTag: 'gaAssistant',
                onPressed: () => setState(() => _open = !_open),
                backgroundColor: GAColors.goldLight,
                foregroundColor: GAColors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                  side: const BorderSide(color: GAColors.gold, width: 2),
                ),
                child: Text(_open ? '×' : 'GA',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w900)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
