import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Shared locale-aware date, time, count, and bidirectional text formatting
/// (`T028`, `SL01-FR-008`, `AS-07`, `UXF-07`).
///
/// Preserves the approved 0–9 Western Arabic numeral glyphs (`0`–`9`) across
/// both English and Arabic while localizing month/day/time names and keeping
/// mixed English/Arabic user strings readable.
abstract final class LocaleFormatter {
  static const Map<String, String> _easternToWesternDigits = <String, String>{
    '٠': '0',
    '١': '1',
    '٢': '2',
    '٣': '3',
    '٤': '4',
    '٥': '5',
    '٦': '6',
    '٧': '7',
    '٨': '8',
    '٩': '9',
    '۰': '0',
    '۱': '1',
    '۲': '2',
    '۳': '3',
    '۴': '4',
    '۵': '5',
    '۶': '6',
    '۷': '7',
    '۸': '8',
    '۹': '9',
  };

  /// Normalizes any Eastern Arabic or Persian digits into the approved 0–9 glyphs.
  static String enforceWesternNumerals(String input) {
    final buffer = StringBuffer();
    for (final rune in input.runes) {
      final char = String.fromCharCode(rune);
      buffer.write(_easternToWesternDigits[char] ?? char);
    }
    return buffer.toString();
  }

  /// Formats an integer count using locale grouping while enforcing 0–9 glyphs.
  static String formatCount(int count, Locale locale) {
    final tag = locale.languageCode == 'ar' ? 'ar' : 'en';
    final formatted = NumberFormat.decimalPattern(tag).format(count);
    return enforceWesternNumerals(formatted);
  }

  /// Formats a civil date with localized weekday/month names and 0–9 numerals.
  static String formatDate(DateTime date, Locale locale) {
    final tag = locale.languageCode == 'ar' ? 'ar' : 'en';
    final formatted = DateFormat.yMMMEd(tag).format(date);
    return enforceWesternNumerals(formatted);
  }

  /// Formats a time of day with localized period markers and 0–9 numerals.
  static String formatTime(DateTime dateTime, Locale locale) {
    final tag = locale.languageCode == 'ar' ? 'ar' : 'en';
    final formatted = DateFormat.jm(tag).format(dateTime);
    return enforceWesternNumerals(formatted);
  }

  /// Isolates mixed-script user text using Unicode First-Strong Isolate (`\u2068`..`\u2069`)
  /// so surrounding Arabic/English sentence punctuation and digits do not reorder confusingly.
  static String isolateMixedScript(String text) {
    if (text.isEmpty) {
      return text;
    }
    return '\u2068${enforceWesternNumerals(text)}\u2069';
  }
}
