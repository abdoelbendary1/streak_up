import 'dart:convert';
import 'package:flutter/foundation.dart';

/// Supported deployment environments (`T002`, `Architecture A-07`).
enum SupabaseEnvironment { dev, staging, prod }

/// Environment-specific Supabase client configuration (`T002`, `SL02-FR-001`–`005`).
///
/// Only public project URLs and publishable/anon keys are permitted in client builds.
/// Service-role keys and backend secrets are rejected at validation time.
@immutable
class SupabaseEnvironmentConfig {
  const SupabaseEnvironmentConfig({
    required this.environment,
    required this.supabaseUrl,
    required this.publishableAnonKey,
    this.authRedirectUri = defaultDeepLinkCallbackUri,
    this.allowedRedirectOrigins = defaultAllowedRedirectOrigins,
  });

  static const String defaultDeepLinkCallbackUri =
      'io.streakup.app://auth-callback';

  static const Set<String> defaultAllowedRedirectOrigins = <String>{
    'io.streakup.app://auth-callback',
    'streakup://auth-callback',
  };

  /// Resolves the active environment configuration from `--dart-define` values.
  factory SupabaseEnvironmentConfig.fromDartDefines({
    String? envOverride,
    String? urlOverride,
    String? anonKeyOverride,
    String? redirectUriOverride,
  }) {
    const definedEnv = String.fromEnvironment(
      'STREAKUP_ENV',
      defaultValue: 'dev',
    );
    const definedUrl = String.fromEnvironment('SUPABASE_URL');
    const definedAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
    const definedRedirect = String.fromEnvironment(
      'SUPABASE_AUTH_REDIRECT_URL',
      defaultValue: defaultDeepLinkCallbackUri,
    );

    const devUrl = String.fromEnvironment(
      'SUPABASE_DEV_URL',
      defaultValue: 'https://dev-project.supabase.co',
    );
    const devAnonKey = String.fromEnvironment(
      'SUPABASE_DEV_ANON_KEY',
      defaultValue: 'sb_publishable_dev_anon_key_placeholder',
    );
    const stagingUrl = String.fromEnvironment(
      'SUPABASE_STAGING_URL',
      defaultValue: 'https://staging-project.supabase.co',
    );
    const stagingAnonKey = String.fromEnvironment(
      'SUPABASE_STAGING_ANON_KEY',
      defaultValue: 'sb_publishable_staging_anon_key_placeholder',
    );
    const prodUrl = String.fromEnvironment(
      'SUPABASE_PROD_URL',
      defaultValue: 'https://prod-project.supabase.co',
    );
    const prodAnonKey = String.fromEnvironment(
      'SUPABASE_PROD_ANON_KEY',
      defaultValue: 'sb_publishable_prod_anon_key_placeholder',
    );

    final environment = _parseEnvironment(envOverride ?? definedEnv);

    final resolvedUrl = (urlOverride ?? definedUrl).trim().isNotEmpty
        ? (urlOverride ?? definedUrl).trim()
        : switch (environment) {
            SupabaseEnvironment.dev => devUrl,
            SupabaseEnvironment.staging => stagingUrl,
            SupabaseEnvironment.prod => prodUrl,
          };

    final resolvedKey = (anonKeyOverride ?? definedAnonKey).trim().isNotEmpty
        ? (anonKeyOverride ?? definedAnonKey).trim()
        : switch (environment) {
            SupabaseEnvironment.dev => devAnonKey,
            SupabaseEnvironment.staging => stagingAnonKey,
            SupabaseEnvironment.prod => prodAnonKey,
          };

    final resolvedRedirect = (redirectUriOverride ?? definedRedirect).trim();

    final config = SupabaseEnvironmentConfig(
      environment: environment,
      supabaseUrl: resolvedUrl,
      publishableAnonKey: resolvedKey,
      authRedirectUri: resolvedRedirect.isEmpty
          ? defaultDeepLinkCallbackUri
          : resolvedRedirect,
    );
    config.validate();
    return config;
  }

