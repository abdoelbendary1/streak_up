import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

/// Log severity levels for structured application telemetry.
enum LogLevel { debug, info, warning, error }

/// Structured log entry containing only allowlisted, redacted metadata.
@immutable
class LogEntry {
  const LogEntry({
    required this.level,
    required this.event,
    required this.metadata,
    required this.timestamp,
  });

  final LogLevel level;
  final String event;
  final Map<String, Object?> metadata;
  final DateTime timestamp;

  @override
  String toString() =>
      '[${level.name.toUpperCase()}] $event ${metadata.isEmpty ? '' : metadata}';
}

/// Architecture-level structured logging contract (A-09, SL01-FR-017).
///
/// Implementations must allowlist metadata keys and scrub any sensitive values
/// (tokens, passwords, private habit names, emails, friend names, or raw payloads).
abstract interface class AppLogger {
  void log(
    LogLevel level,
    String event, {
    Map<String, Object?> metadata = const {},
  });

  void info(String event, {Map<String, Object?> metadata = const {}});

  void warning(String event, {Map<String, Object?> metadata = const {}});

  void error(String event, {Map<String, Object?> metadata = const {}});
}

/// Default privacy-safe logger that enforces key allowlisting and value sanitization.
@LazySingleton(as: AppLogger)
class RedactedAppLogger implements AppLogger {
  RedactedAppLogger() : _sink = null;

  RedactedAppLogger.withSink(void Function(LogEntry entry) sink) : _sink = sink;

  final void Function(LogEntry entry)? _sink;
  final List<LogEntry> _entries = <LogEntry>[];
  static const int _maxEntries = 500;

  /// Read-only view of recorded entries for verification in tests.
  List<LogEntry> get entries => List<LogEntry>.unmodifiable(_entries);

  static const Set<String> _allowlistedKeys = <String>{
    'blocType',
    'eventType',
    'currentStateType',
    'nextStateType',
    'errorType',
    'lifecycle',
    'destination',
    'correlationId',
    'count',
    'networkState',
    'actionSyncStatus',
    'feedbackKind',
  };

  static final RegExp _emailPattern = RegExp(
    r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}',
  );

  static final RegExp _tokenPattern = RegExp(
    r'(bearer\s+[a-zA-Z0-9\-._~+/]+=*|eyJ[a-zA-Z0-9\-_]+\.[a-zA-Z0-9\-_]+(?:\.[a-zA-Z0-9\-_]*)?|sb_secret_[a-zA-Z0-9_\-]+)',
    caseSensitive: false,
  );

  static final RegExp _queryTokenOrPasswordPattern = RegExp(
    r'((?:access_token|refresh_token|token_hash|token|code|password|secret)\s*[=:]\s*)([^\s&#,]+)',
    caseSensitive: false,
  );

  static final Set<String> _prohibitedKeySubstrings = <String>{
    'token',
    'password',
    'secret',
    'email',
    'habit',
    'friend',
    'payload',
    'state',
    'body',
    'link',
    'url',
    'uri',
  };

  @override
  void log(
    LogLevel level,
    String event, {
    Map<String, Object?> metadata = const {},
  }) {
    final sanitized = _sanitizeMetadata(metadata);
    final entry = LogEntry(
      level: level,
      event: _sanitizeString(event),
      metadata: sanitized,
      timestamp: DateTime.now().toUtc(),
    );
    if (_entries.length == _maxEntries) {
      _entries.removeAt(0);
    }
    _entries.add(entry);
    _sink?.call(entry);
  }

  @override
  void info(String event, {Map<String, Object?> metadata = const {}}) {
    log(LogLevel.info, event, metadata: metadata);
  }

  @override
  void warning(String event, {Map<String, Object?> metadata = const {}}) {
    log(LogLevel.warning, event, metadata: metadata);
  }

  @override
  void error(String event, {Map<String, Object?> metadata = const {}}) {
    log(LogLevel.error, event, metadata: metadata);
  }

  Map<String, Object?> _sanitizeMetadata(Map<String, Object?> raw) {
    final safe = <String, Object?>{};
    for (final entry in raw.entries) {
      final key = entry.key;
      // Drop any key outside the allowlist so private habit names, friend identifiers, or raw payloads never enter telemetry.
      if (!_allowlistedKeys.contains(key)) {
        continue;
      }
      final lowerKey = key.toLowerCase();
      final isExplicitTypeKey =
          key == 'blocType' ||
          key == 'eventType' ||
          key == 'currentStateType' ||
          key == 'nextStateType' ||
          key == 'errorType' ||
          key == 'networkState';
      if (!isExplicitTypeKey &&
          _prohibitedKeySubstrings.any(lowerKey.contains)) {
        continue;
      }
      final value = entry.value;
      if (value == null || value is num || value is bool) {
        safe[key] = value;
      } else {
        safe[key] = _sanitizeString(value.toString());
      }
    }
    return Map<String, Object?>.unmodifiable(safe);
  }

  String _sanitizeString(String input) {
    return input
        .replaceAll(_emailPattern, '[REDACTED_EMAIL]')
        .replaceAll(_tokenPattern, '[REDACTED_TOKEN]')
        .replaceAllMapped(
          _queryTokenOrPasswordPattern,
          (match) => '${match.group(1)}[REDACTED_SECRET]',
        );
  }
}
