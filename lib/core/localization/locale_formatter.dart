/// Shared locale-aware numeral formatting.
///
/// Preserves the approved 0â€“9 Western Arabic numeral glyphs (`0`â€“`9`) across
/// both English and Arabic.
abstract final class LocaleFormatter {
  static const Map<String, String> _easternToWesternDigits = <String, String>{
    'ظ ': '0',
    'ظ،': '1',
    'ظ¢': '2',
    'ظ£': '3',
    'ظ¤': '4',
    'ظ¥': '5',
    'ظ¦': '6',
    'ظ§': '7',
    'ظ¨': '8',
    'ظ©': '9',
    'غ°': '0',
    'غ±': '1',
    'غ²': '2',
    'غ³': '3',
    'غ´': '4',
    'غµ': '5',
    'غ¶': '6',
    'غ·': '7',
    'غ¸': '8',
    'غ¹': '9',
  };

  /// Normalizes any Eastern Arabic or Persian digits into the approved 0â€“9 glyphs.
  static String enforceWesternNumerals(String input) {
    final buffer = StringBuffer();
    for (final rune in input.runes) {
      final char = String.fromCharCode(rune);
      buffer.write(_easternToWesternDigits[char] ?? char);
    }
    return buffer.toString();
  }
}
