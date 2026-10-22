import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:streak_up/app/routing/app_routes.dart';
import 'package:streak_up/app/streak_up_app.dart';
import 'package:streak_up/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:streak_up/features/shell/presentation/cubit/shell_cubit.dart';
import 'package:streak_up/features/shell/presentation/screens/app_shell.dart';
import 'fake_auth_repository.dart';

GoRouter createTestRouter({String initialLocation = '/today'}) =>
    GoRouter(initialLocation: initialLocation, routes: $appRoutes);

/// Explicit test composition; fake destination content uses a test-only route.
class TestApp extends StatefulWidget {
  const TestApp({
    super.key,
    required this.shellCubit,
    this.authCubit,
    this.router,
    this.simulatedDeviceLocale,
    this.todayBuilder,
  });

  final ShellCubit shellCubit;
  final AuthCubit? authCubit;
  final GoRouter? router;
  final Locale? simulatedDeviceLocale;
  final WidgetBuilder? todayBuilder;

  @override
  State<TestApp> createState() => _TestAppState();
}

class _TestAppState extends State<TestApp> {
  FakeAuthRepository? _repository;
  late final AuthCubit _cubit;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    if (widget.authCubit == null) {
      _repository = FakeAuthRepository()..currentSession = accountA;
      _cubit = AuthCubit(_repository!);
      _cubit.restore();
    } else {
      _cubit = widget.authCubit!;
    }
    _router =
        widget.router ??
        (widget.todayBuilder == null
            ? createTestRouter()
            : GoRouter(
                initialLocation: '/today',
                routes: [
                  ShellRoute(
                    builder: (context, state, child) => AppShell(
                      selectedIndex: 0,
                      onDestinationSelected: (_) {},
                      onOpenInbox: () {},
                      onOpenProfile: () {},
                      child: child,
                    ),
                    routes: [
                      GoRoute(
                        path: '/today',
                        builder: (context, state) =>
                            widget.todayBuilder!(context),
                      ),
                    ],
                  ),
                ],
              ));
  }

  @override
  void dispose() {
    if (widget.router == null) _router.dispose();
    if (_repository != null) {
      _cubit.close();
      _repository!.controller.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => StreakUpApp(
    shellCubit: widget.shellCubit,
    authCubit: _cubit,
    router: _router,
    simulatedDeviceLocale: widget.simulatedDeviceLocale,
  );
}
