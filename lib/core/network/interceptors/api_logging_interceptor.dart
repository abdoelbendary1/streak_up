import 'package:dio/dio.dart';
import 'package:streak_up/core/logging/app_logger.dart';

/// Metadata only. Bodies, headers, query values and exception messages stay out.
class ApiLoggingInterceptor extends Interceptor {
  ApiLoggingInterceptor(this._logger);

  final AppLogger _logger;
  int _nextId = 0;
  static const requestIdKey = 'requestId';
  static const startedAtKey = 'startedAt';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final id = ++_nextId;
    options.extra[requestIdKey] = id;
    options.extra[startedAtKey] = Stopwatch()..start();

    _logger.info(
      'api.started',
      metadata: {
        'requestId': id,
        'method': options.method,
        'path': _safePath(options.path),
      },
    );
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final timer = response.requestOptions.extra[startedAtKey];
    final durationMs = timer is Stopwatch ? timer.elapsedMilliseconds : null;

    _logger.info(
      'api.succeeded',
      metadata: {
        'requestId': response.requestOptions.extra[requestIdKey],
        'method': response.requestOptions.method,
        'path': _safePath(response.requestOptions.path),
        'statusCode': response.statusCode,
        'durationMs': ?durationMs,
      },
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final timer = err.requestOptions.extra[startedAtKey];
    final durationMs = timer is Stopwatch ? timer.elapsedMilliseconds : null;

    _logger.warning(
      'api.failed',
      metadata: {
        'requestId': err.requestOptions.extra[requestIdKey],
        'method': err.requestOptions.method,
        'path': _safePath(err.requestOptions.path),
        'statusCode': ?err.response?.statusCode,
        'durationMs': ?durationMs,
        'dioCategory': err.type.name,
      },
    );
    handler.next(err);
  }

  String _safePath(String path) {
    final segments = Uri.tryParse(path)?.pathSegments ?? const <String>[];
    final identifier = RegExp(r'^[a-z][a-z0-9_]{0,62}$');
    if (segments.length == 1 && identifier.hasMatch(segments.first)) {
      return '/${segments.first}';
    }
    if (segments.length == 2 &&
        segments.first == 'rpc' &&
        identifier.hasMatch(segments.last)) {
      return '/rpc/${segments.last}';
    }
    return '/[redacted]';
  }
}
