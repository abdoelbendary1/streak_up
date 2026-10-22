import 'package:injectable/injectable.dart';
import 'package:flutter/foundation.dart';

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

/// Privacy-safe structured logging; tests and telemetry capture via the sink.
@lazySingleton
class AppLogger {
  AppLogger({void Function(LogEntry entry)? sink})
    : _sink = sink ?? (kReleaseMode ? null : _debugSink);

  @factoryMethod
  factory AppLogger.injectable() => AppLogger();

  static void _debugSink(LogEntry entry) {
    if (entry.event == 'api.started') {
      final reqId = entry.metadata['requestId'];
      final method = entry.metadata['method'];
      final path = entry.metadata['path'];
      debugPrint('[API â†’] #$reqId $method $path');
      return;
    }
    if (entry.event == 'api.succeeded') {
      final reqId = entry.metadata['requestId'];
      final status = entry.metadata['statusCode'];
      final method = entry.metadata['method'];
      final path = entry.metadata['path'];
      final duration = entry.metadata['durationMs'];
      debugPrint('[API â†گ] #$reqId $status $method $path ${duration}ms');
      return;
    }
    if (entry.event == 'api.failed') {
      final reqId = entry.metadata['requestId'];
      final status =
          entry.metadata['statusCode'] ?? entry.metadata['dioCategory'];
      final method = entry.metadata['method'];
      final path = entry.metadata['path'];
      final duration = entry.metadata['durationMs'];
      debugPrint(
        '[API أ—] #$reqId $status $method $path ${duration != null ? '${duration}ms' : ''}',
      );
      return;
    }
    debugPrint(entry.toString());
  }

  final void Function(LogEntry entry)? _sink;

  static const Set<String> _allowlistedKeys = <String>{
    'blocType',
    'currentStateType',
    'nextStateType',
    'errorType',
    'lifecycle',
    'destination',
    'count',
    'networkState',
    'requestId',
    'method',
    'path',
    'statusCode',
    'durationMs',
    'dioCategory',
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
    _sink?.call(entry);
  }

  void info(String event, {Map<String, Object?> metadata = const {}}) {
    log(LogLevel.info, event, metadata: metadata);
  }

  void warning(String event, {Map<String, Object?> metadata = const {}}) {
    log(LogLevel.warning, event, metadata: metadata);
  }

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
