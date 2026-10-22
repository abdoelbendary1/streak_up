import 'package:streak_up/features/habits/presentation/screens/habits_screen.dart';
import 'package:streak_up/features/habits/presentation/screens/today_screen.dart';
import 'package:streak_up/features/habits/presentation/cubit/today_cubit.dart';
import 'package:streak_up/features/habits/domain/repositories/habit_repository.dart';
import 'package:streak_up/features/habits/domain/use_cases/habit_use_cases.dart';
import 'package:streak_up/features/habits/presentation/screens/create_habit_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:streak_up/app/theme/app_colors.dart';
import 'package:streak_up/core/localization/app_localizations.dart';
import 'package:streak_up/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:streak_up/features/auth/presentation/screens/email_verification_screen.dart';
import 'package:streak_up/features/auth/presentation/screens/password_recovery_screen.dart';
import 'package:streak_up/features/auth/presentation/screens/password_recovery_sent_screen.dart';
import 'package:streak_up/features/auth/presentation/screens/password_reset_screen.dart';
import 'package:streak_up/features/auth/presentation/screens/registration_screen.dart';
import 'package:streak_up/features/auth/presentation/screens/session_expired_screen.dart';
import 'package:streak_up/features/auth/presentation/screens/session_restoring_screen.dart';
import 'package:streak_up/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:streak_up/features/shell/presentation/global_route_shell.dart';
import 'package:streak_up/features/shell/presentation/models/shell_destination.dart';
import 'package:streak_up/features/shell/presentation/screens/app_shell.dart';
import 'package:streak_up/features/shell/presentation/widgets/feature_placeholder.dart';
import 'package:streak_up/features/shell/presentation/widgets/profile_placeholder.dart';

part 'app_routes.g.dart';

@TypedGoRoute<RestoringRouteData>(path: '/restoring')
class RestoringRouteData extends GoRouteData with $RestoringRouteData {
  const RestoringRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SessionRestoringScreen();
  }
}

@TypedGoRoute<SignInRouteData>(path: '/sign-in')
class SignInRouteData extends GoRouteData with $SignInRouteData {
  const SignInRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return SignInScreen(
      onNavigateToRegister: () => const RegisterRouteData().go(context),
      onNavigateToPasswordRecovery: () =>
          const PasswordRecoveryRouteData().go(context),
    );
  }
}

@TypedGoRoute<RegisterRouteData>(path: '/register')
class RegisterRouteData extends GoRouteData with $RegisterRouteData {
  const RegisterRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return RegistrationScreen(
      onNavigateToSignIn: () => const SignInRouteData().go(context),
    );
  }
}

@TypedGoRoute<VerifyEmailRouteData>(path: '/verify-email')
class VerifyEmailRouteData extends GoRouteData with $VerifyEmailRouteData {
  const VerifyEmailRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return EmailVerificationScreen(
      onBackToSignIn: () => context.read<AuthCubit>().signOut(),
    );
  }
}

@TypedGoRoute<PasswordRecoveryRouteData>(
  path: '/password-recovery',
  routes: <TypedRoute<RouteData>>[
    TypedGoRoute<PasswordRecoverySentRouteData>(path: 'sent'),
    TypedGoRoute<PasswordResetRouteData>(path: 'reset'),
  ],
)
class PasswordRecoveryRouteData extends GoRouteData
    with $PasswordRecoveryRouteData {
  const PasswordRecoveryRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return PasswordRecoveryScreen(
      onRecoveryLinkRequested: () =>
          const PasswordRecoverySentRouteData().go(context),
      onBackToSignIn: () => const SignInRouteData().go(context),
    );
  }
}

class PasswordRecoverySentRouteData extends GoRouteData
    with $PasswordRecoverySentRouteData {
  const PasswordRecoverySentRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return PasswordRecoverySentScreen(
      onBackToSignIn: () => const SignInRouteData().go(context),
    );
  }
}

class PasswordResetRouteData extends GoRouteData with $PasswordResetRouteData {
  const PasswordResetRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return PasswordResetScreen(
      onPasswordUpdated: () => const SignInRouteData().go(context),
      onBackToSignIn: () => context.read<AuthCubit>().signOut(),
    );
  }
}

@TypedGoRoute<SessionExpiredRouteData>(path: '/session-expired')
class SessionExpiredRouteData extends GoRouteData
    with $SessionExpiredRouteData {
  const SessionExpiredRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return SessionExpiredScreen(
      onSignInAgain: () => context.read<AuthCubit>().signOut(),
    );
  }
}

@TypedShellRoute<MainShellRouteData>(
  routes: <TypedRoute<RouteData>>[
    TypedGoRoute<TodayRouteData>(path: '/today'),
    TypedGoRoute<HabitsRouteData>(
      path: '/habits',
      routes: [TypedGoRoute<CreateHabitRouteData>(path: 'create')],
    ),
    TypedGoRoute<ChallengesRouteData>(path: '/challenges'),
    TypedGoRoute<FriendsRouteData>(path: '/friends'),
  ],
)
class MainShellRouteData extends ShellRouteData {
  const MainShellRouteData();

  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) {
    final destination = switch (state.uri.path) {
      '/habits' => ShellDestination.habits,
      '/challenges' => ShellDestination.challenges,
      '/friends' => ShellDestination.friends,
      _ => ShellDestination.today,
    };

    return _ProtectedContent(
      child: AppShell(
        selectedIndex: destination.index,
        onDestinationSelected: (target) =>
            navigateToDestination(context, target),
        onOpenInbox: () => const InboxRouteData().push<void>(context),
        onOpenProfile: () => const ProfileRouteData().push<void>(context),
        child: navigator,
      ),
    );
  }

  static void navigateToDestination(
    BuildContext context,
    ShellDestination destination,
  ) {
    switch (destination) {
      case ShellDestination.today:
        const TodayRouteData().go(context);
      case ShellDestination.habits:
        const HabitsRouteData().go(context);
      case ShellDestination.challenges:
        const ChallengesRouteData().go(context);
      case ShellDestination.friends:
        const FriendsRouteData().go(context);
    }
  }
}

