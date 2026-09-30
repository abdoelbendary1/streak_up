import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:streak_up/app/routing/feature_route_hosts.dart';
import 'package:streak_up/app/routing/shell_destination.dart';
import 'package:streak_up/core/localization/app_localizations.dart';
import 'package:streak_up/features/auth/presentation/auth_cubit.dart';
import 'package:streak_up/features/auth/presentation/email_verification_screen.dart';
import 'package:streak_up/features/auth/presentation/password_recovery_screen.dart';
import 'package:streak_up/features/auth/presentation/password_recovery_sent_screen.dart';
import 'package:streak_up/features/auth/presentation/password_reset_screen.dart';
import 'package:streak_up/features/auth/presentation/registration_screen.dart';
import 'package:streak_up/features/auth/presentation/session_expired_screen.dart';
import 'package:streak_up/features/auth/presentation/session_restoring_screen.dart';
import 'package:streak_up/features/auth/presentation/sign_in_screen.dart';
import 'package:streak_up/features/shell/presentation/app_shell.dart';
import 'package:streak_up/features/shell/presentation/shell_cubit.dart';

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
      onBackToSignIn: () async {
        final authCubit = context.read<AuthCubit?>();
        if (authCubit != null) {
          await authCubit.requestSignOut(forceAfterWarning: true);
        }
        if (context.mounted) {
          const SignInRouteData().go(context);
        }
      },
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
      onPasswordUpdated: () => const TodayRouteData().go(context),
      onBackToSignIn: () => const SignInRouteData().go(context),
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
      onSignInAgain: () => const SignInRouteData().go(context),
    );
  }
}

@TypedShellRoute<MainShellRouteData>(
  routes: <TypedRoute<RouteData>>[
    TypedGoRoute<TodayRouteData>(path: '/today'),
    TypedGoRoute<HabitsRouteData>(path: '/habits'),
    TypedGoRoute<ChallengesRouteData>(path: '/challenges'),
    TypedGoRoute<FriendsRouteData>(path: '/friends'),
  ],
)
class MainShellRouteData extends ShellRouteData {
  const MainShellRouteData();

  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) {
    final destination = _destinationFromUri(state.uri.path);
    final shellCubit = context.read<ShellCubit>();
    if (shellCubit.state.selectedDestination != destination) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!shellCubit.isClosed) {
          shellCubit.syncDestinationFromRoute(destination);
        }
      });
    }

    return AppShell(
      activeDestination: destination,
      onDestinationSelected: (target) {
        shellCubit.syncDestinationFromRoute(target);
        navigateToDestination(context, target);
      },
      onOpenInbox: () => const InboxRouteData().push<void>(context),
      onOpenProfile: () => const ProfileRouteData().push<void>(context),
      onOpenSyncRecovery: () =>
          const SyncRecoveryRouteData().push<void>(context),
      child: navigator,
    );
  }

  static ShellDestination _destinationFromUri(String path) {
    for (final destination in ShellDestination.values) {
      if (path.startsWith(destination.path)) {
        return destination;
      }
    }
    return ShellDestination.today;
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
    final hosts = context.read<FeatureRouteHosts>();
    return NoTransitionPage<void>(
      key: state.pageKey,
      child: hosts.buildDestination(context, ShellDestination.today),
    );
  }
}

class HabitsRouteData extends GoRouteData with $HabitsRouteData {
  const HabitsRouteData();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    final hosts = context.read<FeatureRouteHosts>();
    return NoTransitionPage<void>(
      key: state.pageKey,
      child: hosts.buildDestination(context, ShellDestination.habits),
    );
  }
}

class ChallengesRouteData extends GoRouteData with $ChallengesRouteData {
  const ChallengesRouteData();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    final hosts = context.read<FeatureRouteHosts>();
    return NoTransitionPage<void>(
      key: state.pageKey,
      child: hosts.buildDestination(context, ShellDestination.challenges),
    );
  }
}

class FriendsRouteData extends GoRouteData with $FriendsRouteData {
  const FriendsRouteData();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    final hosts = context.read<FeatureRouteHosts>();
    return NoTransitionPage<void>(
      key: state.pageKey,
      child: hosts.buildDestination(context, ShellDestination.friends),
    );
  }
}

@TypedGoRoute<InboxRouteData>(path: '/inbox')
class InboxRouteData extends GoRouteData with $InboxRouteData {
  const InboxRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final hosts = context.read<FeatureRouteHosts>();
    final l10n = AppLocalizations.of(context);
    return GlobalRouteShell(
      title: l10n.screenInboxTitle,
      onBack: () => _returnToActiveBranch(context),
      child: hosts.buildInbox(context),
    );
  }
}

@TypedGoRoute<ProfileRouteData>(path: '/profile')
class ProfileRouteData extends GoRouteData with $ProfileRouteData {
  const ProfileRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final hosts = context.read<FeatureRouteHosts>();
    final l10n = AppLocalizations.of(context);
    return GlobalRouteShell(
      title: l10n.screenProfileTitle,
      onBack: () => _returnToActiveBranch(context),
      child: hosts.buildProfile(context),
    );
  }
}

@TypedGoRoute<SyncRecoveryRouteData>(path: '/sync-recovery')
class SyncRecoveryRouteData extends GoRouteData with $SyncRecoveryRouteData {
  const SyncRecoveryRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final hosts = context.read<FeatureRouteHosts>();
    final l10n = AppLocalizations.of(context);
    return GlobalRouteShell(
      title: l10n.screenSyncRecoveryTitle,
      onBack: () => _returnToActiveBranch(context),
      child: hosts.buildSyncRecovery(context),
    );
  }
}

void _returnToActiveBranch(BuildContext context) {
  final router = GoRouter.of(context);
  if (router.canPop()) {
    router.pop();
    return;
  }
  final activeDestination =
      context.read<ShellCubit>().state.selectedDestination;
  MainShellRouteData.navigateToDestination(context, activeDestination);
}
