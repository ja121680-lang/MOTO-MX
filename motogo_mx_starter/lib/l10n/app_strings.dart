import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Languages MotoGo MX is preparing for. Only Spanish ships translated in
/// Paquete 01 — the rest exist so the structure (and every call site) is
/// already in place once real translations are written.
enum AppLanguage { es, en, fr, it, pt, de }

/// Language and country/region are deliberately separate settings (a
/// Spanish-speaking user in the US and one in Mexico share a language but
/// not a region), persisted independently, mirroring [TextScaleController]'s
/// singleton + `ChangeNotifier` pattern so the rest of the app can listen
/// the same way.
class LocaleConfig extends ChangeNotifier {
  LocaleConfig._();
  static final LocaleConfig instance = LocaleConfig._();

  static const _languageKey = 'motogo_language';
  static const _countryKey = 'motogo_country_code';

  AppLanguage _language = AppLanguage.es;
  String _countryCode = 'MX';

  AppLanguage get language => _language;
  String get countryCode => _countryCode;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString(_languageKey);
    _language = AppLanguage.values.firstWhere(
      (language) => language.name == savedLanguage,
      orElse: () => AppLanguage.es,
    );
    _countryCode = prefs.getString(_countryKey) ?? 'MX';
    notifyListeners();
  }

  Future<void> setLanguage(AppLanguage language) async {
    _language = language;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, language.name);
  }

  Future<void> setCountryCode(String code) async {
    _countryCode = code;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_countryKey, code);
  }
}

/// Centralized copy for MotoGo MX's passenger experience, so every screen's
/// text lives in one place instead of scattered `Text('...')` literals.
///
/// Paquete 01 ships Spanish only — that requirement is satisfied by design:
/// the Spanish text itself is the lookup key, so [t] always has a correct
/// value to show. The other five language maps are real and wired into
/// every call site via [t]; they start empty (not fabricated placeholder
/// translations) and fill in as each language is actually translated,
/// with no code changes needed at the call sites when that happens.
class AppStrings {
  static const Map<String, String> en = {};
  static const Map<String, String> fr = {};
  static const Map<String, String> it = {};
  static const Map<String, String> pt = {};
  static const Map<String, String> de = {};

  static Map<String, String>? _mapFor(AppLanguage language) {
    switch (language) {
      case AppLanguage.es:
        return null; // Spanish text is its own source of truth.
      case AppLanguage.en:
        return en;
      case AppLanguage.fr:
        return fr;
      case AppLanguage.it:
        return it;
      case AppLanguage.pt:
        return pt;
      case AppLanguage.de:
        return de;
    }
  }

  /// Looks up [spanishText] in the active language's translation map,
  /// falling back to the Spanish source when the active language is
  /// Spanish itself or the string hasn't been translated yet.
  static String t(String spanishText) {
    final map = _mapFor(LocaleConfig.instance.language);
    if (map == null) return spanishText;
    return map[spanishText] ?? spanishText;
  }
}

/// Short call-site alias — `S.t('¿A dónde vamos?')`.
class S {
  static String t(String spanishText) => AppStrings.t(spanishText);
}
