import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Locales the app currently ships translations for. Add to ARB files + this
/// list to expand. Italian is the source of truth (template), English mirrors.
const List<Locale> kSupportedLocales = [
  Locale('it'),
  Locale('en'),
];

const _kLocalePrefsKey = 'app_locale_v1';

/// Locale preference, persisted in SharedPreferences. `null` = follow the
/// device locale (which falls back to `it` if the device locale isn't in
/// [kSupportedLocales]).
class LocaleNotifier extends StateNotifier<Locale?> {
  LocaleNotifier() : super(null) {
    _load();
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final code = prefs.getString(_kLocalePrefsKey);
      if (code != null && code.isNotEmpty) {
        state = Locale(code);
      }
    } catch (_) {
      // Corrupted/unavailable prefs — keep system default.
    }
  }

  Future<void> set(Locale? locale) async {
    state = locale;
    try {
      final prefs = await SharedPreferences.getInstance();
      if (locale == null) {
        await prefs.remove(_kLocalePrefsKey);
      } else {
        await prefs.setString(_kLocalePrefsKey, locale.languageCode);
      }
    } catch (_) {}
  }
}

final localeProvider =
    StateNotifierProvider<LocaleNotifier, Locale?>((ref) => LocaleNotifier());
