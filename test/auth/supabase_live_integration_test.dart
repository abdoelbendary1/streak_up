import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streak_up/app/config/supabase_config.dart';
import 'package:streak_up/core/logging/app_logger.dart';
import 'package:streak_up/features/auth/data/datasources/supabase_auth_data_source.dart';
import 'package:streak_up/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:streak_up/features/auth/data/storage/secure_auth_storage.dart';
import 'package:streak_up/features/auth/domain/models/auth_models.dart';
import 'package:streak_up/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class _LiveConfig {
  const _LiveConfig({required this.url, required this.key});
  final String url;
  final String key;
}

_LiveConfig? _resolveLiveEnvironmentConfig() {
  if (SupabaseConfig.url.isNotEmpty &&
      SupabaseConfig.publishableKey.isNotEmpty) {
    return const _LiveConfig(
      url: SupabaseConfig.url,
      key: SupabaseConfig.publishableKey,
    );
  }
  final envFile = File('.env.dev.json');
  if (envFile.existsSync()) {
    final decoded =
        jsonDecode(envFile.readAsStringSync()) as Map<String, dynamic>;
    final url = (decoded['SUPABASE_URL'] as String?) ?? '';
    final key = (decoded['SUPABASE_ANON_KEY'] as String?) ?? '';
    if (url.isNotEmpty && key.isNotEmpty) {
      return _LiveConfig(url: url, key: key);
    }
  }
  return null;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test(
    'live development backend: signed-out restoration, invalid credentials, recovery and sign-out',
    () async {
      if (!const bool.fromEnvironment('RUN_LIVE_AUTH')) {
        markTestSkipped('Explicit live-development verification only.');
        return;
      }
      final config = _resolveLiveEnvironmentConfig();
      if (config == null) {
        markTestSkipped('Isolated development configuration unavailable.');
        return;
      }
      // HTTP is live; native storage is mocked here and verified separately on Android.
      final previous = HttpOverrides.current;
      HttpOverrides.global = null;
      SharedPreferences.setMockInitialValues({});
      const channel = MethodChannel(
        'plugins.it_nomads.com/flutter_secure_storage',
      );
      final values = <String, String>{};
      final messenger =
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
      messenger.setMockMethodCallHandler(channel, (call) async {
        final arguments = Map<String, dynamic>.from(call.arguments as Map);
        final key = arguments['key'] as String;
        switch (call.method) {
          case 'read':
            return values[key];
          case 'write':
            values[key] = arguments['value'] as String;
            return null;
          case 'delete':
            values.remove(key);
            return null;
          default:
            throw const AuthStorageException();
        }
      });
      final storage = SecureAuthStorage(sessionKey: 'sl02-live-probe');
      await storage.initialize();
      final supabase = SupabaseClient(
        config.url,
        config.key,
        authOptions: FlutterAuthClientOptions(
          autoRefreshToken: false,
          localStorage: storage,
          pkceAsyncStorage: storage.pkceStorage,
        ),
      );
      final logger = AppLogger();
      final dataSource = SupabaseAuthDataSource(supabase, storage, logger);
      final backend = AuthRepositoryImpl(dataSource);
      final cubit = AuthCubit(backend);

      try {
        expect(await cubit.restore(), isTrue);
        expect(cubit.state.status, AuthStatus.signedOut);

        final signInSuccess = await cubit.signIn(
          email: 'sl02.nonexistent.probe@streakup.app',
          password: 'InvalidPassword!123',
        );
        expect(signInSuccess, isFalse);
        expect(cubit.state.failure, AuthFailure.invalidCredentials);

        for (final credentialsPath in [
          '.dart_tool/sl02_live_probe_credentials.json',
          '.dart_tool/sl02_live_probe_credentials_b.json',
        ]) {
          final credentialsFile = File(credentialsPath);
          if (credentialsFile.existsSync()) {
            // Disposable development credentials stay in ignored local storage.
            final credentials =
                jsonDecode(credentialsFile.readAsStringSync())
                    as Map<String, dynamic>;
            final admitted = await cubit.signIn(
              email: credentials['email'] as String,
              password: credentials['password'] as String,
            );
            expect(admitted, isTrue);
            expect(cubit.state.canAccessProtected, isTrue);
            expect(await cubit.restore(), isTrue);
            expect(cubit.state.canAccessProtected, isTrue);
            expect(await cubit.signOut(), isTrue);
            expect(cubit.state.canAccessProtected, isFalse);
            expect(values.isEmpty, isTrue);
          }
        }

        final recovery = await cubit.requestPasswordRecovery(
          'sl02.nonexistent.probe@streakup.app',
        );
        expect(
          recovery || cubit.state.failure == AuthFailure.rateLimited,
          isTrue,
        );
        expect(await cubit.signOut(), isTrue);
        expect(values.isEmpty, isTrue);
      } finally {
        await cubit.close();
        supabase.dispose();
        HttpOverrides.global = previous;
      }
    },
  );
}
