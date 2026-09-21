import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Lets the user pick how large text renders across the whole app —
/// persisted locally so the choice survives restarts. Presentation only:
/// nothing here touches data, routes or business logic.
class TextScaleController extends ChangeNotifier {
  TextScaleController._();
  static final TextScaleController instance = TextScaleController._();

  static const _key = 'motogo_text_scale';
  static const List<double> steps = [1.0, 1.15, 1.3];
  static const List<String> labels = ['Normal', 'Grande', 'Muy grande'];

  double _scale = 1.0;
  double get scale => _scale;
  int get stepIndex => steps.indexOf(_scale) == -1 ? 0 : steps.indexOf(_scale);
  String get label => labels[stepIndex];

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _scale = prefs.getDouble(_key) ?? 1.0;
    notifyListeners();
  }

  Future<void> cycle() async {
    final next = steps[(stepIndex + 1) % steps.length];
    _scale = next;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_key, next);
  }
}
