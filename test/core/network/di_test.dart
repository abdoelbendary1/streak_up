import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:streak_up/app/bootstrap/injection.dart';
import 'package:streak_up/app/routing/app_router.dart';
import 'package:streak_up/core/logging/app_logger.dart';
import 'package:streak_up/core/presentation/connectivity/connectivity_cubit.dart';
import 'package:streak_up/core/presentation/feedback/feedback_coordinator.dart';
import 'package:streak_up/features/auth/domain/repositories/auth_repository.dart';
import 'package:streak_up/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:streak_up/features/shell/presentation/cubit/shell_cubit.dart';
import 'package:streak_up/core/network/interceptors/api_logging_interceptor.dart';
import 'package:streak_up/core/network/interceptors/supabase_auth_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supa;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'generated Injectable DI resolves complete dependency graph cleanly',
    () async {
      final locator = GetIt.asNewInstance();

      SharedPreferences.setMockInitialValues({});
      try {
        await supa.Supabase.initialize(
          url: 'https://test.supabase.co',
          publishableKey: 'sb_test_anon_key',
          debug: false,
          authOptions: const supa.FlutterAuthClientOptions(
            localStorage: supa.EmptyLocalStorage(),
          ),
        );
      } catch (_) {}

      await configureDependencies(instance: locator);

      // Verify all critical infrastructure and feature singletons resolve without throwing
      // 1. AppLogger
      final logger = locator<AppLogger>();
      expect(logger, isA<AppLogger>());

      // 2. Named supabaseRestDio
      final dio = locator<Dio>(instanceName: 'supabaseRestDio');
      expect(dio, isA<Dio>());
      expect(dio.options.baseUrl, contains('/rest/v1'));
      expect(dio.interceptors.any((i) => i is SupabaseAuthInterceptor), isTrue);
      expect(dio.interceptors.any((i) => i is ApiLoggingInterceptor), isTrue);

      // 3. SupabaseClient
      final supabase = locator<supa.SupabaseClient>();
      expect(supabase, isA<supa.SupabaseClient>());

      // 4. AuthRepository
      final authRepository = locator<AuthRepository>();
      expect(authRepository, isA<AuthRepository>());

      // 5. AuthCubit
      final authCubit = locator<AuthCubit>();
      expect(authCubit, isA<AuthCubit>());

      // 6. ShellCubit
      final shellCubit = locator<ShellCubit>();
      expect(shellCubit, isA<ShellCubit>());

      // 7. ConnectivityCubit
      final connectivityCubit = locator<ConnectivityCubit>();
      expect(connectivityCubit, isA<ConnectivityCubit>());

      // 8. FeedbackCoordinator
      final feedbackCoordinator = locator<FeedbackCoordinator>();
      expect(feedbackCoordinator, isA<FeedbackCoordinator>());

      // 9. AppRouter
      final appRouter = locator<AppRouter>();
      expect(appRouter, isA<AppRouter>());

      await locator.reset();
      try {
        await supa.Supabase.instance.dispose();
      } catch (_) {}
    },
  );
}
