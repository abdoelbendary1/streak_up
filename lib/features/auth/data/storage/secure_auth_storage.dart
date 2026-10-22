import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:streak_up/app/config/supabase_config.dart';

/// Deliberately carries no platform error message or credential values.
class AuthStorageException implements Exception {
  const AuthStorageException();
  @override
  String toString() => 'AuthStorageException';
}

/// SDK-managed persistence: Android Keystore encryption and device-only iOS
/// Keychain. Storage errors latch until restart; never fall back to plaintext.
@lazySingleton
class SecureAuthStorage extends LocalStorage {
  @factoryMethod
  SecureAuthStorage.fromConfig()
    : this(
        sessionKey:
            'sb-${Uri.tryParse(SupabaseConfig.url)?.host.split(".").first ?? "streakup"}-auth-token',
      );
  SecureAuthStorage({
    required this.sessionKey,
    this.secureStorage = const FlutterSecureStorage(
      aOptions: AndroidOptions(resetOnError: false),
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.first_unlock_this_device,
      ),
    ),
  });

  final String sessionKey;
  final FlutterSecureStorage secureStorage;
  static const legacyPkceKey = 'supabase.auth.token-code-verifier';
  Future<void> _pending = Future<void>.value();
  bool _failed = false;
  String get _recoveryKey => '$sessionKey:recovery';

  GotrueAsyncStorage get pkceStorage => _SecurePkceStorage(this);

  Future<T> _run<T>(Future<T> Function() operation) {
    final result = Completer<T>();
    _pending = _pending.then((_) async {
      try {
        if (_failed) throw const AuthStorageException();
        result.complete(await operation());
      } catch (_) {
        _failed = true;
        result.completeError(const AuthStorageException());
      }
    });
    return result.future;
  }

  /// Supabase's asynchronous persistence listener catches hook exceptions.
  /// Consumers must await this before reporting an auth command as successful.
  Future<void> checkHealth() async {
    // Drain operations appended while an earlier operation was awaiting I/O.
    while (true) {
      final pending = _pending;
      await pending;
      if (identical(pending, _pending)) break;
    }
    if (_failed) throw const AuthStorageException();
  }

  @override
  Future<void> initialize() => _run(() async {
    // Browser storage cannot provide the approved native protection.
    if (kIsWeb) throw const AuthStorageException();
    final preferences = await SharedPreferences.getInstance();
    // Remove rather than trust previously unprotected credentials. This forces
    // reauthentication but leaves account-owned product data untouched.
    for (final key in [sessionKey, legacyPkceKey]) {
      if (preferences.containsKey(key)) {
        if (!await preferences.remove(key)) {
          throw const AuthStorageException();
        }
      }
    }
    await preferences.reload();
    if (preferences.containsKey(sessionKey) ||
        preferences.containsKey(legacyPkceKey)) {
      throw const AuthStorageException();
    }
    await secureStorage.read(key: sessionKey);
  });

  @override
  Future<String?> accessToken() => _run(
    () async => await secureStorage.read(key: _recoveryKey) != null
        ? null
        : secureStorage.read(key: sessionKey),
  );

  @override
  Future<bool> hasAccessToken() async => await accessToken() != null;

  @override
  Future<void> persistSession(String persistSessionString) => _run(
    () => secureStorage.write(key: sessionKey, value: persistSessionString),
  );

  /// SDK sessions do not serialize recovery purpose. This secure marker prevents
  /// interrupted recovery from being restored as ordinary protected access.
  Future<void> markRecovery() =>
      _run(() => secureStorage.write(key: _recoveryKey, value: '1'));
  Future<void> completeRecovery() => _delete(_recoveryKey);

  Future<void> _delete(String key) => _run(() async {
    await secureStorage.delete(key: key);
    if (await secureStorage.read(key: key) != null) {
      throw const AuthStorageException();
    }
  });

  @override
  Future<void> removePersistedSession() async {
    await _delete(sessionKey);
    await _delete(_recoveryKey);
  }

  String _pkceKey(String key) => '$sessionKey:$key';
}

/// The SDK requires a distinct PKCE hook type, sharing the same storage queue.
class _SecurePkceStorage extends GotrueAsyncStorage {
  _SecurePkceStorage(this.storage);
  final SecureAuthStorage storage;

  @override
  Future<String?> getItem({required String key}) => storage._run(
    () => storage.secureStorage.read(key: storage._pkceKey(key)),
  );

  @override
  Future<void> setItem({required String key, required String value}) =>
      storage._run(
        () => storage.secureStorage.write(
          key: storage._pkceKey(key),
          value: value,
        ),
      );

  @override
  Future<void> removeItem({required String key}) => storage._run(() async {
    final storedKey = storage._pkceKey(key);
    final verifier = await storage.secureStorage.read(key: storedKey);
    // GoTrue removes the verifier before publishing passwordRecovery. Persist
    // purpose here so a crash before delivery cannot admit a recovery session.
    if (verifier?.endsWith('/passwordRecovery') == true) {
      await storage.secureStorage.write(key: storage._recoveryKey, value: '1');
    }
    await storage.secureStorage.delete(key: storedKey);
    if (await storage.secureStorage.read(key: storedKey) != null) {
      throw const AuthStorageException();
    }
  });
}
