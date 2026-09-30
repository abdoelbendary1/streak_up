// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get brandName => 'StreakUp';

  @override
  String get brandTagline => 'Small steps today for a brighter tomorrow.';

  @override
  String get navToday => 'Today';

  @override
  String get navHabits => 'Habits';

  @override
  String get navChallenges => 'Challenges';

  @override
  String get navFriends => 'Friends';

  @override
  String navSemanticsSelected(String destination) {
    return '$destination, selected tab';
  }

  @override
  String navSemanticsUnselected(String destination) {
    return '$destination tab';
  }

  @override
  String get actionInbox => 'Inbox';

  @override
  String get actionProfile => 'Profile';

  @override
  String get actionReview => 'Review';

  @override
  String get actionBack => 'Back';

  @override
  String get actionRetry => 'Review & retry';

  @override
  String get actionDismiss => 'Dismiss';

  @override
  String get actionAccountRecovery => 'Account attention';

  @override
  String get screenInboxTitle => 'Inbox';

  @override
  String get screenInboxPlaceholderBody =>
      'Product notifications and social events will be provided by their owning slice.';

  @override
  String get screenProfileTitle => 'Profile';

  @override
  String get screenProfilePlaceholderBody =>
      'Account settings and language preference persistence belong to later slices.';

  @override
  String get screenSyncRecoveryTitle => 'Sync & Recovery';

  @override
  String get screenSyncRecoveryPlaceholderBody =>
      'Pending work and failed sync actions requiring review are inspected here.';

  @override
  String hostPlaceholderTitle(String destination) {
    return '$destination Area';
  }

  @override
  String hostPlaceholderSubtitle(String sliceCode) {
    return 'Shell host ready for $sliceCode destination content.';
  }

  @override
  String get networkOnlineTitle => 'Online';

  @override
  String get networkOnlineDescription => 'Connected and ready to sync.';

  @override
  String get networkOfflineTitle => 'You\'re offline';

  @override
  String get networkOfflineDescription =>
      'Your changes are saved on this device and will sync when you\'re back online.';

  @override
  String get networkReconnectingTitle => 'Reconnecting';

  @override
  String get networkReconnectingDescription =>
      'Restoring connection to the server. Pending changes remain saved on this device.';

  @override
  String get networkSyncingTitle => 'Syncing';

  @override
  String get networkSyncingDescription =>
      'Synchronizing your saved changes with the server.';

  @override
  String get networkSyncFailedTitle => 'Sync issue';

  @override
  String networkSyncFailedDescription(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count changes couldn\'t sync. Your data is safe on this device.',
      one: '1 change couldn\'t sync. Your data is safe on this device.',
    );
    return '$_temp0';
  }

  @override
  String networkSyncFailedCompactTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count changes couldn\'t sync',
      one: '1 change couldn\'t sync',
    );
    return '$_temp0';
  }

  @override
  String get networkSyncFailedCompactDescription =>
      'Review the affected activity to resolve this sync issue.';

  @override
  String networkPendingQueueBannerTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count changes waiting to sync',
      one: '1 change waiting to sync',
    );
    return '$_temp0';
  }

  @override
  String get networkPendingQueueBannerDescription =>
      'Saved on this device and waiting for remote confirmation.';

  @override
  String get networkAuthRequiredTitle => 'Account attention required';

  @override
  String get networkAuthRequiredDescription =>
      'Your session needs attention before changes can sync. Local data remains safe on this device.';

  @override
  String get actionStatusPending => 'Pending sync';

  @override
  String get actionStatusSavedOffline => 'Saved offline';

  @override
  String get actionStatusSynced => 'Synced';

  @override
  String get actionStatusFailed => 'Sync failed';

  @override
  String get actionLocalCompletedLabel => 'Completed locally';

  @override
  String actionSemanticsCombined(
    String actionLabel,
    String localStatus,
    String syncStatus,
  ) {
    return '$actionLabel: $localStatus, $syncStatus';
  }

  @override
  String get feedbackKindSuccess => 'Success';

  @override
  String get feedbackKindInfo => 'Information';

  @override
  String get feedbackKindWarning => 'Warning';

  @override
  String get feedbackKindError => 'Error';

  @override
  String get feedbackKindOffline => 'Offline status';

  @override
  String get feedbackKindSync => 'Sync status';

  @override
  String get feedbackKindActionRequired => 'Action required';

  @override
  String get feedbackLocalSavePending =>
      'Saved on this device. Waiting for server confirmation.';

  @override
  String feedbackBackgroundSyncCoalesced(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count background sync updates in progress',
      one: '1 background sync update in progress',
    );
    return '$_temp0';
  }

  @override
  String get stateLoadingTitle => 'Loading';

  @override
  String get stateLoadingDescription =>
      'Preparing your content. Please wait...';

  @override
  String get stateEmptyTitle => 'Nothing to show yet';

  @override
  String get stateEmptyDescription =>
      'There are no items in this view right now.';

  @override
  String get stateErrorTitle => 'Unable to load content';

  @override
  String get stateErrorDescription =>
      'We couldn\'t load this section. Your saved local data is unaffected.';

  @override
  String get authRestoringTitle => 'Getting things ready';

  @override
  String get authRestoringSubtitle => 'Restoring your session securely...';

  @override
  String get authSignInTitle => 'Welcome back';

  @override
  String get authSignInSubtitle => 'Sign in to continue your streaks.';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authEmailHint => 'name@example.com';

  @override
  String get authPasswordLabel => 'Password';

  @override
  String get authPasswordHint => 'Enter your password';

  @override
  String get authConfirmPasswordLabel => 'Confirm Password';

  @override
  String get authConfirmPasswordHint => 'Confirm your password';

  @override
  String get authShowPasswordTooltip => 'Show password';

  @override
  String get authHidePasswordTooltip => 'Hide password';

  @override
  String get authSignInButton => 'Sign In';

  @override
  String get authForgotPasswordButton => 'Forgot password?';

  @override
  String get authOrDivider => 'or';

  @override
  String get authNewToStreakUpPrompt => 'New to StreakUp?';

  @override
  String get authCreateAccountLink => 'Create account';

  @override
  String get authRegisterTitle => 'Create your account';

  @override
  String get authRegisterSubtitle =>
      'Start building better habits, one streak at a time.';

  @override
  String get authCreateAccountButton => 'Create Account';

  @override
  String get authAlreadyHaveAccountPrompt => 'Already have an account?';

  @override
  String get authSignInLink => 'Sign In';

  @override
  String get authVerifyEmailTitle => 'Verify your email';

  @override
  String get authVerifyEmailSentTo => 'We sent a verification link to';

  @override
  String get authVerifyEmailBody =>
      'Verify your email before continuing to StreakUp.';

  @override
  String get authVerifyEmailPrimaryButton => 'I\'ve Verified My Email';

  @override
  String get authResendEmailButton => 'Resend Email';

  @override
  String get authBackToSignInButton => 'Back to Sign In';

  @override
  String get authVerificationResentBanner =>
      'Verification link sent. Please check your inbox.';

  @override
  String get authPasswordRecoveryTitle => 'Reset your password';

  @override
  String get authPasswordRecoverySubtitle =>
      'Enter your email and we\'ll send you a link to reset your password.';

  @override
  String get authSendResetLinkButton => 'Send Reset Link';

  @override
  String get authPasswordRecoverySentTitle => 'Check your email';

  @override
  String get authPasswordRecoverySentGenericBody =>
      'If an account exists for that email, we\'ve sent a password reset link.';

  @override
  String get authPasswordRecoverySentFollowUp =>
      'Follow the instructions in the email to reset your password.';

  @override
  String get authSendAgainButton => 'Send Again';

  @override
  String get authRecoveryResentBanner =>
      'If an account exists for that email, another reset link has been sent.';

  @override
  String get authPasswordResetFormTitle => 'Create a new password';

  @override
  String get authPasswordResetFormSubtitle =>
      'Enter and confirm your new password to secure your account.';

  @override
  String get authNewPasswordLabel => 'New Password';

  @override
  String get authSaveNewPasswordButton => 'Update Password';

  @override
  String get authSessionExpiredTitle => 'Session expired';

  @override
  String get authSessionExpiredSubtitle =>
      'For your security, please sign in again to continue.';

  @override
  String get authSignInAgainButton => 'Sign In Again';

  @override
  String get authSessionDataProtectedNote =>
      'Your account data remains protected.';

  @override
  String get authSignOutWarningTitle => 'Sign out with pending changes?';

  @override
  String get authSignOutWarningLead => 'Some changes haven\'t synced yet.';

  @override
  String get authSignOutWarningBody =>
      'They\'ll stay safely on this device and resume when you sign in to this account again.';

  @override
  String get authStaySignedInButton => 'Stay Signed In';

  @override
  String get authSignOutAnywayButton => 'Sign Out Anyway';

  @override
  String get authSwitchAccountWarningTitle => 'Switch accounts?';

  @override
  String get authSwitchAccountWarningLead =>
      'You still have changes waiting to sync.';

  @override
  String get authSwitchAccountWarningBody =>
      'They\'ll stay with this account on this device and won\'t be available while you\'re using another account.';

  @override
  String get authStayOnThisAccountButton => 'Stay on This Account';

  @override
  String get authSwitchAnywayButton => 'Switch Anyway';

  @override
  String get authSignOutAction => 'Sign Out';

  @override
  String get authSwitchAccountAction => 'Switch Account';

  @override
  String get authErrorInvalidCredentials =>
      'Invalid email or password. Please check your details and try again.';

  @override
  String get authErrorEmailAlreadyInUse =>
      'Unable to create account with this email. Try signing in or resetting your password.';

  @override
  String get authErrorWeakPassword =>
      'Password must be at least 8 characters long.';

  @override
  String get authErrorPasswordMismatch => 'Passwords do not match.';

  @override
  String get authErrorInvalidEmail => 'Enter a valid email address.';

  @override
  String get authErrorVerificationStillPending =>
      'Your email hasn\'t been verified yet. Open the link in your inbox or request a new email.';

  @override
  String get authErrorVerificationLinkExpired =>
      'This verification link is invalid or expired. Request a new verification email.';

  @override
  String get authErrorRecoveryLinkExpired =>
      'This password reset link is invalid or expired. Request a new reset link.';

  @override
  String get authErrorRateLimited =>
      'Too many requests. Please wait a moment before trying again.';

  @override
  String get authErrorNetworkOrBackend =>
      'Unable to reach the server. Check your connection and try again.';

  @override
  String get authErrorUnexpected => 'Something went wrong. Please try again.';
}
