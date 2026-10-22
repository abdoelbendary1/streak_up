import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:streak_up/app/config/supabase_config.dart';
import 'package:streak_up/app/routing/app_router.dart';
import 'package:streak_up/core/logging/app_bloc_observer.dart';
import 'package:streak_up/core/network/interceptors/supabase_auth_interceptor.dart';
import 'package:streak_up/features/auth/data/storage/secure_auth_storage.dart';
import 'package:streak_up/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:streak_up/features/habits/data/local/habit_local_store.dart';
import 'package:streak_up/features/habits/data/repositories/habit_repository_impl.dart';
import 'package:streak_up/features/shell/presentation/cubit/shell_cubit.dart';
import 'injection.dart';
import '../streak_up_app.dart';

Future<StreakUpApp> bootstrapApp({GetIt? locator}) async {
  SupabaseConfig.validate();
  final di = await configureDependencies(instance: locator);
  final storage = di<SecureAuthStorage>();
  await Supabase.initialize(
    debug: false,
    url: SupabaseConfig.url,
    publishableKey: SupabaseConfig.publishableKey,
    authOptions: FlutterAuthClientOptions(
      localStorage: storage,
      pkceAsyncStorage: storage.pkceStorage,
    ),
  );
  Bloc.observer = di<AppBlocObserver>();
  return StreakUpApp(
    shellCubit: di<ShellCubit>(),
    authCubit: di<AuthCubit>(),
    router: di<AppRouter>().router,
    openHabitRepository: (accountId) async {
      final directory = await getApplicationSupportDirectory();
      final store = await HabitLocalStore.open(
        directory: directory.path,
        accountId: accountId,
      );
      return HabitRepositoryImpl(
        store,
        remote: di<Dio>(instanceName: 'supabaseEdgeDio'),
        readCredentials: () {
          final state = di<AuthCubit>().state;
          final session = di<SupabaseClient>().auth.currentSession;
          if (!state.canAccessProtected ||
              state.session?.userId != accountId ||
              session == null ||
              session.user.id != accountId ||
              session.isExpired ||
              session.expiresAt == null) {
            return null;
          }
          return SupabaseRequestCredentials(
            userId: session.user.id,
            token: session.accessToken,
            expiresAt: DateTime.fromMillisecondsSinceEpoch(
              session.expiresAt! * 1000,
              isUtc: true,
            ),
          );
        },
        isAccountAvailable: () {
          final state = di<AuthCubit>().state;
          return state.canAccessProtected && state.session?.userId == accountId;
        },
      );
    },
  );
}
