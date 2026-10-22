import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';
import 'package:streak_up/app/theme/app_theme.dart';
import 'package:streak_up/core/localization/active_locale_resolver.dart';
import 'package:streak_up/core/localization/app_localizations.dart';
import 'package:streak_up/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:streak_up/features/auth/presentation/widgets/auth_notification_listener.dart';
import 'package:streak_up/features/habits/domain/repositories/habit_repository.dart';
import 'package:streak_up/features/shell/presentation/cubit/shell_cubit.dart';
import 'habit_account_scope.dart';

/// Root application
///
/// Consumes constructor/provider-injected dependencies only; widgets never access `GetIt`.
class StreakUpApp extends StatelessWidget {
  const StreakUpApp({
    super.key,
    required this.shellCubit,
    required this.authCubit,
    required this.router,
    required this.openHabitRepository,
    this.simulatedDeviceLocale,
  });

  final ShellCubit shellCubit;
  final AuthCubit authCubit;
  final GoRouter router;
  final Future<HabitRepository> Function(String) openHabitRepository;
  final Locale? simulatedDeviceLocale;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        BlocProvider<ShellCubit>.value(value: shellCubit),
        BlocProvider<AuthCubit>.value(value: authCubit),
      ],
      child: BlocListener<AuthCubit, AuthState>(
        listenWhen: (previous, current) {
          final wasAuth = previous.status == AuthStatus.authenticated;
          final isAuth = current.status == AuthStatus.authenticated;
          final accountChanged =
              wasAuth &&
              isAuth &&
              previous.session?.userId != current.session?.userId;
          final leftAuth = wasAuth && !isAuth;
          return leftAuth || accountChanged;
        },
        listener: (context, state) {
          shellCubit.resetForAccountTransition();
        },
        child: BlocBuilder<ShellCubit, ShellState>(
          builder: (context, shellState) {
            return ToastificationWrapper(
              child: MaterialApp.router(
                debugShowCheckedModeBanner: false,
                onGenerateTitle: (ctx) => AppLocalizations.of(ctx).brandName,
                theme: AppTheme.light,
                routerConfig: router,
                builder: (context, child) => AuthNotificationListener(
                  child: HabitAccountScope(
                    openRepository: openHabitRepository,
                    child: child!,
                  ),
                ),
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: ActiveLocaleResolver.supportedLocales,
                locale:
                    shellState.explicitLocaleOverride ??
                    (simulatedDeviceLocale != null
                        ? ActiveLocaleResolver.resolve(
                            deviceLocale: simulatedDeviceLocale,
                          )
                        : null),
                localeListResolutionCallback: (locales, supported) {
                  return ActiveLocaleResolver.resolveFromList(
                    locales,
                    explicitOverride: shellState.explicitLocaleOverride,
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
