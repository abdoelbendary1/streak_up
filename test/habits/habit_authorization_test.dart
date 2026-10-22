import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:streak_up/core/network/interceptors/supabase_auth_interceptor.dart';

class _Auth extends Fake implements GoTrueClient {
  Session? session;
  @override
  Session? get currentSession => session;
}

class _Client extends Fake implements SupabaseClient {
  @override
  final _Auth auth = _Auth();
}

class _Handler extends RequestInterceptorHandler {
  RequestOptions? forwarded;
  DioException? rejected;
  @override
  void next(RequestOptions options) {
    forwarded = options;
  }

  @override
  void reject(
    DioException error, [
    bool callFollowingErrorInterceptor = false,
  ]) {
    rejected = error;
  }
}

Session session(String userId) {
  final exp =
      DateTime.now().add(const Duration(hours: 1)).millisecondsSinceEpoch ~/
      1000;
  final payload = base64Url
      .encode(utf8.encode(jsonEncode({'exp': exp})))
      .replaceAll('=', '');
  return Session(
    accessToken: 'e30.$payload.signature',
    tokenType: 'bearer',
    user: User(
      id: userId,
      appMetadata: {},
      userMetadata: {},
      aud: 'authenticated',
      createdAt: '2026-10-05T00:00:00Z',
    ),
  );
}

void main() {
  test(
    'interceptor rejects A credentials after switching to B, never substitutes B token',
    () {
      final client = _Client()..auth.session = session('B');
      final credentials = SupabaseRequestCredentials(
        userId: 'A',
        token: 'captured-A',
        expiresAt: DateTime.now().toUtc().add(const Duration(hours: 1)),
      );
      final options = RequestOptions(
        path: 'create-habit-v1',
        headers: {'Authorization': 'stale'},
        extra: {SupabaseRequestCredentials.requestKey: credentials},
      );
      final handler = _Handler();
      SupabaseAuthInterceptor(client).onRequest(options, handler);
      expect(handler.forwarded, isNull);
      expect(handler.rejected!.response!.statusCode, 401);
      expect(options.headers.containsKey('Authorization'), isFalse);
    },
  );
  test('same-account refresh never overwrites the captured valid token', () {
    final client = _Client()..auth.session = session('A');
    final options = RequestOptions(
      path: 'create-habit-v1',
      extra: {
        SupabaseRequestCredentials.requestKey: SupabaseRequestCredentials(
          userId: 'A',
          token: 'captured-A',
          expiresAt: DateTime.now().toUtc().add(const Duration(hours: 1)),
        ),
      },
    );
    final handler = _Handler();
    SupabaseAuthInterceptor(client).onRequest(options, handler);
    expect(handler.rejected, isNull);
    expect(handler.forwarded!.headers['Authorization'], 'Bearer captured-A');
  });
}