class TodayRouteData extends GoRouteData with $TodayRouteData {
  const TodayRouteData();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return NoTransitionPage<void>(
      key: state.pageKey,
      child: BlocProvider(
        create: (context) => TodayCubit(
          WatchTodayUseCase(context.read<HabitRepository>()),
          RefreshTodayUseCase(context.read<HabitRepository>()),
          CompleteOccurrenceUseCase(context.read<HabitRepository>()),
        ),
        child: TodayScreen(
          onCreate: () => const CreateHabitRouteData().push(context),
          onOpenHabits: () => const HabitsRouteData().go(context),
        ),
      ),
    );
  }
}

class HabitsRouteData extends GoRouteData with $HabitsRouteData {
  const HabitsRouteData();
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      NoTransitionPage<void>(
        key: state.pageKey,
        child: HabitsScreen(
          onCreate: () => const CreateHabitRouteData().push(context),
        ),
      );
}

class CreateHabitRouteData extends GoRouteData with $CreateHabitRouteData {
  const CreateHabitRouteData();
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      CreateHabitScreen(onCreated: () => const HabitsRouteData().go(context));
}

class ChallengesRouteData extends GoRouteData with $ChallengesRouteData {
  const ChallengesRouteData();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return NoTransitionPage<void>(
      key: state.pageKey,
      child: SingleChildScrollView(
        child: FeaturePlaceholder(
          key: const ValueKey('shell_host_challenges'),
          title: AppLocalizations.of(context).hostPlaceholderTitle(
            ShellDestination.challenges.localizedLabel(
              AppLocalizations.of(context),
            ),
          ),
          description: AppLocalizations.of(context).hostPlaceholderSubtitle,
          iconColor: AppColors.greenDark,
          iconBackground: AppColors.selectedGreenPill,
          icon: ShellDestination.challenges.selectedIcon,
        ),
      ),
    );
  }
}

class FriendsRouteData extends GoRouteData with $FriendsRouteData {
  const FriendsRouteData();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return NoTransitionPage<void>(
      key: state.pageKey,
      child: SingleChildScrollView(
        child: FeaturePlaceholder(
          key: const ValueKey('shell_host_friends'),
          title: AppLocalizations.of(context).hostPlaceholderTitle(
            ShellDestination.friends.localizedLabel(
              AppLocalizations.of(context),
            ),
          ),
          description: AppLocalizations.of(context).hostPlaceholderSubtitle,
          iconColor: AppColors.greenDark,
          iconBackground: AppColors.selectedGreenPill,
          icon: ShellDestination.friends.selectedIcon,
        ),
      ),
    );
  }
}

@TypedGoRoute<InboxRouteData>(path: '/inbox')
class InboxRouteData extends GoRouteData with $InboxRouteData {
  const InboxRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final l10n = AppLocalizations.of(context);
    return _ProtectedContent(
      child: GlobalRouteShell(
        title: l10n.screenInboxTitle,
        onBack: () => _returnToShell(context),
        child: SingleChildScrollView(
          child: FeaturePlaceholder(
            key: const ValueKey('global_host_inbox'),
            title: l10n.screenInboxTitle,
            description: l10n.screenInboxPlaceholderBody,
            icon: Icons.notifications_none_rounded,
          ),
        ),
      ),
    );
  }
}

@TypedGoRoute<ProfileRouteData>(path: '/profile')
class ProfileRouteData extends GoRouteData with $ProfileRouteData {
  const ProfileRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final l10n = AppLocalizations.of(context);
    return _ProtectedContent(
      child: GlobalRouteShell(
        title: l10n.screenProfileTitle,
        onBack: () => _returnToShell(context),
        child: const ProfilePlaceholder(),
      ),
    );
  }
}

@TypedGoRoute<SyncRecoveryRouteData>(path: '/sync-recovery')
class SyncRecoveryRouteData extends GoRouteData with $SyncRecoveryRouteData {
  const SyncRecoveryRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final l10n = AppLocalizations.of(context);
    return _ProtectedContent(
      child: GlobalRouteShell(
        title: l10n.screenSyncRecoveryTitle,
        onBack: () => _returnToShell(context),
        child: SingleChildScrollView(
          child: FeaturePlaceholder(
            key: const ValueKey('global_host_sync_recovery'),
            title: l10n.screenSyncRecoveryTitle,
            description: l10n.screenSyncRecoveryPlaceholderBody,
            icon: Icons.sync_problem_rounded,
          ),
        ),
      ),
    );
  }
}

void _returnToShell(BuildContext context) {
  final router = GoRouter.of(context);
  if (router.canPop()) {
    router.pop();
    return;
  }
  // A standalone global deep link has no earlier shell page to return to.
  const TodayRouteData().go(context);
}

// A redirect may animate the outgoing page; revoke its content immediately.
class _ProtectedContent extends StatelessWidget {
  const _ProtectedContent({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final canAccess = context.select(
      (AuthCubit cubit) => cubit.state.canAccessProtected,
    );
    return canAccess ? child : const SizedBox.shrink();
  }
}
