import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:streak_up/app/bootstrap/app_logger.dart';
import 'package:streak_up/core/presentation/feedback/feedback_models.dart';

/// State of the central feedback presentation coordinator (`T040`).
@immutable
class FeedbackCoordinatorState {
  const FeedbackCoordinatorState({
    this.activeTransient,
    this.persistentBanners = const <FeedbackDescriptor>[],
    this.inlineFeedbackByAction = const <String, FeedbackDescriptor>{},
    this.coalescedBackgroundCount = 0,
  });

  final FeedbackDescriptor? activeTransient;
  final List<FeedbackDescriptor> persistentBanners;
  final Map<String, FeedbackDescriptor> inlineFeedbackByAction;
  final int coalescedBackgroundCount;

  /// SL-01 invariant (`SL01-FR-017`, `AS-17`): transient feedback never creates
  /// persistent product Inbox events.
  int get createdInboxEventCount => 0;

  FeedbackCoordinatorState copyWith({
    FeedbackDescriptor? activeTransient,
    bool clearActiveTransient = false,
    List<FeedbackDescriptor>? persistentBanners,
    Map<String, FeedbackDescriptor>? inlineFeedbackByAction,
    int? coalescedBackgroundCount,
  }) {
    return FeedbackCoordinatorState(
      activeTransient: clearActiveTransient
          ? null
          : (activeTransient ?? this.activeTransient),
      persistentBanners: persistentBanners ?? this.persistentBanners,
      inlineFeedbackByAction:
          inlineFeedbackByAction ?? this.inlineFeedbackByAction,
      coalescedBackgroundCount:
          coalescedBackgroundCount ?? this.coalescedBackgroundCount,
    );
  }
}

/// Central feedback coordinator (`T040`, `SL01-FR-013`–`014`, `SL01-FR-017`, `AS-12`–`14`, `AS-17`).
///
/// Responsibilities:
/// - Accepts typed [FeedbackDescriptor] items.
/// - Coalesces/suppresses repetitive background sync events so they do not
///   produce separate transient interruptions for each operation (`AS-13`).
/// - Ensures dismissing a transient message or banner never clears an unresolved
///   persistent or action-level failure (`AS-14`).
/// - Never creates product Inbox history (`AS-17`).
@lazySingleton
class FeedbackCoordinator extends Cubit<FeedbackCoordinatorState> {
  FeedbackCoordinator(this._logger) : super(const FeedbackCoordinatorState());

  final AppLogger _logger;

  void publish(FeedbackDescriptor descriptor) {
    _logger.info(
      'feedback.published',
      metadata: <String, Object?>{
        'feedbackKind': descriptor.kind.name,
        'count': descriptor.count,
      },
    );

    // Coalesce repetitive background sync events (SL01-FR-014, AS-13).
    if (descriptor.isBackgroundSyncEvent) {
      final newCount = state.coalescedBackgroundCount + descriptor.count;
      final coalescedDescriptor = descriptor.copyWith(
        id: 'coalesced_background_sync',
        messageKey: FeedbackMessageKey.backgroundSyncProgress,
        count: newCount,
      );
      emit(
        state.copyWith(
          activeTransient: coalescedDescriptor,
          coalescedBackgroundCount: newCount,
        ),
      );
      return;
    }

    switch (descriptor.lifetime) {
      case FeedbackLifetime.transient:
        emit(state.copyWith(activeTransient: descriptor));
      case FeedbackLifetime.persistent:
        final updated = List<FeedbackDescriptor>.from(
          state.persistentBanners.where((b) => b.id != descriptor.id),
        )..add(descriptor);
        final nextInline = Map<String, FeedbackDescriptor>.from(
          state.inlineFeedbackByAction,
        );
        if (descriptor.sourceActionKey != null) {
          nextInline[descriptor.sourceActionKey!] = descriptor;
        }
        emit(
          state.copyWith(
            persistentBanners: List<FeedbackDescriptor>.unmodifiable(updated),
            inlineFeedbackByAction:
                Map<String, FeedbackDescriptor>.unmodifiable(nextInline),
          ),
        );
      case FeedbackLifetime.inline:
        if (descriptor.sourceActionKey != null) {
          final nextInline = Map<String, FeedbackDescriptor>.from(
            state.inlineFeedbackByAction,
          )..[descriptor.sourceActionKey!] = descriptor;
          emit(
            state.copyWith(
              inlineFeedbackByAction:
                  Map<String, FeedbackDescriptor>.unmodifiable(nextInline),
            ),
          );
        }
    }
  }

  /// Dismisses only the transient snackbar/overlay without clearing any persistent
  /// banner or source-level action failure (`SL01-FR-014`, `AS-14`).
  void dismissTransient() {
    emit(
      state.copyWith(clearActiveTransient: true, coalescedBackgroundCount: 0),
    );
  }

  /// Dismisses a global banner while preserving any underlying source-level
  /// inline failure so recovery remains discoverable (`AS-14`).
  void dismissBannerOnly(String bannerId) {
    // Keep inlineFeedbackByAction intact so users never lose access to recovery for an unresolved source failure.
    final remaining = state.persistentBanners
        .where((b) => b.id != bannerId)
        .toList(growable: false);
    emit(
      state.copyWith(
        persistentBanners: List<FeedbackDescriptor>.unmodifiable(remaining),
      ),
    );
  }

  /// Resolves a source-level failure only when the owning slice explicitly reports resolution.
  void resolveSourceFailure(String sourceActionKey) {
    final nextInline = Map<String, FeedbackDescriptor>.from(
      state.inlineFeedbackByAction,
    )..remove(sourceActionKey);
    final nextBanners = state.persistentBanners
        .where((b) => b.sourceActionKey != sourceActionKey)
        .toList(growable: false);
    emit(
      state.copyWith(
        persistentBanners: List<FeedbackDescriptor>.unmodifiable(nextBanners),
        inlineFeedbackByAction: Map<String, FeedbackDescriptor>.unmodifiable(
          nextInline,
        ),
      ),
    );
  }

  /// Clears all active transient, persistent banner, and inline feedback from
  /// the outgoing account session (`T017`, `SL02-FR-008`–`011`).
  void resetForAccountTransition() {
    emit(const FeedbackCoordinatorState());
  }
}
