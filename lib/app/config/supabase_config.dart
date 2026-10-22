abstract final class SupabaseConfig {
  static const url = String.fromEnvironment('SUPABASE_URL');

  static const publishableKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  static const authRedirectUrl = String.fromEnvironment(
    'SUPABASE_AUTH_REDIRECT_URL',
    defaultValue: 'io.streakup.app://auth-callback',
  );

  static void validate() {
    if (url.isEmpty) {
      throw StateError('SUPABASE_URL is missing');
    }

    if (publishableKey.isEmpty) {
      throw StateError('SUPABASE_ANON_KEY is missing');
    }

    if (publishableKey.startsWith('sb_secret_')) {
      throw StateError('Secret Supabase key cannot be used in the app');
    }
  }
}
