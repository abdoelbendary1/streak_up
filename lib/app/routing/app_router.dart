import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:streak_up/app/routing/app_routes.dart';
import 'package:streak_up/app/routing/shell_destination.dart';
import 'package:streak_up/features/auth/application/auth_session_coordinator.dart';
import 'package:streak_up/features/auth/domain/auth_models.dart';

/// Router construction and central auth/session redirect guard (`T013`, `T022`–`T024`, `SL02-FR-012`).
@lazySingleton
class AppRouter {
  AppRouter(AuthSessionCoordinator authCoordinator)
    : router = createRouter(
        initialLocation: '/restoring',
        authCoordinator: authCoordinator,
      );

  AppRouter.withInitialDestination(
    ShellDestination initialDestination, {
    AuthSessionCoordinator? authCoordinator,
  }) : router = createRouter(
         initialLocation: initialDestination.path,
         authCoordinator: authCoordinator,
       );

  final GoRouter router;

  static const Set<String> _authRoutePaths = <String>{
    '/restoring',
    '/sign-in',
    '/register',
    '/verify-email',
    '/password-recovery',
    '/password-recovery/sent',
    '/password-recovery/reset',
    '/session-expired',
  };

  static GoRouter createRouter({
    String? initialLocation,
    AuthSessionCoordinator? authCoordinator,
  }) {
    final effectiveInitialLocation =
        initialLocation ?? (authCoordinator != null ? '/restoring' : '/today');

    return GoRouter(
      initialLocation: effectiveInitialLocation,
      refreshListenable: authCoordinator,
      routes: $appRoutes,
      redirect: authCoordinator == null
          ? null
          : (context, state) => resolveAuthRedirect(
              coordinator: authCoordinator,
              location: state.uri.path,
              fullUri: state.uri,
            ),
    );
  }

  /// Central account-state redirect table (`T022`–`T024`, `SL02-FR-003`–`007`, `SL02-FR-012`).
  static String? resolveAuthRedirect({
    required AuthSessionCoordinator coordinator,
    required String location,
    Uri? fullUri,
  }) {
    // Intercept incoming OS auth callbacks (e.g. io.streakup.app://auth-callback or /auth-callback),
    // forward to coordinator validation, and immediately redirect to a clean, token-free route (`T024`, `T035`).
    final isCallbackPath =
        location == '/auth-callback' ||
        (fullUri != null && fullUri.host.toLowerCase() == 'auth-callback');
    if (isCallbackPath) {
      final normalizedCallbackUri = Uri(
        scheme: (fullUri != null && fullUri.scheme.isNotEmpty)
            ? fullUri.scheme
            : 'io.streakup.app',
        host: 'auth-callback',
        query: fullUri?.query ?? '',
        fragment: fullUri?.fragment ?? '',
      );
      final isRecoveryAttempt =
          normalizedCallbackUri.queryParameters['type']?.toLowerCase() ==
              'recovery' ||
          normalizedCallbackUri.fragment.toLowerCase().contains(
            'type=recovery',
          );
      coordinator.handleAuthCallbackUri(normalizedCallbackUri);
      if (isRecoveryAttempt) {
        return coordinator.snapshot.accountState.canAccessPasswordResetForm
            ? '/password-recovery/reset'
            : '/password-recovery';
      }
      return switch (coordinator.snapshot.accountState) {
        AuthAuthenticatedState() =>
          coordinator.consumePostAuthenticationDestination(),
        AuthVerificationRequiredState() => '/verify-email',
        _ => '/sign-in',
      };
    }

    final accountState = coordinator.snapshot.accountState;
    final isAuthRoute = _authRoutePaths.contains(location);
    final isProtectedRoute = !isAuthRoute;

    // Direct entry to /password-recovery/reset without a validated recovery context
    // must always redirect to /password-recovery (`T024`, `SL02-FR-005`).
    if (location == '/password-recovery/reset' &&
        !accountState.canAccessPasswordResetForm) {
      return '/password-recovery';
    }

    switch (accountState) {
      case AuthRestoringState():
        if (isProtectedRoute) {
          coordinator.recordIntendedProtectedDestination(location);
        }
        return location == '/restoring' ? null : '/restoring';

      case AuthSignedOutState(:final hasValidatedPasswordResetContext):
        if (hasValidatedPasswordResetContext) {
          return location == '/password-recovery/reset' ||
                  location == '/sign-in'
              ? null
              : '/password-recovery/reset';
        }
        if (isProtectedRoute) {
          coordinator.recordIntendedProtectedDestination(location);
          return '/sign-in';
        }
        const allowedSignedOutRoutes = <String>{
          '/sign-in',
          '/register',
          '/password-recovery',
          '/password-recovery/sent',
        };
        return allowedSignedOutRoutes.contains(location) ? null : '/sign-in';

      case AuthVerificationRequiredState():
        if (isProtectedRoute) {
          coordinator.recordIntendedProtectedDestination(location);
        }
        return location == '/verify-email' ? null : '/verify-email';

      case AuthReauthenticationRequiredState():
        if (isProtectedRoute) {
          coordinator.recordIntendedProtectedDestination(location);
          return '/session-expired';
        }
        const allowedReauthRoutes = <String>{
          '/session-expired',
          '/sign-in',
          '/password-recovery',
          '/password-recovery/sent',
        };
        return allowedReauthRoutes.contains(location)
            ? null
            : '/session-expired';

      case AuthAuthenticatedState(:final hasValidatedPasswordResetContext):
        if (hasValidatedPasswordResetContext) {
          return location == '/password-recovery/reset'
              ? null
              : '/password-recovery/reset';
        }
        if (isAuthRoute) {
          return coordinator.consumePostAuthenticationDestination();
        }
        return null;
    }
  }
}
