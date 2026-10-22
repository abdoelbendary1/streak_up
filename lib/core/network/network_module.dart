import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Headers;
import 'package:streak_up/app/config/supabase_config.dart';
import 'package:streak_up/core/logging/app_logger.dart';
import 'interceptors/api_logging_interceptor.dart';
import 'interceptors/supabase_auth_interceptor.dart';

/// External clients and configured REST/Edge Dio clients.
@module
abstract class NetworkModule {
  @lazySingleton
  SupabaseClient get supabaseClient => Supabase.instance.client;

  @Named('supabaseRestDio')
  @LazySingleton(dispose: closeRestDio)
  Dio supabaseRestDio(SupabaseClient supabase, AppLogger logger) {
    return _supabaseDio(supabase, logger, 'rest/v1');
  }

  @Named('supabaseEdgeDio')
  @LazySingleton(dispose: closeRestDio)
  Dio supabaseEdgeDio(SupabaseClient supabase, AppLogger logger) {
    return _supabaseDio(supabase, logger, 'functions/v1');
  }

  Dio _supabaseDio(SupabaseClient supabase, AppLogger logger, String path) {
    final rawUrl = SupabaseConfig.url.replaceAll(RegExp(r'/+$'), '');
    final baseUrl = rawUrl.isEmpty
        ? 'http://127.0.0.1/$path/'
        : '$rawUrl/$path/';
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        contentType: Headers.jsonContentType,
        headers: {'apikey': SupabaseConfig.publishableKey},
      ),
    );

    // Interceptor pipeline: SupabaseAuthInterceptor -> ApiLoggingInterceptor
    dio.interceptors.addAll([
      SupabaseAuthInterceptor(supabase),
      ApiLoggingInterceptor(logger),
    ]);

    return dio;
  }
}

void closeRestDio(Dio dio) => dio.close(force: true);
