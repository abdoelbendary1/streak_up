import 'package:flutter/material.dart';

/// Presentation-only active-locale resolver (`T026`, `SL01-FR-005`–`006`, `AS-04`–`05`).
///
/// Rules:
/// - If an explicit presentation override is supplied (e.g. from future Profile),
///   resolve to `en` or `ar` (defaulting unsupported override codes to `en`).
/// - Otherwise inspect the device locale: `en` -> `Locale('en')`, `ar` -> `Locale('ar')`,
///   and any unsupported language falls back to `Locale('en')`.
/// - SL-01 stores no preference on disk or in a database.
abstract final class ActiveLocaleResolver {
  static const Locale english = Locale('en');
  static const Locale arabic = Locale('ar');

  static const List<Locale> supportedLocales = <Locale>[
    english,
    arabic,
  ];

  static Locale resolve({
    Locale? explicitOverride,
    Locale? deviceLocale,
  }) {
    if (explicitOverride != null) {
      return _normalizeSupported(explicitOverride);
    }
    if (deviceLocale != null) {
      return _normalizeSupported(deviceLocale);
    }
    return english;
  }

  static Locale resolveFromList(
    List<Locale>? deviceLocales, {
    Locale? explicitOverride,
  }) {
    if (explicitOverride != null) {
      return _normalizeSupported(explicitOverride);
    }
    if (deviceLocales == null || deviceLocales.isEmpty) {
      return english;
    }
    final primary = deviceLocales.first;
    return _normalizeSupported(primary);
  }

  static Locale _normalizeSupported(Locale candidate) {
    final code = candidate.languageCode.toLowerCase();
    if (code == 'ar') {
      return arabic;
    }
    return english;
  }
}
