import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:streak_up/app/bootstrap/injection.config.dart';
import 'package:streak_up/app/bootstrap/redacted_bloc_observer.dart';
import 'package:streak_up/app/bootstrap/supabase_environment.dart';
import 'package:streak_up/app/bootstrap/app_logger.dart';
import 'package:streak_up/features/auth/data/supabase_auth_gateway.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Composition-root dependency container (`T004`, `T005`, `Architecture A-06`).
///
/// Only the bootstrap layer may access [GetIt]; widgets and business logic
/// receive dependencies through constructors or `Provider`/`BlocProvider`.
final GetIt _bootstrapServiceLocator = GetIt.asNewInstance();

bool _isSupabaseInitialized = false;

/// Bootstrap module providing environment configuration and the `supabase_flutter`
/// auth driver after `Supabase.initialize` has completed (`T004`).
@module
abstract class SupabaseBootstrapModule {
  @lazySingleton
  SupabaseEnvironmentConfig provideEnvironmentConfig() =>
      SupabaseEnvironmentConfig.fromDartDefines();

  @lazySingleton
  SupabaseAuthClientDriver provideAuthClientDriver() {
    if (_isSupabaseInitialized) {
      return GoTrueSupabaseAuthClientDriver(Supabase.instance.client.auth);
    }
    return _FallbackOfflineAuthClientDriver();
  }
}

/// Safe fallback driver used only when `configureDependencies(initializeSupabase: false)`
/// is invoked inside isolated unit/widget test environments without native platform channels.
class _FallbackOfflineAuthClientDriver implements SupabaseAuthClientDriver {
  final StreamController<RawProviderAuthEvent> _controller =
      StreamController<RawProviderAuthEvent>.broadcast();

  @override
  Stream<RawProviderAuthEvent> get onAuthStateChange => _controller.stream;

  @override
  RawProviderSessionSnapshot? get currentSession => null;

  @override
  Future<(RawProviderSessionSnapshot?, bool)> getSessionFromUrl(
    Uri callbackUri,
  ) async => (null, false);

  @override
  Future<RawProviderSessionSnapshot?> refreshOrFetchUser() async => null;

  @override
  Future<void> resendSignupVerification({
    required String email,
    required String emailRedirectTo,
  }) async {}

  @override
  Future<void> resetPasswordForEmail({
    required String email,
    required String redirectTo,
  }) async {}

  @override
  Future<RawProviderSessionSnapshot?> signInWithPassword({
    required String email,
    required String password,
  }) async => null;

  @override
  Future<void> signOut() async {}

  @override
  Future<RawProviderSessionSnapshot?> signUp({
    required String email,
    required String password,
    required String emailRedirectTo,
  }) async => null;

  @override
  Future<RawProviderSessionSnapshot?> updatePassword(
    String newPassword,
  ) async => null;
}

class _ResilientSupabaseLocalStorage extends LocalStorage {
  _ResilientSupabaseLocalStorage({required String persistSessionKey})
    : _delegate = SharedPreferencesLocalStorage(
        persistSessionKey: persistSessionKey,
      );

  final SharedPreferencesLocalStorage _delegate;
  bool _useMemoryFallback = false;
  String? _memorySession;

  @override
  Future<void> initialize() async {
    try {
      await _delegate.initialize();
    } catch (_) {
      _useMemoryFallback = true;
    }
  }

  @override
  Future<String?> accessToken() async {
    if (_useMemoryFallback) return _memorySession;
    try {
      return await _delegate.accessToken();
    } catch (_) {
      _useMemoryFallback = true;
      return _memorySession;
    }
  }

  @override
  Future<bool> hasAccessToken() async {
    if (_useMemoryFallback) return _memorySession != null;
    try {
      return await _delegate.hasAccessToken();
    } catch (_) {
      _useMemoryFallback = true;
      return _memorySession != null;
    }
  }

  @override
  Future<void> persistSession(String persistSessionString) async {
    _memorySession = persistSessionString;
    if (_useMemoryFallback) return;
    try {
      await _delegate.persistSession(persistSessionString);
    } catch (_) {
      _useMemoryFallback = true;
    }
  }

  @override
  Future<void> removePersistedSession() async {
    _memorySession = null;
    if (_useMemoryFallback) return;
    try {
      await _delegate.removePersistedSession();
    } catch (_) {
      _useMemoryFallback = true;
    }
  }
}

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<GetIt> configureDependencies({
  GetIt? instance,
  bool initializeSupabase = true,
  SupabaseEnvironmentConfig? environmentOverride,
}) async {
  final locator = instance ?? _bootstrapServiceLocator;
  await locator.reset();

  final envConfig =
      environmentOverride ?? SupabaseEnvironmentConfig.fromDartDefines();
  envConfig.validate();

  if (initializeSupabase && !_isSupabaseInitialized) {
    try {
      await Supabase.initialize(
        url: envConfig.supabaseUrl,
        // ignore: deprecated_member_use
        anonKey: envConfig.publishableAnonKey,
        authOptions: FlutterAuthClientOptions(
          detectSessionInUri: false,
          localStorage: _ResilientSupabaseLocalStorage(
            persistSessionKey:
                'sb-${Uri.parse(envConfig.supabaseUrl).host.split('.').first}-auth-token',
          ),
          pkceAsyncStorage: SharedPreferencesGotrueAsyncStorage(),
        ),
      );
      _isSupabaseInitialized = true;
    } catch (error) {
      _isSupabaseInitialized = false;
      RedactedAppLogger().error(
        'supabase.initialize.failed',
        metadata: <String, Object?>{'errorType': error.runtimeType.toString()},
      );
      rethrow;
    }
  }

  locator.init();
  Bloc.observer = locator<RedactedBlocObserver>();
  return locator;
}
