import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:streak_up/app/routing/app_routes.dart';
import 'package:streak_up/features/auth/presentation/cubit/auth_cubit.dart';

/// Navigation observes AuthCubit; redirects read state synchronously without side effects.
@lazySingleton
class AppRouter {
  AppRouter(AuthCubit authCubit, {String initialLocation = '/restoring'}) {
    final refresh = _AuthRouterRefresh(authCubit, initialLocation);
    _authRefresh = refresh;
    router = GoRouter(
      initialLocation: _safeInitialLocation(initialLocation),
      refreshListenable: refresh,
      routes: $appRoutes,
      redirect: (context, state) => resolveAuthRedirect(
        authCubit.state,
        state.uri.path,
        destination: refresh.destination,
      ),
    );
    refresh.router = router;
  }

  late final GoRouter router;
  _AuthRouterRefresh? _authRefresh;

  @factoryMethod
  static AppRouter create(AuthCubit authCubit) => AppRouter(authCubit);

  @disposeMethod
  void dispose() {
    _authRefresh?.dispose();
    router.dispose();
  }

  static String? resolveAuthRedirect(
    AuthState state,
    String location, {
    String destination = '/today',
  }) {
    String? redirect(String target) => location == target ? null : target;
    switch (state.status) {
      case AuthStatus.restoring:
      case AuthStatus.signingOut:
        return redirect('/restoring');
      case AuthStatus.signedOut:
        if (location == '/password-recovery/reset') {
          return redirect('/sign-in');
        }
        return const {
              '/sign-in',
              '/register',
              '/password-recovery',
              '/password-recovery/sent',
            }.contains(location)
            ? null
            : redirect('/sign-in');
      case AuthStatus.verificationRequired:
        return redirect('/verify-email');
      case AuthStatus.recoveryRequired:
        return redirect('/password-recovery/reset');
      case AuthStatus.reauthenticationRequired:
        return redirect('/session-expired');
      case AuthStatus.authenticated:
        if (!state.canAccessProtected) return redirect('/sign-in');
        return _authRoutePaths.contains(location)
            ? redirect(destination)
            : null;
    }
  }

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

  static String _safeInitialLocation(String location) {
    final uri = Uri.tryParse(location);
    return uri != null &&
            !uri.hasScheme &&
            !uri.hasAuthority &&
            !uri.hasQuery &&
            !uri.hasFragment &&
            (_authRoutePaths.contains(uri.path) ||
                const {
                  '/today',
                  '/habits',
                  '/challenges',
                  '/friends',
                  '/inbox',
                  '/profile',
                  '/sync-recovery',
                }.contains(uri.path))
        ? uri.path
        : '/today';
  }
}

/// GoRouter refresh listenable subscribing to AuthCubit stream.
class _AuthRouterRefresh extends ChangeNotifier {
  _AuthRouterRefresh(this.authCubit, String initialLocation) {
    final uri = Uri.tryParse(initialLocation);
    if (uri != null &&
        !uri.hasScheme &&
        !uri.hasAuthority &&
        !uri.hasQuery &&
        !uri.hasFragment &&
        const {
          '/today',
          '/habits',
          '/challenges',
          '/friends',
          '/inbox',
          '/profile',
        }.contains(uri.path)) {
      destination = uri.path;
    }
    _subscription = authCubit.stream.listen((state) {
      if (state.status == AuthStatus.signingOut ||
          state.status == AuthStatus.reauthenticationRequired) {
        destination = '/today';
      }
      if (state.status == AuthStatus.signingOut) {
        router?.go('/restoring');
      }
      notifyListeners();
    });
  }

  final AuthCubit authCubit;
  late final StreamSubscription<AuthState> _subscription;
  GoRouter? router;
  String destination = '/today';

  @override
  @disposeMethod
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }
}
