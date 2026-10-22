import 'package:streak_up/features/auth/data/datasources/supabase_auth_data_source.dart';
import 'dart:async';
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';
import 'package:streak_up/core/logging/app_logger.dart';
import 'package:streak_up/features/auth/domain/models/auth_models.dart';
import 'package:streak_up/features/auth/data/storage/secure_auth_storage.dart';
import 'package:streak_up/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

extension _EitherX<L, R> on Either<L, R> {
  R get asRight => fold(
    (l) => throw AssertionError('Expected Right but got Left($l)'),
    (r) => r,
  );
  L get asLeft => fold(
    (l) => l,
    (r) => throw AssertionError('Expected Left but got Right($r)'),
  );
}

class _RemovalFailingPreferences extends InMemorySharedPreferencesStore {
  _RemovalFailingPreferences()
    : super.withData({'flutter.sb-test-auth-token': 'legacy-session'});
  @override
  Future<bool> remove(String key) async => false;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const secureChannel = MethodChannel(
    'plugins.it_nomads.com/flutter_secure_storage',
  );
  const sessionKey = 'sb-test-auth-token';
  const testUrl = 'https://test.supabase.co';
  const testKey = 'sb_publishable_test';
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  late Map<String, String> secureValues;
  var sessionWrites = 0;
  var sessionDeletes = 0;
  late SecureAuthStorage storage;
  late SupabaseClient supabase;
  late GoTrueClient auth;
  late AuthRepositoryImpl backend;
  late Map<String, dynamic> response;
  late int status;
  String? failStorageMethod;
  bool failNetwork = false;
  bool passwordUpdateSent = false;
  bool ignoreDeletion = false;
  bool initializedSupabase = false;
  Completer<void>? delayedWrite;
  Completer<void>? writeStarted;

  Map<String, dynamic> user({bool verified = true}) => {
    'id': '00000000-0000-0000-0000-000000000001',
    'aud': 'authenticated',
    'role': 'authenticated',
    'email': 'account@example.com',
    'email_confirmed_at': verified ? '2026-09-29T12:00:00Z' : null,
    'app_metadata': <String, dynamic>{},
    'user_metadata': <String, dynamic>{},
    'created_at': '2026-09-29T12:00:00Z',
  };

