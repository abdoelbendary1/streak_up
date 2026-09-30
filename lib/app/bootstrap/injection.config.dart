// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../core/presentation/feedback/feedback_coordinator.dart' as _i546;
import '../../core/presentation/status/status_models.dart' as _i372;
import '../../features/auth/application/auth_session_coordinator.dart' as _i947;
import '../../features/auth/data/supabase_auth_gateway.dart' as _i322;
import '../../features/auth/domain/auth_gateway.dart' as _i654;
import '../../features/auth/domain/pending_work_presence.dart' as _i525;
import '../../features/auth/presentation/auth_cubit.dart' as _i731;
import '../../features/shell/presentation/shell_cubit.dart' as _i165;
import '../routing/app_router.dart' as _i282;
import '../routing/feature_route_hosts.dart' as _i459;
import 'app_logger.dart' as _i24;
import 'injection.dart' as _i464;
import 'redacted_bloc_observer.dart' as _i99;
import 'supabase_environment.dart' as _i586;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final supabaseBootstrapModule = _$SupabaseBootstrapModule();
    gh.lazySingleton<_i586.SupabaseEnvironmentConfig>(
      () => supabaseBootstrapModule.provideEnvironmentConfig(),
    );
    gh.lazySingleton<_i322.SupabaseAuthClientDriver>(
      () => supabaseBootstrapModule.provideAuthClientDriver(),
    );
    gh.lazySingleton<_i459.FeatureRouteHosts>(
      () => const _i459.FeatureRouteHosts(),
    );
    gh.lazySingleton<_i372.ShellStatusCubit>(() => _i372.ShellStatusCubit());
    gh.lazySingleton<_i165.ShellCubit>(() => _i165.ShellCubit());
    gh.lazySingleton<_i525.PendingWorkPresenceProvider>(
      () => const _i525.DefaultPendingWorkPresenceProvider(),
    );
    gh.lazySingleton<_i24.AppLogger>(() => _i24.RedactedAppLogger());
    gh.lazySingleton<_i99.RedactedBlocObserver>(
      () => _i99.RedactedBlocObserver(gh<_i24.AppLogger>()),
    );
    gh.lazySingleton<_i546.FeedbackCoordinator>(
      () => _i546.FeedbackCoordinator(gh<_i24.AppLogger>()),
    );
    gh.lazySingleton<_i654.AuthGateway>(
      () => _i322.SupabaseAuthGateway(
        gh<_i322.SupabaseAuthClientDriver>(),
        gh<_i586.SupabaseEnvironmentConfig>(),
        gh<_i24.AppLogger>(),
      ),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i525.AccountScopeLifecycle>(
      () => _i525.ShellAccountScopeLifecycle(
        gh<_i165.ShellCubit>(),
        gh<_i372.ShellStatusCubit>(),
        gh<_i546.FeedbackCoordinator>(),
      ),
    );
    gh.lazySingleton<_i947.AuthSessionCoordinator>(
      () => _i947.AuthSessionCoordinator(
        gh<_i654.AuthGateway>(),
        gh<_i525.PendingWorkPresenceProvider>(),
        gh<_i525.AccountScopeLifecycle>(),
        gh<_i372.ShellStatusCubit>(),
        gh<_i24.AppLogger>(),
      ),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i282.AppRouter>(
      () => _i282.AppRouter(gh<_i947.AuthSessionCoordinator>()),
    );
    gh.lazySingleton<_i731.AuthCubit>(
      () => _i731.AuthCubit(gh<_i947.AuthSessionCoordinator>()),
    );
    return this;
  }
}

class _$SupabaseBootstrapModule extends _i464.SupabaseBootstrapModule {}
