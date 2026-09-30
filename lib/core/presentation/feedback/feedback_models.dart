import 'package:flutter/foundation.dart';
import 'package:streak_up/core/localization/app_localizations.dart';

/// Semantic feedback categories (`T040`, `SL01-FR-013`, `data-model.md`).
enum FeedbackKind {
  success,
  information,
  warning,
  recoverableError,
  offline,
  sync,
  actionRequired,
}

/// Presentation lifetime mode for a feedback item (`T040`, `SL01-FR-014`).
enum FeedbackLifetime {
  transient,
  persistent,
  inline,
}

/// Safe localized message keys supported by the SL-01 feedback coordinator.
///
/// Using an enum/typed key plus safe numeric count prevents raw private habit
/// names, friend details, or credentials from entering global banners/snackbars.
enum FeedbackMessageKey {
  localSavePending,
  backgroundSyncProgress,
  syncIssueNeedsReview,
  offlineSavedLocally,
  authAttentionRequired,
  recoverableActionError,
  generalInformation,
  generalWarning,
}

/// Optional action intent attached to a feedback item (`T040`, `AS-12`, `AS-14`).
@immutable
class FeedbackActionIntent {
  const FeedbackActionIntent({
    required this.actionId,
    required this.onTriggered,
    this.opensSyncRecovery = false,
    this.opensAccountRecovery = false,
  });

  final String actionId;
  final VoidCallback onTriggered;
  final bool opensSyncRecovery;
  final bool opensAccountRecovery;

  String localizedLabel(AppLocalizations l10n) {
    if (opensAccountRecovery) {
      return l10n.actionAccountRecovery;
    }
    if (opensSyncRecovery) {
      return l10n.actionReview;
    }
    return l10n.actionRetry;
  }
}

/// Immutable feedback descriptor consumed by the central coordinator (`T040`).
@immutable
class FeedbackDescriptor {
  const FeedbackDescriptor({
    required this.id,
    required this.kind,
    required this.messageKey,
    required this.lifetime,
    this.count = 1,
    this.isBackgroundSyncEvent = false,
    this.sourceActionKey,
    this.actionIntent,
  });

  final String id;
  final FeedbackKind kind;
  final FeedbackMessageKey messageKey;
  final FeedbackLifetime lifetime;
  final int count;
  final bool isBackgroundSyncEvent;
  final String? sourceActionKey;
  final FeedbackActionIntent? actionIntent;

  String resolveMessage(AppLocalizations l10n) {
    return switch (messageKey) {
      FeedbackMessageKey.localSavePending => l10n.feedbackLocalSavePending,
      FeedbackMessageKey.backgroundSyncProgress =>
        l10n.feedbackBackgroundSyncCoalesced(count),
      FeedbackMessageKey.syncIssueNeedsReview =>
        l10n.networkSyncFailedDescription(count),
      FeedbackMessageKey.offlineSavedLocally => l10n.networkOfflineDescription,
      FeedbackMessageKey.authAttentionRequired =>
        l10n.networkAuthRequiredDescription,
      FeedbackMessageKey.recoverableActionError => l10n.stateErrorDescription,
      FeedbackMessageKey.generalInformation => l10n.networkOnlineDescription,
      FeedbackMessageKey.generalWarning =>
        l10n.networkPendingQueueBannerDescription,
    };
  }

  String resolveKindPrefix(AppLocalizations l10n) {
    return switch (kind) {
      FeedbackKind.success => l10n.feedbackKindSuccess,
      FeedbackKind.information => l10n.feedbackKindInfo,
      FeedbackKind.warning => l10n.feedbackKindWarning,
      FeedbackKind.recoverableError => l10n.feedbackKindError,
      FeedbackKind.offline => l10n.feedbackKindOffline,
      FeedbackKind.sync => l10n.feedbackKindSync,
      FeedbackKind.actionRequired => l10n.feedbackKindActionRequired,
    };
  }

  FeedbackDescriptor copyWith({
    String? id,
    FeedbackKind? kind,
    FeedbackMessageKey? messageKey,
    FeedbackLifetime? lifetime,
    int? count,
    bool? isBackgroundSyncEvent,
    String? sourceActionKey,
    FeedbackActionIntent? actionIntent,
  }) {
    return FeedbackDescriptor(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      messageKey: messageKey ?? this.messageKey,
      lifetime: lifetime ?? this.lifetime,
      count: count ?? this.count,
      isBackgroundSyncEvent:
          isBackgroundSyncEvent ?? this.isBackgroundSyncEvent,
      sourceActionKey: sourceActionKey ?? this.sourceActionKey,
      actionIntent: actionIntent ?? this.actionIntent,
    );
  }
}