  Map<String, dynamic> session({int? expiresAt}) => {
    'access_token':
        '${base64Url.encode(utf8.encode('{}'))}.${base64Url.encode(utf8.encode(jsonEncode({'exp': expiresAt ?? DateTime.now().millisecondsSinceEpoch ~/ 1000 + 3600})))}.test',
    'refresh_token': 'test-refresh-token',
    'expires_in': 3600,
    'token_type': 'bearer',
    'user': user(),
  };

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    secureValues = {};
    sessionWrites = 0;
    sessionDeletes = 0;
    failStorageMethod = null;
    failNetwork = false;
    passwordUpdateSent = false;
    ignoreDeletion = false;
    initializedSupabase = false;
    delayedWrite = null;
    writeStarted = null;
    status = 200;
    response = session();
    messenger.setMockMethodCallHandler(secureChannel, (call) async {
      if (call.method == 'write' && delayedWrite != null) {
        if (writeStarted?.isCompleted == false) writeStarted!.complete();
        await delayedWrite!.future;
      }
      if (call.method == failStorageMethod) {
        throw PlatformException(code: 'storage-unavailable');
      }
      final args = Map<String, dynamic>.from(call.arguments as Map);
      final key = args['key'] as String;
      if (key == sessionKey && call.method == 'write') sessionWrites++;
      if (key == sessionKey && call.method == 'delete') sessionDeletes++;
      switch (call.method) {
        case 'read':
          return secureValues[key];
        case 'write':
          secureValues[key] = args['value'] as String;
          return null;
        case 'delete':
          if (!ignoreDeletion) secureValues.remove(key);
          return null;
        default:
          throw StateError('Unexpected storage call');
      }
    });
    storage = SecureAuthStorage(sessionKey: sessionKey);
    await storage.initialize();
    supabase = SupabaseClient(
      testUrl,
      testKey,
      authOptions: FlutterAuthClientOptions(
        autoRefreshToken: false,
        localStorage: storage,
        pkceAsyncStorage: storage.pkceStorage,
      ),
      httpClient: MockClient((request) async {
        if (request.method == 'PUT' && request.url.path.endsWith('/user')) {
          passwordUpdateSent =
              jsonDecode(request.body)['password'] == 'fixture-password';
        }
        if (failNetwork) throw http.ClientException('offline');
        return http.Response(
          jsonEncode(response),
          status,
          headers: {
            'content-type': 'application/json',
            'x-supabase-api-version': '2024-01-01',
          },
        );
      }),
    );
    auth = supabase.auth;
    backend = AuthRepositoryImpl(
      SupabaseAuthDataSource(supabase, storage, AppLogger()),
    );
  });

  tearDown(() async {
    supabase.dispose();
    if (initializedSupabase) await Supabase.instance.dispose();
    messenger.setMockMethodCallHandler(secureChannel, null);
    SharedPreferences.setMockInitialValues({});
  });

  Future<Either<AuthFailure, AuthSessionEvidence>> signIn() =>
      backend.signIn(email: 'account@example.com', password: 'test-password');

  Future<void> callback({bool recovery = false}) async {
    await signIn();
  }

  test('email-only operations leave persisted session unchanged', () async {
    await signIn();
    final saved = secureValues[sessionKey];
    final writes = sessionWrites;
    final deletes = sessionDeletes;
    response = {};
    expect(
      (await backend.resendVerificationEmail('account@example.com')).isRight(),
      isTrue,
    );
    expect(
      (await backend.requestPasswordRecovery('account@example.com')).isRight(),
      isTrue,
    );
    expect(secureValues[sessionKey], saved);
    expect(sessionWrites, writes);
    expect(sessionDeletes, deletes);
  });
  test('valid verified SDK session establishes account evidence', () async {
    final result = await signIn();
    expect(result.isRight(), isTrue);
    expect(result.asRight.id, user()['id']);
  });

  test('verified user without an established session cannot sign in', () async {
    response = user();
    final result = await signIn();
    expect(result.asLeft, AuthFailure.sessionMissing);
    expect(auth.currentSession, isNull);
  });

  test(
    'registration without a session remains verification required',
    () async {
      response = user();
      final result = await backend.register(
        email: 'account@example.com',
        password: 'test-password',
      );
      expect(result.asRight.account, isNull);
      expect(auth.currentSession, isNull);
    },
  );

  test(
    'unverified session never supplies authenticated account evidence',
    () async {
      response['user'] = user(verified: false);
      final result = (await signIn()).asRight;
      expect(result.emailVerified, isFalse);
      expect(result.account, isNull);
      expect(auth.currentSession, isNotNull);
    },
  );

  test('invalid credentials map to a sanitized failure', () async {
    status = 400;
    response = {
      'code': 'invalid_credentials',
      'msg': 'Invalid login credentials',
    };
    expect((await signIn()).asLeft, AuthFailure.invalidCredentials);
  });

  test('network error does not become a signed-out result', () async {
    failNetwork = true;
    expect((await signIn()).asLeft, AuthFailure.network);
  });

  test(
    'restores SDK-established session without duplicate session ownership',
    () async {
      await auth.setInitialSession(jsonEncode(response));
      final result = await backend.restoreSession();
      expect(result.asRight?.id, user()['id']);
    },
  );

  test('missing SDK session restores signed out', () async {
    expect((await backend.restoreSession()).asRight, isNull);
  });

  test('expired restored session requires SDK refresh', () async {
    await auth.setInitialSession(jsonEncode(session(expiresAt: 1)));
    final result = await backend.restoreSession();
    expect(result.asRight?.id, user()['id']);
  });

  Future<AuthRepositoryImpl> sdkManagedBackend() async {
    final supabase = await Supabase.initialize(
      url: testUrl,
      // ignore: deprecated_member_use
      anonKey: testKey,
      debug: false,
      httpClient: MockClient(
        (_) async => http.Response(jsonEncode(response), 200),
      ),
      authOptions: FlutterAuthClientOptions(
        autoRefreshToken: false,
        detectSessionInUri: false,
        localStorage: storage,
        pkceAsyncStorage: storage.pkceStorage,
      ),
    );
    initializedSupabase = true;
    return AuthRepositoryImpl(
      SupabaseAuthDataSource(supabase.client, storage, AppLogger()),
    );
  }

  test('SDK-caught persistence failure remains visible to backend', () async {
    final sdkBackend = await sdkManagedBackend();
    failStorageMethod = 'write';
    final result = await sdkBackend.signIn(
      email: 'account@example.com',
      password: 'test-password',
    );
    expect(result.asLeft, AuthFailure.storage);
  });

  test(
    'installed Flutter SDK persists and removes the session through secure hooks',
    () async {
      final sdkBackend = await sdkManagedBackend();
      expect(
        (await sdkBackend.signIn(
          email: 'account@example.com',
          password: 'test-password',
        )).isRight(),
        isTrue,
      );
      final persisted = jsonDecode((await storage.accessToken())!) as Map;
      expect((persisted['user'] as Map)['id'], user()['id']);
      expect((await sdkBackend.signOut()).isRight(), isTrue);
      expect(await storage.accessToken(), isNull);
    },
  );

  test(
    'session and PKCE hooks persist exclusively in secure storage',
    () async {
      await storage.persistSession('test-session');
      await storage.pkceStorage.setItem(
        key: SecureAuthStorage.legacyPkceKey,
        value: 'test-verifier',
      );
      expect(await storage.accessToken(), 'test-session');
      expect(
        await storage.pkceStorage.getItem(key: SecureAuthStorage.legacyPkceKey),
        'test-verifier',
      );
      final preferences = await SharedPreferences.getInstance();
      expect(preferences.getKeys(), isEmpty);
      await storage.removePersistedSession();
      await storage.pkceStorage.removeItem(
        key: SecureAuthStorage.legacyPkceKey,
      );
      expect(secureValues, isEmpty);
    },
  );

  test(
    'removes legacy plaintext credentials and preserves unrelated data',
    () async {
      SharedPreferences.setMockInitialValues({
        sessionKey: 'legacy-session',
        SecureAuthStorage.legacyPkceKey: 'legacy-verifier',
        'locale': 'ar',
      });
      secureValues[sessionKey] = 'existing-secure-session';
      await storage.initialize();
      final preferences = await SharedPreferences.getInstance();
      expect(preferences.getKeys(), {'locale'});
      expect(await storage.accessToken(), 'existing-secure-session');
    },
  );

  test('legacy credential removal failure prevents initialization', () async {
    SharedPreferences.setMockInitialValues({sessionKey: 'legacy-session'});
    SharedPreferencesStorePlatform.instance = _RemovalFailingPreferences();
    await expectLater(
      storage.initialize(),
      throwsA(isA<AuthStorageException>()),
    );
    expect((await backend.restoreSession()).asLeft, AuthFailure.storage);
  });

  test('secure initialization read failure fails closed', () async {
    failStorageMethod = 'read';
    await expectLater(
      storage.initialize(),
      throwsA(isA<AuthStorageException>()),
    );
  });

  test('deletion returning without removing credentials is detected', () async {
    await storage.persistSession('test-session');
    ignoreDeletion = true;
    await expectLater(
      storage.removePersistedSession(),
      throwsA(isA<AuthStorageException>()),
    );
    expect(secureValues[sessionKey], 'test-session');
  });

  test(
    'offline expired restoration preserves SDK evidence and returns network failure',
    () async {
      await auth.setInitialSession(jsonEncode(session(expiresAt: 1)));
      failNetwork = true;
      expect((await backend.restoreSession()).asLeft, AuthFailure.network);
      expect(auth.currentSession?.user.id, user()['id']);
    },
  );

  test(
    'restoration distinguishes an established unverified session from absence',
    () async {
      response['user'] = user(verified: false);
      await auth.setInitialSession(jsonEncode(response));
      final result = (await backend.restoreSession()).asRight;
      expect(result, isNotNull);
      expect(result!.emailVerified, isFalse);
      expect(result.account, isNull);
    },
  );

  test(
    'command does not complete while explicit secure persistence is delayed',
    () async {
      delayedWrite = Completer<void>();
      writeStarted = Completer<void>();
      var completed = false;
      final operation = signIn().then((result) {
        completed = true;
        return result;
      });
      await writeStarted!.future;
      expect(completed, isFalse);
      delayedWrite!.complete();
      expect((await operation).isRight(), isTrue);
      expect(secureValues[sessionKey], isNotNull);
    },
  );

  test(
    'delayed storage failure is returned instead of successful authentication',
    () async {
      delayedWrite = Completer<void>();
      writeStarted = Completer<void>();
      failStorageMethod = 'write';
      final operation = signIn();
      await writeStarted!.future;
      delayedWrite!.complete();
      expect((await operation).asLeft, AuthFailure.storage);
    },
  );

  test('secure read failure prevents restoration', () async {
    failStorageMethod = 'read';
    await expectLater(
      storage.accessToken(),
      throwsA(isA<AuthStorageException>()),
    );
    expect((await backend.restoreSession()).asLeft, AuthFailure.storage);
  });

  test('secure deletion failure cannot report successful sign out', () async {
    await signIn();
    failStorageMethod = 'delete';
    expect((await backend.signOut()).asLeft, AuthFailure.storage);
  });

  test('sign out removes secure session and PKCE credentials', () async {
    await signIn();
    await storage.persistSession('test-session');
    await storage.pkceStorage.setItem(
      key: SecureAuthStorage.legacyPkceKey,
      value: 'test-verifier',
    );
    expect((await backend.signOut()).isRight(), isTrue);
    expect(auth.currentSession, isNull);
    expect(secureValues, isEmpty);
  });
  test(
    'health drain includes failing operations appended during delayed I/O',
    () async {
      delayedWrite = Completer<void>();
      writeStarted = Completer<void>();
      final write = storage.persistSession('test-session');
      await writeStarted!.future;
      final health = storage.checkHealth();
      final healthFailure = expectLater(
        health,
        throwsA(isA<AuthStorageException>()),
      );
      failStorageMethod = 'delete';
      final removal = expectLater(
        storage.removePersistedSession(),
        throwsA(isA<AuthStorageException>()),
      );
      delayedWrite!.complete();
      await write;
      await removal;
      await healthFailure;
    },
  );
  test(
    'recovery credentials cannot restore as ordinary access after restart',
    () async {
      await signIn();
      await storage.markRecovery();
      await storage.checkHealth();
      expect(await storage.hasAccessToken(), isFalse);
      // A delayed SDK persistence notification cannot recreate recovery credentials.
      await storage.persistSession(jsonEncode(auth.currentSession!.toJson()));
      final reopened = SecureAuthStorage(sessionKey: sessionKey);
      await reopened.initialize();
      expect(await reopened.hasAccessToken(), isFalse);
      response = user();
      expect(
        (await backend.submitNewPassword('fixture-password')).isRight(),
        isTrue,
      );
      expect(await storage.hasAccessToken(), isTrue);
    },
  );

  test(
    'password reset uses SDK updateUser and preserves SDK-managed evidence',
    () async {
      await signIn();
      await storage.markRecovery();
      response = user();
      expect(
        (await backend.submitNewPassword('fixture-password')).isRight(),
        isTrue,
      );
      expect(passwordUpdateSent, isTrue);
      expect(backend.currentSession?.account, isNotNull);
    },
  );

  test(
    'password update without an SDK session fails before a request',
    () async {
      final result = await backend.submitNewPassword('fixture-password');
      expect(result.asLeft, AuthFailure.sessionMissing);
      expect(passwordUpdateSent, isFalse);
    },
  );

  test('SDK weak password rejection is presentation safe', () async {
    await callback(recovery: true);
    status = 422;
    response = {'code': 'weak_password', 'msg': 'Rejected'};
    final result = await backend.submitNewPassword('fixture-password');
    expect(result.asLeft, AuthFailure.weakPassword);
  });

  test('expired SDK session cannot submit a password update', () async {
    await callback(recovery: true);
    response = session(
      expiresAt: DateTime.now().millisecondsSinceEpoch ~/ 1000 - 60,
    );
    await signIn();
    final result = await backend.submitNewPassword('fixture-password');
    expect(result.asLeft, AuthFailure.sessionMissing);
    expect(passwordUpdateSent, isFalse);
  });

  test(
    'SDK network failure during update returns only a safe failure',
    () async {
      await callback(recovery: true);
      failNetwork = true;
      final result = await backend.submitNewPassword('fixture-password');
      expect(result.asLeft, AuthFailure.network);
    },
  );

  test(
    'storage failure after password update cannot report completion',
    () async {
      await callback(recovery: true);
      response = user();
      failStorageMethod = 'write';
      final result = await backend.submitNewPassword('fixture-password');
      expect(passwordUpdateSent, isTrue);
      expect(result.asLeft, AuthFailure.storage);
    },
  );

  test('password update waits for secure persistence', () async {
    await callback(recovery: true);
    response = user();
    delayedWrite = Completer<void>();
    writeStarted = Completer<void>();
    var completed = false;
    final resetting = backend.submitNewPassword('fixture-password').then((
      result,
    ) {
      completed = true;
      return result;
    });
    await writeStarted!.future;
    expect(completed, isFalse);
    delayedWrite!.complete();
    expect((await resetting).isRight(), isTrue);
  });

  test('password update never trusts a foreign user response', () async {
    await callback(recovery: true);
    response = user()..['id'] = '00000000-0000-0000-0000-000000000002';
    final result = await backend.submitNewPassword('fixture-password');
    expect(result.asLeft, AuthFailure.sessionMissing);
  });
  test(
    'SDK identity changing during storage wait cannot update another account',
    () async {
      await callback(recovery: true);
      delayedWrite = Completer<void>();
      writeStarted = Completer<void>();
      final pendingStorage = storage.pkceStorage.setItem(
        key: SecureAuthStorage.legacyPkceKey,
        value: 'fixture-persistence',
      );
      await writeStarted!.future;
      final resetting = backend.submitNewPassword('fixture-password');
      response = session();
      response['user'] = user()
        ..['id'] = '00000000-0000-0000-0000-000000000002';
      await auth.signInWithPassword(
        email: 'other@example.com',
        password: 'fixture-password',
      );
      delayedWrite!.complete();
      await pendingStorage;
      expect((await resetting).isLeft(), isTrue);
      expect(passwordUpdateSent, isFalse);
    },
  );

  test(
    'recovery email uses SDK and unknown-account responses remain generic',
    () async {
      response = {};
      expect(
        (await backend.requestPasswordRecovery(
          'fixture@example.com',
        )).isRight(),
        isTrue,
      );
      status = 400;
      response = {'code': 'user_not_found', 'msg': 'Not found'};
      expect(
        (await backend.requestPasswordRecovery(
          'unknown@example.com',
        )).isRight(),
        isTrue,
      );
    },
  );
  test(
    'email-operation failures remain typed without leaking account details',
    () async {
      failNetwork = true;
      final result = await backend.requestPasswordRecovery(
        'fixture@example.com',
      );
      expect(result.asLeft, AuthFailure.network);
    },
  );
  test('verification resend and refresh use SDK session evidence', () async {
    response = {};
    expect(
      (await backend.resendVerificationEmail('fixture@example.com')).isRight(),
      isTrue,
    );
    expect((await backend.checkVerification()).asRight, isNull);
    response = session();
    await signIn();
    expect((await backend.checkVerification()).asRight?.account, isNotNull);
  });
}