  final SupabaseEnvironment environment;
  final String supabaseUrl;
  final String publishableAnonKey;
  final String authRedirectUri;
  final Set<String> allowedRedirectOrigins;

  /// Validates that the configuration contains a safe URL and publishable/anon key,
  /// and strictly rejects any service-role secret (`Architecture A-07`).
  void validate() {
    final uri = Uri.tryParse(supabaseUrl);
    if (uri == null ||
        uri.host.isEmpty ||
        (!uri.isScheme('https') && !uri.isScheme('http'))) {
      throw StateError('Invalid Supabase project URL configuration.');
    }

    if (environment != SupabaseEnvironment.dev && !uri.isScheme('https')) {
      throw StateError('Staging and production Supabase URLs must use HTTPS.');
    }

    if (publishableAnonKey.trim().isEmpty) {
      throw StateError('Supabase publishable/anon key must not be empty.');
    }

    // Never permit service-role secrets or private backend keys in the Flutter client.
    if (_looksLikeServiceRoleSecret(publishableAnonKey)) {
      throw StateError(
        'Prohibited service-role or secret key detected in client configuration.',
      );
    }

    if (environment != SupabaseEnvironment.dev &&
        _looksLikePlaceholderKey(publishableAnonKey)) {
      throw StateError(
        'Staging and production require a configured publishable/anon key.',
      );
    }
  }

  /// Verifies that an incoming deep-link or callback URI belongs to an allowlisted
  /// origin before forwarding it to the auth session coordinator (`T002`, `T024`).
  bool isAllowedCallbackUri(Uri uri) {
    final normalized =
        '${uri.scheme.toLowerCase()}://${uri.host.toLowerCase()}';
    if (allowedRedirectOrigins.contains(normalized)) {
      return true;
    }
    final configuredRedirect = Uri.tryParse(authRedirectUri);
    if (configuredRedirect != null) {
      final configuredOrigin =
          '${configuredRedirect.scheme.toLowerCase()}://${configuredRedirect.host.toLowerCase()}';
      if (normalized == configuredOrigin) {
        return true;
      }
    }
    final projectUri = Uri.tryParse(supabaseUrl);
    if (projectUri != null &&
        uri.scheme.toLowerCase() == projectUri.scheme.toLowerCase() &&
        uri.host.toLowerCase() == projectUri.host.toLowerCase()) {
      return true;
    }
    return false;
  }

  static SupabaseEnvironment _parseEnvironment(String raw) {
    return switch (raw.trim().toLowerCase()) {
      'prod' || 'production' => SupabaseEnvironment.prod,
      'staging' || 'stage' => SupabaseEnvironment.staging,
      _ => SupabaseEnvironment.dev,
    };
  }

  static bool _looksLikeServiceRoleSecret(String key) {
    final lower = key.trim().toLowerCase();
    if (lower.startsWith('sb_secret_') || lower.contains('service_role')) {
      return true;
    }
    // Inspect JWT payload role claim if the key is a 3-segment JWT.
    final parts = key.split('.');
    if (parts.length == 3) {
      try {
        final normalized = base64Url.normalize(parts[1]);
        final payload = utf8.decode(base64Url.decode(normalized)).toLowerCase();
        if (payload.contains('"role":"service_role"') ||
            payload.contains('"role": "service_role"')) {
          return true;
        }
      } catch (_) {
        // Ignore non-base64 segments; raw string checks above still apply.
      }
    }
    return false;
  }

  static bool _looksLikePlaceholderKey(String key) {
    final lower = key.trim().toLowerCase();
    return lower.contains('placeholder') ||
        lower.contains('example') ||
        lower.contains('your_') ||
        lower.contains('change_me') ||
        lower.contains('changeme') ||
        lower.contains('replace_me');
  }
}
