import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streak_up/app/config/supabase_config.dart';
import 'package:streak_up/core/logging/app_logger.dart';
import 'package:streak_up/features/auth/data/repositories/supabase_auth_repository.dart';
import 'package:streak_up/features/auth/data/storage/secure_auth_storage.dart';
import 'package:streak_up/features/auth/domain/entities/auth_session.dart';
import 'package:streak_up/features/auth/domain/events/auth_event.dart';
import 'package:streak_up/features/auth/domain/failures/auth_failure.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class _LiveConfig {
  const _LiveConfig({required this.url, required this.key});
  final String url;
  final String key;
}

class _TestCredentials {
  const _TestCredentials({required this.email, required this.password});
  final String email;
  final String password;
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

_TestCredentials? _resolveTestCredentials() {
  for (final path in [
    '.dart_tool/sl02_live_probe_credentials.json',
    '.dart_tool/sl02_live_probe_credentials_b.json',
  ]) {
    final file = File(path);
    if (file.existsSync()) {
      final decoded =
          jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      final email = decoded['email'] as String?;
      final password = decoded['password'] as String?;
      if (email != null &&
          email.isNotEmpty &&
          password != null &&
          password.isNotEmpty) {
        return _TestCredentials(email: email, password: password);
      }
    }
  }
  return null;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final config = _resolveLiveEnvironmentConfig();
  final credentials = _resolveTestCredentials();

  final isConfigured = config != null && credentials != null;

  group(
    'SupabaseAuthRepository live integration tests',
    skip: !isConfigured
        ? 'Live test backend configuration or test credentials unavailable in .env.dev.json / .dart_tool.'
        : false,
    () {
      late HttpOverrides? previousHttpOverrides;
      late SecureAuthStorage storage;
      late SupabaseClient supabase;
      late SupabaseAuthRepository repository;

      setUp(() async {
        previousHttpOverrides = HttpOverrides.current;
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

        storage = SecureAuthStorage(sessionKey: 'sl02-live-repo-probe');
        await storage.initialize();

        supabase = SupabaseClient(
          config!.url,
          config.key,
          authOptions: FlutterAuthClientOptions(
            autoRefreshToken: false,
            localStorage: storage,
            pkceAsyncStorage: storage.pkceStorage,
          ),
        );

        final logger = AppLogger();
        repository = SupabaseAuthRepository(supabase, storage, logger);

        // Ensure clean initial state
        await repository.signOut();
      });

      tearDown(() async {
        try {
          await repository.signOut();
        } catch (_) {}
        supabase.dispose();
        HttpOverrides.global = previousHttpOverrides;
      });

      test(
        'signIn valid: returns domain AuthSession with valid access evidence',
        () async {
          final result = await repository.signIn(
            email: credentials!.email,
            password: credentials.password,
          );

          expect(result.isRight(), isTrue);

          final session = result.fold(
            (failure) => throw StateError('Expected Right but got $failure'),
            (session) => session,
          );

          expect(session, isA<AuthSession>());
          expect(session.userId, isNotEmpty);
          expect(session.email, equals(credentials.email));
          expect(session.expiresAt, isNotNull);
          expect(session.accessTokenValid, isTrue);
        },
      );

      test(
        'signIn invalid: returns Left(AuthFailure.invalidCredentials) without leaking SDK exception',
        () async {
          final result = await repository.signIn(
            email: 'sl02.nonexistent.probe@streakup.app',
            password: 'DeliberatelyInvalidPassword!123',
          );

          expect(result.isLeft(), isTrue);

          final failure = result.fold(
            (failure) => failure,
            (_) => throw StateError('Expected Left but got Right'),
          );

          expect(failure, equals(AuthFailure.invalidCredentials));
        },
      );

      test(
        'currentSession: exposes domain AuthSession after sign in',
        () async {
          final signInResult = await repository.signIn(
            email: credentials!.email,
            password: credentials.password,
          );
          expect(signInResult.isRight(), isTrue);

          final session = repository.currentSession;

          expect(session, isNotNull);
          expect(session, isA<AuthSession>());
          expect(session!.userId, isNotEmpty);
          expect(session.email, equals(credentials.email));
          expect(session.accessTokenValid, isTrue);
        },
      );

      test('signOut: clears currentSession and returns Right(unit)', () async {
        final signInResult = await repository.signIn(
          email: credentials!.email,
          password: credentials.password,
        );
        expect(signInResult.isRight(), isTrue);
        expect(repository.currentSession, isNotNull);

        final signOutResult = await repository.signOut();

        expect(signOutResult.isRight(), isTrue);
        expect(repository.currentSession, isNull);
      });

      test(
        'auth events: emits domain AuthEvent with AuthEventKind.signedIn',
        () async {
          final events = <AuthEvent>[];
          final subscription = repository.events.listen(events.add);

          try {
            final signInResult = await repository.signIn(
              email: credentials!.email,
              password: credentials.password,
            );
            expect(signInResult.isRight(), isTrue);

            // Give a short grace period for stream event delivery
            await Future<void>.delayed(const Duration(milliseconds: 300));

            expect(events, isNotEmpty);
            final signedInEvent = events.firstWhere(
              (e) => e.kind == AuthEventKind.signedIn,
              orElse: () => throw StateError(
                'No signedIn event was emitted in events: $events',
              ),
            );

            expect(signedInEvent, isA<AuthEvent>());
            expect(signedInEvent.session, isNotNull);
            expect(signedInEvent.session!.email, equals(credentials.email));
            expect(signedInEvent.failure, isNull);
          } finally {
            await subscription.cancel();
          }
        },
      );
    },
  );
}
