// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $restoringRouteData,
  $signInRouteData,
  $registerRouteData,
  $verifyEmailRouteData,
  $passwordRecoveryRouteData,
  $sessionExpiredRouteData,
  $mainShellRouteData,
  $inboxRouteData,
  $profileRouteData,
  $syncRecoveryRouteData,
];

RouteBase get $restoringRouteData => GoRouteData.$route(
  path: '/restoring',
  hasOverriddenOnExit: false,
  factory: $RestoringRouteData._fromState,
);

mixin $RestoringRouteData on GoRouteData {
  static RestoringRouteData _fromState(GoRouterState state) =>
      const RestoringRouteData();

  @override
  String get location => GoRouteData.$location('/restoring');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $signInRouteData => GoRouteData.$route(
  path: '/sign-in',
  hasOverriddenOnExit: false,
  factory: $SignInRouteData._fromState,
);

mixin $SignInRouteData on GoRouteData {
  static SignInRouteData _fromState(GoRouterState state) =>
      const SignInRouteData();

  @override
  String get location => GoRouteData.$location('/sign-in');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $registerRouteData => GoRouteData.$route(
  path: '/register',
  hasOverriddenOnExit: false,
  factory: $RegisterRouteData._fromState,
);

mixin $RegisterRouteData on GoRouteData {
  static RegisterRouteData _fromState(GoRouterState state) =>
      const RegisterRouteData();

  @override
  String get location => GoRouteData.$location('/register');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $verifyEmailRouteData => GoRouteData.$route(
  path: '/verify-email',
  hasOverriddenOnExit: false,
  factory: $VerifyEmailRouteData._fromState,
);

mixin $VerifyEmailRouteData on GoRouteData {
  static VerifyEmailRouteData _fromState(GoRouterState state) =>
      const VerifyEmailRouteData();

  @override
  String get location => GoRouteData.$location('/verify-email');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $passwordRecoveryRouteData => GoRouteData.$route(
  path: '/password-recovery',
  hasOverriddenOnExit: false,
  factory: $PasswordRecoveryRouteData._fromState,
  routes: [
    GoRouteData.$route(
      path: 'sent',
      hasOverriddenOnExit: false,
      factory: $PasswordRecoverySentRouteData._fromState,
    ),
    GoRouteData.$route(
      path: 'reset',
      hasOverriddenOnExit: false,
      factory: $PasswordResetRouteData._fromState,
    ),
  ],
);

mixin $PasswordRecoveryRouteData on GoRouteData {
  static PasswordRecoveryRouteData _fromState(GoRouterState state) =>
      const PasswordRecoveryRouteData();

  @override
  String get location => GoRouteData.$location('/password-recovery');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $PasswordRecoverySentRouteData on GoRouteData {
  static PasswordRecoverySentRouteData _fromState(GoRouterState state) =>
      const PasswordRecoverySentRouteData();

  @override
  String get location => GoRouteData.$location('/password-recovery/sent');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $PasswordResetRouteData on GoRouteData {
  static PasswordResetRouteData _fromState(GoRouterState state) =>
      const PasswordResetRouteData();

  @override
  String get location => GoRouteData.$location('/password-recovery/reset');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $sessionExpiredRouteData => GoRouteData.$route(
  path: '/session-expired',
  hasOverriddenOnExit: false,
  factory: $SessionExpiredRouteData._fromState,
);

mixin $SessionExpiredRouteData on GoRouteData {
  static SessionExpiredRouteData _fromState(GoRouterState state) =>
      const SessionExpiredRouteData();

  @override
  String get location => GoRouteData.$location('/session-expired');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $mainShellRouteData => ShellRouteData.$route(
  factory: $MainShellRouteDataExtension._fromState,
  routes: [
    GoRouteData.$route(
      path: '/today',
      hasOverriddenOnExit: false,
      factory: $TodayRouteData._fromState,
    ),
    GoRouteData.$route(
      path: '/habits',
      hasOverriddenOnExit: false,
      factory: $HabitsRouteData._fromState,
      routes: [
        GoRouteData.$route(
          path: 'create',
          hasOverriddenOnExit: false,
          factory: $CreateHabitRouteData._fromState,
        ),
      ],
    ),
    GoRouteData.$route(
      path: '/challenges',
      hasOverriddenOnExit: false,
      factory: $ChallengesRouteData._fromState,
    ),
    GoRouteData.$route(
      path: '/friends',
      hasOverriddenOnExit: false,
      factory: $FriendsRouteData._fromState,
    ),
  ],
);

extension $MainShellRouteDataExtension on MainShellRouteData {
  static MainShellRouteData _fromState(GoRouterState state) =>
      const MainShellRouteData();
}

mixin $TodayRouteData on GoRouteData {
  static TodayRouteData _fromState(GoRouterState state) =>
      const TodayRouteData();

  @override
  String get location => GoRouteData.$location('/today');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $HabitsRouteData on GoRouteData {
  static HabitsRouteData _fromState(GoRouterState state) =>
      const HabitsRouteData();

  @override
  String get location => GoRouteData.$location('/habits');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $CreateHabitRouteData on GoRouteData {
  static CreateHabitRouteData _fromState(GoRouterState state) =>
      const CreateHabitRouteData();

  @override
  String get location => GoRouteData.$location('/habits/create');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ChallengesRouteData on GoRouteData {
  static ChallengesRouteData _fromState(GoRouterState state) =>
      const ChallengesRouteData();

  @override
  String get location => GoRouteData.$location('/challenges');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $FriendsRouteData on GoRouteData {
  static FriendsRouteData _fromState(GoRouterState state) =>
      const FriendsRouteData();

  @override
  String get location => GoRouteData.$location('/friends');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $inboxRouteData => GoRouteData.$route(
  path: '/inbox',
  hasOverriddenOnExit: false,
  factory: $InboxRouteData._fromState,
);

mixin $InboxRouteData on GoRouteData {
  static InboxRouteData _fromState(GoRouterState state) =>
      const InboxRouteData();

  @override
  String get location => GoRouteData.$location('/inbox');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $profileRouteData => GoRouteData.$route(
  path: '/profile',
  hasOverriddenOnExit: false,
  factory: $ProfileRouteData._fromState,
);

mixin $ProfileRouteData on GoRouteData {
  static ProfileRouteData _fromState(GoRouterState state) =>
      const ProfileRouteData();

  @override
  String get location => GoRouteData.$location('/profile');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $syncRecoveryRouteData => GoRouteData.$route(
  path: '/sync-recovery',
  hasOverriddenOnExit: false,
  factory: $SyncRecoveryRouteData._fromState,
);

mixin $SyncRecoveryRouteData on GoRouteData {
  static SyncRecoveryRouteData _fromState(GoRouterState state) =>
      const SyncRecoveryRouteData();

  @override
  String get location => GoRouteData.$location('/sync-recovery');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
