import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

/// GA conversational assistant for MotoGo MX.
///
/// The assistant navigates and explains. It deliberately never requests a
/// ride, accepts a trip, submits a payment, performs a withdrawal, approves a
/// driver, or changes administrative data by itself. Sensitive workflows only
/// open after explicit confirmation and still require the user to complete the
/// final action on the destination screen.
class MotoGoGAAssistant extends StatefulWidget {
  const MotoGoGAAssistant({
    super.key,
    required this.onNavigate,
  });

  final void Function(String route) onNavigate;

  @override
  State<MotoGoGAAssistant> createState() => _MotoGoGAAssistantState();
}

class _MotoGoGAAssistantState extends State<MotoGoGAAssistant> {
  final _controller = TextEditingController();
  final _speech = stt.SpeechToText();
  final _tts = FlutterTts();

  String _answer = '¿En qué te ayudo?';
  String? _pendingRoute;
  String? _pendingLabel;
  bool _speechReady = false;
  bool _listening = false;

  @override
  void initState() {
    super.initState();
    unawaited(_initVoice());
  }

  Future<void> _initVoice() async {
    try {
      final available = await _speech.initialize(
        onStatus: (status) {
          if (!mounted) return;
          final active = status == 'listening';
          if (_listening != active) setState(() => _listening = active);
        },
        onError: (_) {
          if (!mounted) return;
          setState(() => _listening = false);
        },
      );
      await _tts.setLanguage('es-MX');
      await _tts.setSpeechRate(0.48);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);
      if (mounted) setState(() => _speechReady = available);
    } catch (_) {
      if (mounted) setState(() => _speechReady = false);
    }
  }

  Future<void> _speak(String message) async {
    try {
      await _tts.stop();
      await _tts.speak(message);
    } catch (_) {
      // Text remains visible and screen-reader friendly if TTS is unavailable.
    }
  }

  Future<void> _toggleListening() async {
    if (_speech.isListening) {
      await _speech.stop();
      if (mounted) setState(() => _listening = false);
      return;
    }

    if (!_speechReady) {
      await _initVoice();
      if (!_speechReady) {
        _say('No pude activar el reconocimiento de voz en este dispositivo. Puedes seguir escribiendo tu solicitud.');
        return;
      }
    }

    await _tts.stop();
    await _speech.listen(
      localeId: 'es_MX',
      onResult: (result) {
        final words = result.recognizedWords.trim();
        if (!mounted || words.isEmpty) return;
        setState(() => _controller.text = words);
        if (result.finalResult) {
          setState(() => _listening = false);
          _handle(words);
        }
      },
    );
    if (mounted) setState(() => _listening = true);
  }

  String _norm(String value) {
    var text = value.toLowerCase().trim();
    const replacements = {
      'á': 'a',
      'é': 'e',
      'í': 'i',
      'ó': 'o',
      'ú': 'u',
      'ü': 'u',
    };
    replacements.forEach((from, to) => text = text.replaceAll(from, to));
    return text
        .replaceAll(RegExp(r'[^a-z0-9ñ\s]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  bool _has(String text, List<String> terms) => terms.any(text.contains);

  void _say(String message) {
    if (!mounted) return;
    setState(() => _answer = message);
    unawaited(_speak(message));
  }

  void _navigate(String route, String message) {
    widget.onNavigate(route);
    _say(message);
  }

  void _requestSensitive(String route, String label) {
    setState(() {
      _pendingRoute = route;
      _pendingLabel = label;
      _answer = 'Esta solicitud abre un flujo sensible: $label. '
          'Di o escribe “confirmar” para abrirlo, o “cancelar” para detenerlo. '
          'El asistente no ejecutará la acción final por ti.';
    });
    unawaited(_speak(_answer));
  }

  void _confirm() {
    final route = _pendingRoute;
    final label = _pendingLabel;
    if (route == null) {
      _say('No hay ninguna acción sensible pendiente de confirmar.');
      return;
    }
    setState(() {
      _pendingRoute = null;
      _pendingLabel = null;
    });
    widget.onNavigate(route);
    _say('Confirmado. Abrí el flujo de $label. Revisa los datos y completa la acción manualmente si realmente deseas continuar.');
  }

  void _cancel() {
    setState(() {
      _pendingRoute = null;
      _pendingLabel = null;
    });
    _say('Acción cancelada. No se solicitó viaje, no se pagó, no se retiró dinero y no se modificaron datos.');
  }

  void _handle(String raw) {
    final text = _norm(raw);
    if (text.isEmpty) {
      _say('Puedes decirme, por ejemplo: “quiero pedir una moto”, “abre mi historial” o “quiero ver mi saldo”.');
      return;
    }

    if (_pendingRoute != null &&
        _has(text, ['confirmar', 'confirmo', 'si confirmo', 'continuar', 'adelante'])) {
      _confirm();
      return;
    }
    if (_pendingRoute != null &&
        _has(text, ['cancelar', 'cancela', 'detener', 'no continuar', 'no'])) {
      _cancel();
      return;
    }

    if (_has(text, ['que puedes hacer', 'como me ayudas', 'ayuda', 'opciones'])) {
      _say('Puedo guiarte por pasajero, conductor y administración: solicitar viaje, ver tarifa, conductores cercanos, seguimiento, historial, billetera, registro de conductor, corte de caja y panel administrativo. Los pagos, retiros, solicitudes y acciones privilegiadas requieren confirmación y una acción manual final.');
      return;
    }

    if (_has(text, ['pagar', 'pago', 'hacer pago', 'pagar viaje'])) {
      _requestSensitive('/payment', 'pago');
      return;
    }
    if (_has(text, ['retirar', 'retiro', 'sacar dinero', 'retirar saldo'])) {
      _requestSensitive('/withdrawal', 'retiro de saldo');
      return;
    }
    if (_has(text, ['pedir moto', 'solicitar moto', 'pedir viaje', 'solicitar viaje', 'quiero un viaje'])) {
      _requestSensitive('/request', 'solicitud de viaje');
      return;
    }
    if (_has(text, ['aprobar conductor', 'aprobar chofer', 'validar conductor'])) {
      _requestSensitive('/driver-approval', 'aprobación de conductor');
      return;
    }
    if (_has(text, ['administracion', 'administrador', 'admin', 'panel administrativo'])) {
      _requestSensitive('/admin', 'acceso al panel administrativo');
      return;
    }

    if (_has(text, ['inicio', 'home', 'principal', 'volver al inicio'])) {
      _navigate('/home', 'Abrí el inicio de MotoGo MX.');
      return;
    }
    if (_has(text, ['tarifa', 'cuanto cuesta', 'precio del viaje', 'cotizacion'])) {
      _navigate('/fare-preview', 'Abrí la vista previa de tarifa.');
      return;
    }
    if (_has(text, ['conductores cerca', 'motos cerca', 'choferes cerca', 'conductores cercanos'])) {
      _navigate('/nearby-drivers', 'Abrí los conductores cercanos.');
      return;
    }
    if (_has(text, ['seguimiento', 'rastrear viaje', 'donde esta el conductor', 'ubicacion del conductor'])) {
      _navigate('/tracking', 'Abrí el seguimiento del viaje.');
      return;
    }
    if (_has(text, ['emparejamiento', 'buscando conductor', 'matching'])) {
      _navigate('/matching', 'Abrí la búsqueda de conductor.');
      return;
    }
    if (_has(text, ['historial', 'viajes anteriores', 'mis viajes'])) {
      _navigate('/history', 'Abrí tu historial de viajes.');
      return;
    }
    if (_has(text, ['calificar', 'calificacion', 'rating'])) {
      _navigate('/rating', 'Abrí la calificación del viaje.');
      return;
    }
    if (_has(text, ['billetera', 'wallet', 'saldo', 'mi dinero'])) {
      _navigate('/wallet', 'Abrí la billetera.');
      return;
    }
    if (_has(text, ['diamond', 'diamante', 'beneficios'])) {
      _navigate('/diamond', 'Abrí MotoGo Diamond.');
      return;
    }
    if (_has(text, ['soy conductor', 'modo conductor', 'panel conductor', 'conductor'])) {
      _navigate('/driver', 'Abrí el área del conductor.');
      return;
    }
    if (_has(text, ['registrarme conductor', 'registro conductor', 'registro de conductor', 'ser conductor'])) {
      _navigate('/driver-registration', 'Abrí el registro de conductor. Revisa cuidadosamente los documentos antes de enviarlos.');
      return;
    }
    if (_has(text, ['corte', 'corte de caja', 'caja'])) {
      _navigate('/corte-de-caja', 'Abrí el corte de caja.');
      return;
    }

    _say('No identifiqué exactamente lo que necesitas. Prueba con “pedir un viaje”, “ver tarifa”, “conductores cercanos”, “historial”, “billetera”, “modo conductor” o “corte de caja”.');
  }

  @override
  void dispose() {
    unawaited(_speech.cancel());
    unawaited(_tts.stop());
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Material(
        color: const Color(0xFF141414),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Asistente GA · MotoGo',
                      style: TextStyle(
                        color: Color(0xFFD4AF37),
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Cerrar asistente',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
              const Text(
                'Habla o escribe con lenguaje natural. El asistente orienta y navega; nunca completa pagos, retiros, viajes o aprobaciones por sí mismo.',
                style: TextStyle(color: Color(0xFFD7D7D7), fontSize: 15, height: 1.45),
              ),
              const SizedBox(height: 14),
              Semantics(
                liveRegion: true,
                child: Container(
                  constraints: const BoxConstraints(minHeight: 80),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0B0B0B),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFF6B5920)),
                  ),
                  child: Text(
                    _answer,
                    style: const TextStyle(color: Colors.white, fontSize: 17, height: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _controller,
                minLines: 1,
                maxLines: 3,
                textInputAction: TextInputAction.send,
                onSubmitted: _handle,
                style: const TextStyle(fontSize: 18),
                decoration: const InputDecoration(
                  labelText: 'Tu solicitud',
                  hintText: 'Ej. Quiero ver mi historial de viajes',
                  prefixIcon: Icon(Icons.chat_outlined),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _toggleListening,
                      icon: Icon(_listening ? Icons.mic : Icons.mic_none),
                      label: Text(_listening ? 'Escuchando…' : 'Hablar'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => _handle(_controller.text),
                      icon: const Icon(Icons.send),
                      label: const Text('Enviar'),
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => _handle('que puedes hacer'),
                child: const Text('¿Qué puedo pedir?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
