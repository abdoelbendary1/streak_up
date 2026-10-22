import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Captured once for a specific account. Never logged or persisted.
class SupabaseRequestCredentials {
  const SupabaseRequestCredentials({
    required this.userId,
    required this.token,
    required this.expiresAt,
  });
  final String userId;
  final String token;
  final DateTime expiresAt;
  bool get isValid =>
      token.isNotEmpty &&
      DateTime.now()
          .toUtc()
          .add(const Duration(seconds: 30))
          .isBefore(expiresAt);
  static const requestKey = 'supabaseAccountCredentials';
}

/// Request-time SDK credentials only; no admission or refresh policy.
class SupabaseAuthInterceptor extends Interceptor {
  SupabaseAuthInterceptor(this._supabase);
  final SupabaseClient _supabase;
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // A reused Options object must not carry an earlier account's header.
    options.headers.removeWhere(
      (key, _) => key.toLowerCase() == 'authorization',
    );
    final pinned = options.extra[SupabaseRequestCredentials.requestKey];
    if (pinned is SupabaseRequestCredentials) {
      final session = _supabase.auth.currentSession;
      if (!pinned.isValid ||
          session == null ||
          session.isExpired ||
          session.user.id != pinned.userId) {
        handler.reject(
          DioException(
            requestOptions: options,
            response: Response(requestOptions: options, statusCode: 401),
            type: DioExceptionType.badResponse,
          ),
        );
        return;
      }
      options.headers['Authorization'] = 'Bearer ${pinned.token}';
      handler.next(options);
      return;
    }
    final token = _supabase.auth.currentSession?.accessToken;
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
