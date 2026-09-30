import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:streak_up/app/bootstrap/injection.dart';
import 'package:streak_up/app/routing/app_router.dart';
import 'package:streak_up/app/routing/feature_route_hosts.dart';
import 'package:streak_up/app/theme/app_theme.dart';
import 'package:streak_up/core/localization/active_locale_resolver.dart';
import 'package:streak_up/core/localization/app_localizations.dart';
import 'package:streak_up/core/presentation/feedback/feedback_coordinator.dart';
import 'package:streak_up/core/presentation/status/status_models.dart';
import 'package:streak_up/features/auth/presentation/auth_cubit.dart';
import 'package:streak_up/features/shell/presentation/shell_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final locator = await configureDependencies();
  final authCubit = locator<AuthCubit>();
  // Trigger initial session restoration asynchronously as soon as the app boots (`T004`, `T014`).
  authCubit.restoreInitialSession();

  runApp(
    StreakUpShellApp(
      shellCubit: locator<ShellCubit>(),
      statusCubit: locator<ShellStatusCubit>(),
      feedbackCoordinator: locator<FeedbackCoordinator>(),
      routeHosts: locator<FeatureRouteHosts>(),
      authCubit: authCubit,
      router: locator<AppRouter>().router,
    ),
  );
}

/// Root application widget (`SL01-FR-001`–`006`, `SL02-FR-001`–`012`).
///
/// Consumes constructor/provider-injected dependencies only; widgets never access `GetIt`.
class StreakUpShellApp extends StatefulWidget {
  const StreakUpShellApp({
    super.key,
    required this.shellCubit,
    required this.statusCubit,
    required this.feedbackCoordinator,
    required this.routeHosts,
    this.authCubit,
    this.router,
    this.simulatedDeviceLocale,
  });

  final ShellCubit shellCubit;
  final ShellStatusCubit statusCubit;
  final FeedbackCoordinator feedbackCoordinator;
  final FeatureRouteHosts routeHosts;
  final AuthCubit? authCubit;
  final GoRouter? router;
  final Locale? simulatedDeviceLocale;

  @override
  State<StreakUpShellApp> createState() => _StreakUpShellAppState();
}

class _StreakUpShellAppState extends State<StreakUpShellApp> {
  late final GoRouter _router = widget.router ?? AppRouter.createRouter();

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<FeatureRouteHosts>.value(
      value: widget.routeHosts,
      child: MultiBlocProvider(
        providers: <BlocProvider<dynamic>>[
          BlocProvider<ShellCubit>.value(value: widget.shellCubit),
          BlocProvider<ShellStatusCubit>.value(value: widget.statusCubit),
          BlocProvider<FeedbackCoordinator>.value(
            value: widget.feedbackCoordinator,
          ),
          if (widget.authCubit != null)
            BlocProvider<AuthCubit>.value(value: widget.authCubit!),
        ],
        child: BlocBuilder<ShellCubit, ShellState>(
          builder: (context, shellState) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              onGenerateTitle: (ctx) => AppLocalizations.of(ctx).brandName,
              theme: AppTheme.light,
              routerConfig: _router,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: ActiveLocaleResolver.supportedLocales,
              locale: shellState.explicitLocaleOverride ??
                  (widget.simulatedDeviceLocale != null
                      ? ActiveLocaleResolver.resolve(
                          deviceLocale: widget.simulatedDeviceLocale,
                        )
                      : null),
              localeListResolutionCallback: (locales, supported) {
                return ActiveLocaleResolver.resolveFromList(
                  locales,
                  explicitOverride: shellState.explicitLocaleOverride,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
