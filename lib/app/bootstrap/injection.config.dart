// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;

import '../../core/logging/app_bloc_observer.dart' as _i759;
import '../../core/logging/app_logger.dart' as _i465;
import '../../core/network/network_module.dart' as _i234;
import '../../features/auth/data/repositories/supabase_auth_repository.dart'
    as _i487;
import '../../features/auth/data/storage/secure_auth_storage.dart' as _i881;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/domain/use_cases/auth_use_cases.dart' as _i336;
import '../../features/auth/domain/use_cases/check_verification_use_case.dart'
    as _i373;
import '../../features/auth/domain/use_cases/get_current_session_use_case.dart'
    as _i761;
import '../../features/auth/domain/use_cases/register_use_case.dart' as _i1010;
import '../../features/auth/domain/use_cases/request_password_recovery_use_case.dart'
    as _i921;
import '../../features/auth/domain/use_cases/resend_verification_email_use_case.dart'
    as _i941;
import '../../features/auth/domain/use_cases/restore_session_use_case.dart'
    as _i809;
import '../../features/auth/domain/use_cases/sign_in_use_case.dart' as _i926;
import '../../features/auth/domain/use_cases/sign_out_use_case.dart' as _i131;
import '../../features/auth/domain/use_cases/submit_new_password_use_case.dart'
    as _i652;
import '../../features/auth/domain/use_cases/watch_auth_events_use_case.dart'
    as _i1066;
import '../../features/auth/presentation/cubit/auth_cubit.dart' as _i117;
import '../../features/shell/presentation/cubit/shell_cubit.dart' as _i68;
import '../routing/app_router.dart' as _i282;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final networkModule = _$NetworkModule();
    gh.lazySingleton<_i465.AppLogger>(() => _i465.AppLogger.injectable());
    gh.lazySingleton<_i454.SupabaseClient>(() => networkModule.supabaseClient);
    gh.lazySingleton<_i881.SecureAuthStorage>(
      () => _i881.SecureAuthStorage.fromConfig(),
    );
    gh.lazySingleton<_i68.ShellCubit>(
      () => _i68.ShellCubit(),
      dispose: (i) => i.close(),
    );
    gh.lazySingleton<_i787.AuthRepository>(
      () => _i487.SupabaseAuthRepository(
        gh<_i454.SupabaseClient>(),
        gh<_i881.SecureAuthStorage>(),
        gh<_i465.AppLogger>(),
      ),
    );
    gh.lazySingleton<_i373.CheckVerificationUseCase>(
      () => _i373.CheckVerificationUseCase(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i761.GetCurrentSessionUseCase>(
      () => _i761.GetCurrentSessionUseCase(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i1010.RegisterUseCase>(
      () => _i1010.RegisterUseCase(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i921.RequestPasswordRecoveryUseCase>(
      () => _i921.RequestPasswordRecoveryUseCase(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i941.ResendVerificationEmailUseCase>(
      () => _i941.ResendVerificationEmailUseCase(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i809.RestoreSessionUseCase>(
      () => _i809.RestoreSessionUseCase(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i926.SignInUseCase>(
      () => _i926.SignInUseCase(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i131.SignOutUseCase>(
      () => _i131.SignOutUseCase(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i652.SubmitNewPasswordUseCase>(
      () => _i652.SubmitNewPasswordUseCase(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i1066.WatchAuthEventsUseCase>(
      () => _i1066.WatchAuthEventsUseCase(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i759.AppBlocObserver>(
      () => _i759.AppBlocObserver(gh<_i465.AppLogger>()),
    );
    gh.lazySingleton<_i361.Dio>(
      () => networkModule.supabaseRestDio(
        gh<_i454.SupabaseClient>(),
        gh<_i465.AppLogger>(),
      ),
      instanceName: 'supabaseRestDio',
      dispose: _i234.closeRestDio,
    );
    gh.lazySingleton<_i361.Dio>(
      () => networkModule.supabaseEdgeDio(
        gh<_i454.SupabaseClient>(),
        gh<_i465.AppLogger>(),
      ),
      instanceName: 'supabaseEdgeDio',
      dispose: _i234.closeRestDio,
    );
    gh.lazySingleton<_i117.AuthCubit>(
      () => _i117.AuthCubit(
        watchAuthEventsUseCase: gh<_i336.WatchAuthEventsUseCase>(),
        getCurrentSessionUseCase: gh<_i336.GetCurrentSessionUseCase>(),
        restoreSessionUseCase: gh<_i336.RestoreSessionUseCase>(),
        signInUseCase: gh<_i336.SignInUseCase>(),
        registerUseCase: gh<_i336.RegisterUseCase>(),
        requestPasswordRecoveryUseCase:
            gh<_i336.RequestPasswordRecoveryUseCase>(),
        resendVerificationEmailUseCase:
            gh<_i336.ResendVerificationEmailUseCase>(),
        checkVerificationUseCase: gh<_i336.CheckVerificationUseCase>(),
        submitNewPasswordUseCase: gh<_i336.SubmitNewPasswordUseCase>(),
        signOutUseCase: gh<_i336.SignOutUseCase>(),
      ),
      dispose: (i) => i.close(),
    );
    gh.lazySingleton<_i282.AppRouter>(
      () => _i282.AppRouter.create(gh<_i117.AuthCubit>()),
      dispose: (i) => i.dispose(),
    );
    return this;
  }
}

class _$NetworkModule extends _i234.NetworkModule {}
