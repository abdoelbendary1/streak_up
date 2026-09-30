import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localization/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// The primary product brand name.
  ///
  /// In en, this message translates to:
  /// **'StreakUp'**
  String get brandName;

  /// Approved brand tagline.
  ///
  /// In en, this message translates to:
  /// **'Small steps today for a brighter tomorrow.'**
  String get brandTagline;

  /// Primary bottom navigation label for Today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get navToday;

  /// Primary bottom navigation label for Habits.
  ///
  /// In en, this message translates to:
  /// **'Habits'**
  String get navHabits;

  /// Primary bottom navigation label for Challenges.
  ///
  /// In en, this message translates to:
  /// **'Challenges'**
  String get navChallenges;

  /// Primary bottom navigation label for Friends.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get navFriends;

  /// Accessible label for the selected bottom navigation destination.
  ///
  /// In en, this message translates to:
  /// **'{destination}, selected tab'**
  String navSemanticsSelected(String destination);

  /// Accessible label for an unselected bottom navigation destination.
  ///
  /// In en, this message translates to:
  /// **'{destination} tab'**
  String navSemanticsUnselected(String destination);

  /// Global top bar action label for Inbox.
  ///
  /// In en, this message translates to:
  /// **'Inbox'**
  String get actionInbox;

  /// Global top bar action label for Profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get actionProfile;

  /// Action label to open Sync & Recovery.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get actionReview;

  /// Action label to navigate back to the previous context.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get actionBack;

  /// Action label for failed item recovery entry.
  ///
  /// In en, this message translates to:
  /// **'Review & retry'**
  String get actionRetry;

  /// Action label to dismiss transient feedback.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get actionDismiss;

  /// Action label directing the user to account/session recovery.
  ///
  /// In en, this message translates to:
  /// **'Account attention'**
  String get actionAccountRecovery;

  /// Title of the global Inbox destination.
  ///
  /// In en, this message translates to:
  /// **'Inbox'**
  String get screenInboxTitle;

  /// SL-01 host explanation for the Inbox destination.
  ///
  /// In en, this message translates to:
  /// **'Product notifications and social events will be provided by their owning slice.'**
  String get screenInboxPlaceholderBody;

  /// Title of the global Profile destination.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get screenProfileTitle;

  /// SL-01 host explanation for the Profile destination.
  ///
  /// In en, this message translates to:
  /// **'Account settings and language preference persistence belong to later slices.'**
  String get screenProfilePlaceholderBody;

  /// Title of the contextual Sync & Recovery destination.
  ///
  /// In en, this message translates to:
  /// **'Sync & Recovery'**
  String get screenSyncRecoveryTitle;

  /// SL-01 host explanation for Sync & Recovery.
  ///
  /// In en, this message translates to:
  /// **'Pending work and failed sync actions requiring review are inspected here.'**
  String get screenSyncRecoveryPlaceholderBody;

  /// Labeled SL-01 shell host title.
  ///
  /// In en, this message translates to:
  /// **'{destination} Area'**
  String hostPlaceholderTitle(String destination);

  /// Labeled SL-01 shell host subtitle.
  ///
  /// In en, this message translates to:
  /// **'Shell host ready for {sliceCode} destination content.'**
  String hostPlaceholderSubtitle(String sliceCode);

  /// Title for confirmed backend reachability.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get networkOnlineTitle;

  /// Accessible explanation for Online state.
  ///
  /// In en, this message translates to:
  /// **'Connected and ready to sync.'**
  String get networkOnlineDescription;

  /// Title for Offline connection banner.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline'**
  String get networkOfflineTitle;

  /// Explanation for Offline connection banner.
  ///
  /// In en, this message translates to:
  /// **'Your changes are saved on this device and will sync when you\'re back online.'**
  String get networkOfflineDescription;

  /// Title when restoring backend reachability.
  ///
  /// In en, this message translates to:
  /// **'Reconnecting'**
  String get networkReconnectingTitle;

  /// Explanation when restoring backend reachability.
  ///
  /// In en, this message translates to:
  /// **'Restoring connection to the server. Pending changes remain saved on this device.'**
  String get networkReconnectingDescription;

  /// Title when synchronization is in progress.
  ///
  /// In en, this message translates to:
  /// **'Syncing'**
  String get networkSyncingTitle;

  /// Explanation when synchronization is in progress.
  ///
  /// In en, this message translates to:
  /// **'Synchronizing your saved changes with the server.'**
  String get networkSyncingDescription;

  /// Title for the Sync Failed issue banner.
  ///
  /// In en, this message translates to:
  /// **'Sync issue'**
  String get networkSyncFailedTitle;

  /// Explanation for Sync Failed issue banner with count.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 change couldn\'t sync. Your data is safe on this device.} other{{count} changes couldn\'t sync. Your data is safe on this device.}}'**
  String networkSyncFailedDescription(int count);

  /// Compact title for Sync Failed banner.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 change couldn\'t sync} other{{count} changes couldn\'t sync}}'**
  String networkSyncFailedCompactTitle(int count);

  /// State-accurate compact subtitle for Sync Failed that does not promise automatic acceptance.
  ///
  /// In en, this message translates to:
  /// **'Review the affected activity to resolve this sync issue.'**
  String get networkSyncFailedCompactDescription;

  /// Title when pending work warrants attention.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 change waiting to sync} other{{count} changes waiting to sync}}'**
  String networkPendingQueueBannerTitle(int count);

  /// Subtitle when pending work awaits confirmation.
  ///
  /// In en, this message translates to:
  /// **'Saved on this device and waiting for remote confirmation.'**
  String get networkPendingQueueBannerDescription;

  /// Title when an authentication or session problem blocks sync.
  ///
  /// In en, this message translates to:
  /// **'Account attention required'**
  String get networkAuthRequiredTitle;

  /// Explanation distinguishing auth/session failure from transport offline.
  ///
  /// In en, this message translates to:
  /// **'Your session needs attention before changes can sync. Local data remains safe on this device.'**
  String get networkAuthRequiredDescription;

  /// Label for an action saved locally and waiting for remote acknowledgment.
  ///
  /// In en, this message translates to:
  /// **'Pending sync'**
  String get actionStatusPending;

  /// Label for an action saved locally while offline.
  ///
  /// In en, this message translates to:
  /// **'Saved offline'**
  String get actionStatusSavedOffline;

  /// Label for an action acknowledged remotely and reconciled.
  ///
  /// In en, this message translates to:
  /// **'Synced'**
  String get actionStatusSynced;

  /// Label for an action whose synchronization failed and needs attention.
  ///
  /// In en, this message translates to:
  /// **'Sync failed'**
  String get actionStatusFailed;

  /// Label indicating local completion separate from remote sync.
  ///
  /// In en, this message translates to:
  /// **'Completed locally'**
  String get actionLocalCompletedLabel;

  /// Combined accessible announcement for an action's local and remote status.
  ///
  /// In en, this message translates to:
  /// **'{actionLabel}: {localStatus}, {syncStatus}'**
  String actionSemanticsCombined(
    String actionLabel,
    String localStatus,
    String syncStatus,
  );

  /// Accessible prefix for success feedback.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get feedbackKindSuccess;

  /// Accessible prefix for informational feedback.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get feedbackKindInfo;

  /// Accessible prefix for warning feedback.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get feedbackKindWarning;

  /// Accessible prefix for recoverable error feedback.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get feedbackKindError;

  /// Accessible prefix for offline feedback.
  ///
  /// In en, this message translates to:
  /// **'Offline status'**
  String get feedbackKindOffline;

  /// Accessible prefix for sync feedback.
  ///
  /// In en, this message translates to:
  /// **'Sync status'**
  String get feedbackKindSync;

  /// Accessible prefix for action-required feedback.
  ///
  /// In en, this message translates to:
  /// **'Action required'**
  String get feedbackKindActionRequired;

  /// Message confirming local save while remote sync is still pending.
  ///
  /// In en, this message translates to:
  /// **'Saved on this device. Waiting for server confirmation.'**
  String get feedbackLocalSavePending;

  /// Coalesced summary message for repeated background sync events.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 background sync update in progress} other{{count} background sync updates in progress}}'**
  String feedbackBackgroundSyncCoalesced(int count);

  /// Title for shared loading state.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get stateLoadingTitle;

  /// Description for shared loading state, distinct from empty state.
  ///
  /// In en, this message translates to:
  /// **'Preparing your content. Please wait...'**
  String get stateLoadingDescription;

  /// Title for a truly empty state.
  ///
  /// In en, this message translates to:
  /// **'Nothing to show yet'**
  String get stateEmptyTitle;

  /// Default explanation for a truly empty state.
  ///
  /// In en, this message translates to:
  /// **'There are no items in this view right now.'**
  String get stateEmptyDescription;

  /// Title for shared inline error state.
  ///
  /// In en, this message translates to:
  /// **'Unable to load content'**
  String get stateErrorTitle;

  /// Default explanation for shared inline error state.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t load this section. Your saved local data is unaffected.'**
  String get stateErrorDescription;

  /// No description provided for @authRestoringTitle.
  ///
  /// In en, this message translates to:
  /// **'Getting things ready'**
  String get authRestoringTitle;

  /// No description provided for @authRestoringSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Restoring your session securely...'**
  String get authRestoringSubtitle;

  /// No description provided for @authSignInTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get authSignInTitle;

  /// No description provided for @authSignInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue your streaks.'**
  String get authSignInSubtitle;

  /// No description provided for @authEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmailLabel;

  /// No description provided for @authEmailHint.
  ///
  /// In en, this message translates to:
  /// **'name@example.com'**
  String get authEmailHint;

  /// No description provided for @authPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPasswordLabel;

  /// No description provided for @authPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get authPasswordHint;

  /// No description provided for @authConfirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get authConfirmPasswordLabel;

  /// No description provided for @authConfirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get authConfirmPasswordHint;

  /// No description provided for @authShowPasswordTooltip.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get authShowPasswordTooltip;

  /// No description provided for @authHidePasswordTooltip.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get authHidePasswordTooltip;

  /// No description provided for @authSignInButton.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get authSignInButton;

  /// No description provided for @authForgotPasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get authForgotPasswordButton;

  /// No description provided for @authOrDivider.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get authOrDivider;

  /// No description provided for @authNewToStreakUpPrompt.
  ///
  /// In en, this message translates to:
  /// **'New to StreakUp?'**
  String get authNewToStreakUpPrompt;

  /// No description provided for @authCreateAccountLink.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get authCreateAccountLink;

  /// No description provided for @authRegisterTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get authRegisterTitle;

  /// No description provided for @authRegisterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start building better habits, one streak at a time.'**
  String get authRegisterSubtitle;

  /// No description provided for @authCreateAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get authCreateAccountButton;

  /// No description provided for @authAlreadyHaveAccountPrompt.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get authAlreadyHaveAccountPrompt;

  /// No description provided for @authSignInLink.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get authSignInLink;

  /// No description provided for @authVerifyEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify your email'**
  String get authVerifyEmailTitle;

  /// No description provided for @authVerifyEmailSentTo.
  ///
  /// In en, this message translates to:
  /// **'We sent a verification link to'**
  String get authVerifyEmailSentTo;

  /// No description provided for @authVerifyEmailBody.
  ///
  /// In en, this message translates to:
  /// **'Verify your email before continuing to StreakUp.'**
  String get authVerifyEmailBody;

  /// No description provided for @authVerifyEmailPrimaryButton.
  ///
  /// In en, this message translates to:
  /// **'I\'ve Verified My Email'**
  String get authVerifyEmailPrimaryButton;

  /// No description provided for @authResendEmailButton.
  ///
  /// In en, this message translates to:
  /// **'Resend Email'**
  String get authResendEmailButton;

  /// No description provided for @authBackToSignInButton.
  ///
  /// In en, this message translates to:
  /// **'Back to Sign In'**
  String get authBackToSignInButton;

  /// No description provided for @authVerificationResentBanner.
  ///
  /// In en, this message translates to:
  /// **'Verification link sent. Please check your inbox.'**
  String get authVerificationResentBanner;

  /// No description provided for @authPasswordRecoveryTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset your password'**
  String get authPasswordRecoveryTitle;

  /// No description provided for @authPasswordRecoverySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and we\'ll send you a link to reset your password.'**
  String get authPasswordRecoverySubtitle;

  /// No description provided for @authSendResetLinkButton.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get authSendResetLinkButton;

  /// No description provided for @authPasswordRecoverySentTitle.
  ///
  /// In en, this message translates to:
  /// **'Check your email'**
  String get authPasswordRecoverySentTitle;

  /// No description provided for @authPasswordRecoverySentGenericBody.
  ///
  /// In en, this message translates to:
  /// **'If an account exists for that email, we\'ve sent a password reset link.'**
  String get authPasswordRecoverySentGenericBody;

  /// No description provided for @authPasswordRecoverySentFollowUp.
  ///
  /// In en, this message translates to:
  /// **'Follow the instructions in the email to reset your password.'**
  String get authPasswordRecoverySentFollowUp;

  /// No description provided for @authSendAgainButton.
  ///
  /// In en, this message translates to:
  /// **'Send Again'**
  String get authSendAgainButton;

  /// No description provided for @authRecoveryResentBanner.
  ///
  /// In en, this message translates to:
  /// **'If an account exists for that email, another reset link has been sent.'**
  String get authRecoveryResentBanner;

  /// No description provided for @authPasswordResetFormTitle.
  ///
  /// In en, this message translates to:
  /// **'Create a new password'**
  String get authPasswordResetFormTitle;

  /// No description provided for @authPasswordResetFormSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter and confirm your new password to secure your account.'**
  String get authPasswordResetFormSubtitle;

  /// No description provided for @authNewPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get authNewPasswordLabel;

  /// No description provided for @authSaveNewPasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get authSaveNewPasswordButton;

  /// No description provided for @authSessionExpiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Session expired'**
  String get authSessionExpiredTitle;

  /// No description provided for @authSessionExpiredSubtitle.
  ///
  /// In en, this message translates to:
  /// **'For your security, please sign in again to continue.'**
  String get authSessionExpiredSubtitle;

  /// No description provided for @authSignInAgainButton.
  ///
  /// In en, this message translates to:
  /// **'Sign In Again'**
  String get authSignInAgainButton;

  /// No description provided for @authSessionDataProtectedNote.
  ///
  /// In en, this message translates to:
  /// **'Your account data remains protected.'**
  String get authSessionDataProtectedNote;

  /// No description provided for @authSignOutWarningTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out with pending changes?'**
  String get authSignOutWarningTitle;

  /// No description provided for @authSignOutWarningLead.
  ///
  /// In en, this message translates to:
  /// **'Some changes haven\'t synced yet.'**
  String get authSignOutWarningLead;

  /// No description provided for @authSignOutWarningBody.
  ///
  /// In en, this message translates to:
  /// **'They\'ll stay safely on this device and resume when you sign in to this account again.'**
  String get authSignOutWarningBody;

  /// No description provided for @authStaySignedInButton.
  ///
  /// In en, this message translates to:
  /// **'Stay Signed In'**
  String get authStaySignedInButton;

  /// No description provided for @authSignOutAnywayButton.
  ///
  /// In en, this message translates to:
  /// **'Sign Out Anyway'**
  String get authSignOutAnywayButton;

  /// No description provided for @authSwitchAccountWarningTitle.
  ///
  /// In en, this message translates to:
  /// **'Switch accounts?'**
  String get authSwitchAccountWarningTitle;

  /// No description provided for @authSwitchAccountWarningLead.
  ///
  /// In en, this message translates to:
  /// **'You still have changes waiting to sync.'**
  String get authSwitchAccountWarningLead;

  /// No description provided for @authSwitchAccountWarningBody.
  ///
  /// In en, this message translates to:
  /// **'They\'ll stay with this account on this device and won\'t be available while you\'re using another account.'**
  String get authSwitchAccountWarningBody;

  /// No description provided for @authStayOnThisAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Stay on This Account'**
  String get authStayOnThisAccountButton;

  /// No description provided for @authSwitchAnywayButton.
  ///
  /// In en, this message translates to:
  /// **'Switch Anyway'**
  String get authSwitchAnywayButton;

  /// No description provided for @authSignOutAction.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get authSignOutAction;

  /// No description provided for @authSwitchAccountAction.
  ///
  /// In en, this message translates to:
  /// **'Switch Account'**
  String get authSwitchAccountAction;

  /// No description provided for @authErrorInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password. Please check your details and try again.'**
  String get authErrorInvalidCredentials;

  /// No description provided for @authErrorEmailAlreadyInUse.
  ///
  /// In en, this message translates to:
  /// **'Unable to create account with this email. Try signing in or resetting your password.'**
  String get authErrorEmailAlreadyInUse;

  /// No description provided for @authErrorWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters long.'**
  String get authErrorWeakPassword;

  /// No description provided for @authErrorPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get authErrorPasswordMismatch;

  /// No description provided for @authErrorInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get authErrorInvalidEmail;

  /// No description provided for @authErrorVerificationStillPending.
  ///
  /// In en, this message translates to:
  /// **'Your email hasn\'t been verified yet. Open the link in your inbox or request a new email.'**
  String get authErrorVerificationStillPending;

  /// No description provided for @authErrorVerificationLinkExpired.
  ///
  /// In en, this message translates to:
  /// **'This verification link is invalid or expired. Request a new verification email.'**
  String get authErrorVerificationLinkExpired;

  /// No description provided for @authErrorRecoveryLinkExpired.
  ///
  /// In en, this message translates to:
  /// **'This password reset link is invalid or expired. Request a new reset link.'**
  String get authErrorRecoveryLinkExpired;

  /// No description provided for @authErrorRateLimited.
  ///
  /// In en, this message translates to:
  /// **'Too many requests. Please wait a moment before trying again.'**
  String get authErrorRateLimited;

  /// No description provided for @authErrorNetworkOrBackend.
  ///
  /// In en, this message translates to:
  /// **'Unable to reach the server. Check your connection and try again.'**
  String get authErrorNetworkOrBackend;

  /// No description provided for @authErrorUnexpected.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get authErrorUnexpected;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
