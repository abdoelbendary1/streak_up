import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streak_up/core/logging/app_logger.dart';
import 'package:streak_up/core/network/interceptors/api_logging_interceptor.dart';
import 'package:streak_up/core/network/interceptors/supabase_auth_interceptor.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class _FakeAuth extends Fake implements GoTrueClient {
  _FakeAuth([this._session]);
  final Session? _session;
  @override
  Session? get currentSession => _session;
}

class _FakeSupabaseClient extends Fake implements SupabaseClient {
  _FakeSupabaseClient([Session? session]) : auth = _FakeAuth(session);
  @override
  final GoTrueClient auth;
}

Session _buildSession({required String token, String userId = 'test-user-id'}) {
  return Session(
    accessToken: token,
    tokenType: 'bearer',
    user: User(
      id: userId,
      appMetadata: {},
      userMetadata: {},
      aud: 'authenticated',
      createdAt: '2026-01-01T00:00:00Z',
    ),
  );
}

class _SyncErrorInterceptorHandler extends ErrorInterceptorHandler {
  DioException? handledError;
  @override
  void next(DioException err) {
    handledError = err;
  }
}

ErrorInterceptorHandler _testErrorHandler() => _SyncErrorInterceptorHandler();

void main() {
  group('SupabaseAuthInterceptor', () {
    test(
      'injects Bearer token into Authorization header when session exists',
      () {
        final session = _buildSession(token: 'valid-jwt-token-xyz');
        final supabase = _FakeSupabaseClient(session);
        final interceptor = SupabaseAuthInterceptor(supabase);

        final options = RequestOptions(path: '/habits');
        interceptor.onRequest(options, RequestInterceptorHandler());

        expect(options.headers['Authorization'], 'Bearer valid-jwt-token-xyz');
      },
    );

    test(
      'removes and omits Authorization header when session is absent or empty',
      () {
        final supabase = _FakeSupabaseClient(null);
        final interceptor = SupabaseAuthInterceptor(supabase);

        final options = RequestOptions(
          path: '/habits',
          headers: {'Authorization': 'Bearer old-stale-token'},
        );
        interceptor.onRequest(options, RequestInterceptorHandler());

        expect(options.headers.containsKey('Authorization'), isFalse);
      },
    );

    test('clears authorization if token is empty string', () {
      final session = _buildSession(token: '');
      final supabase = _FakeSupabaseClient(session);
      final interceptor = SupabaseAuthInterceptor(supabase);

      final options = RequestOptions(
        path: '/habits',
        headers: {'Authorization': 'Bearer old-stale-token'},
      );
      interceptor.onRequest(options, RequestInterceptorHandler());

      expect(options.headers.containsKey('Authorization'), isFalse);
    });
  });

  group('ApiLoggingInterceptor', () {
    test(
      'records request start and completion with redacted paths and metadata',
      () {
        final entries = <LogEntry>[];
        final logger = AppLogger(sink: entries.add);
        final interceptor = ApiLoggingInterceptor(logger);

        final options = RequestOptions(
          path: '/habits',
          method: 'GET',
          queryParameters: {'select': '*', 'secret': 'leak'},
        );

        interceptor.onRequest(options, RequestInterceptorHandler());
        expect(entries.length, 1);
        final startEntry = entries.first;
        expect(startEntry.event, 'api.started');
        expect(startEntry.metadata['method'], 'GET');
        expect(startEntry.metadata['path'], '/habits');
        expect(startEntry.metadata.containsKey('secret'), isFalse);
        expect(startEntry.metadata.containsKey('queryParameters'), isFalse);
        expect(startEntry.metadata.containsKey('durationMs'), isFalse);

        final response = Response<dynamic>(
          requestOptions: options,
          statusCode: 200,
        );
        interceptor.onResponse(response, ResponseInterceptorHandler());

        expect(entries.length, 2);
        final doneEntry = entries.last;
        expect(doneEntry.event, 'api.succeeded');
        expect(doneEntry.metadata['statusCode'], 200);
        expect(doneEntry.metadata.containsKey('durationMs'), isTrue);
      },
    );

    test('redacts non-structural path segments for security', () {
      final entries = <LogEntry>[];
      final logger = AppLogger(sink: entries.add);
      final interceptor = ApiLoggingInterceptor(logger);

      final options = RequestOptions(
        path: '/habits/uuid-12345-secret',
        method: 'GET',
      );

      interceptor.onRequest(options, RequestInterceptorHandler());
      expect(entries.single.metadata['path'], '/[redacted]');
    });

    test('logs error with dioCategory and redacted path', () {
      final entries = <LogEntry>[];
      final logger = AppLogger(sink: entries.add);
      final interceptor = ApiLoggingInterceptor(logger);

      final options = RequestOptions(path: '/habits', method: 'POST');
      interceptor.onRequest(options, RequestInterceptorHandler());

      final dioError = DioException(
        requestOptions: options,
        type: DioExceptionType.connectionTimeout,
      );

      interceptor.onError(dioError, _testErrorHandler());

      final errorEntry = entries.last;
      expect(errorEntry.event, 'api.failed');
      expect(errorEntry.metadata['dioCategory'], 'connectionTimeout');
      expect(errorEntry.metadata['path'], '/habits');
      expect(errorEntry.metadata.containsKey('durationMs'), isTrue);
    });
  });
}
